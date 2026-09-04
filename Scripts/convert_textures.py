#!/usr/bin/env python3
"""PNG to BLP2 converter for WoW addons.

Converts PNG images to BLP2 format (RAW3 uncompressed BGRA, used by WoW).
Follows the official BLP2 specification from wowdev.wiki/BLP.

No external dependencies required (Python 3.6+ stdlib only).

Usage:
    python3 Scripts/convert_textures.py Textures/**/*.png
    python3 Scripts/convert_textures.py --all
    python3 Scripts/convert_textures.py --dry-run Textures/
"""
import struct
import zlib
import sys
import argparse
from collections import namedtuple
from pathlib import Path
from typing import BinaryIO, List, Optional, Tuple

# ---------------------------------------------------------------------------
# PNG reader (handles common color types: grayscale, RGB, RGBA)
# ---------------------------------------------------------------------------

_PNG_SIGNATURE = b'\x89PNG\r\n\x1a\n'

IHDR = namedtuple('IHDR', ['width', 'height', 'bit_depth', 'color_type',
                            'compression', 'filter_method', 'interlace'])

# Maps PNG color_type -> number of channels (bytes per pixel before RGBA conversion)
_STRIDE_MAP: dict = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}


def _read_png_chunks(f: BinaryIO):
    """Yield (type, data) chunks from an open PNG file."""
    sig = f.read(8)
    if sig != _PNG_SIGNATURE:
        raise ValueError("Not a valid PNG file")
    while True:
        raw = f.read(4)
        if len(raw) < 4:
            break
        length = struct.unpack('>I', raw)[0]
        ctype = f.read(4)
        data = f.read(length)
        f.read(4)  # CRC
        yield ctype, data
        if ctype == b'IEND':
            break


def _defilter(scanlines: list, width: int, stride: int,
              filter_type: int, y: int) -> None:
    """Apply PNG row filter in-place."""
    if filter_type == 0:
        return
    prev = scanlines[y - 1] if y > 0 else None
    cur = scanlines[y]
    for i in range(len(cur)):
        a = cur[i - stride] if i >= stride else 0
        b = prev[i] if prev else 0
        c = prev[i - stride] if prev and i >= stride else 0
        if filter_type == 1:  # Sub
            cur[i] = (cur[i] + a) & 0xFF
        elif filter_type == 2:  # Up
            cur[i] = (cur[i] + b) & 0xFF
        elif filter_type == 3:  # Average
            cur[i] = (cur[i] + (a + b) // 2) & 0xFF
        elif filter_type == 4:  # Paeth
            p = a + b - c
            pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
            if pa <= pb and pa <= pc:
                cur[i] = (cur[i] + a) & 0xFF
            elif pb <= pc:
                cur[i] = (cur[i] + b) & 0xFF
            else:
                cur[i] = (cur[i] + c) & 0xFF


def _convert_scanlines_to_rgba(
    scanlines: list,
    width: int,
    height: int,
    stride: int,
    color_type: int,
    palette: Optional[bytes],
) -> bytes:
    """Convert defiltered scanlines into flat RGBA bytes."""
    rgba = bytearray(width * height * 4)
    for y in range(height):
        sl = scanlines[y]
        for x in range(width):
            d = (y * width + x) * 4
            s = x * stride
            if color_type == 0:  # Grayscale
                v = sl[s]
                rgba[d:d + 4] = bytes([v, v, v, 255])
            elif color_type == 2:  # RGB
                rgba[d:d + 3] = sl[s:s + 3]
                rgba[d + 3] = 255
            elif color_type == 3:  # Indexed
                idx = sl[s]
                if palette is None:
                    raise ValueError("Indexed PNG missing PLTE chunk")
                rgba[d:d + 3] = palette[idx * 3:idx * 3 + 3]
                rgba[d + 3] = 255
            elif color_type == 4:  # Gray + Alpha
                v, a = sl[s], sl[s + 1]
                rgba[d:d + 4] = bytes([v, v, v, a])
            elif color_type == 6:  # RGBA
                rgba[d:d + 4] = sl[s:s + 4]
    return bytes(rgba)


def read_png(path: str | Path) -> Tuple[int, int, bytes]:
    """Read a PNG file. Returns (width, height, rgba_bytes)."""
    ihdr = None
    palette = None
    idat_parts: list[bytes] = []

    with open(path, 'rb') as f:
        for ctype, data in _read_png_chunks(f):
            if ctype == b'IHDR':
                ihdr = IHDR(*struct.unpack('>IIBBBBB', data))
            elif ctype == b'PLTE':
                palette = data
            elif ctype == b'IDAT':
                idat_parts.append(data)

    if ihdr is None:
        raise ValueError("Missing IHDR chunk")
    if ihdr.bit_depth != 8:
        raise ValueError(f"Only 8-bit depth supported (got {ihdr.bit_depth})")
    if ihdr.color_type not in _STRIDE_MAP:
        raise ValueError(f"Unsupported PNG color type: {ihdr.color_type}")

    stride = _STRIDE_MAP[ihdr.color_type]
    raw = zlib.decompress(b''.join(idat_parts))

    # Defilter scanlines
    scanlines: list[bytearray] = []
    pos = 0
    row_bytes = ihdr.width * stride
    for y in range(ihdr.height):
        ft = raw[pos]
        pos += 1
        sl = bytearray(raw[pos:pos + row_bytes])
        pos += row_bytes
        scanlines.append(sl)
        _defilter(scanlines, ihdr.width, stride, ft, y)

    rgba = _convert_scanlines_to_rgba(
        scanlines, ihdr.width, ihdr.height, stride, ihdr.color_type, palette,
    )
    return ihdr.width, ihdr.height, rgba


# ---------------------------------------------------------------------------
# BLP2 writer (RAW3 uncompressed BGRA)
#
# Based on official spec: https://wowdev.wiki/BLP
# ---------------------------------------------------------------------------

BLP2_MAGIC = b'BLP2'
BLP2_VERSION = 1
BLP2_COLOR_ENCODING_RAW3 = 3
BLP2_ALPHA_BIT_DEPTH = 8
BLP2_ALPHA_TYPE = 8  # PIXEL_UNSPECIFIED

BLP2_HEADER_SIZE = 1172  # 148 header + 1024 palette

# Header field offsets
_OFF_MAGIC = 0x00
_OFF_VERSION = 0x04
_OFF_COLOR_ENCODING = 0x08
_OFF_ALPHA_BIT_DEPTH = 0x09
_OFF_ALPHA_TYPE = 0x0A
_OFF_HAS_MIPMAPS = 0x0B
_OFF_WIDTH = 0x0C
_OFF_HEIGHT = 0x10
_OFF_MIP_OFFSETS = 0x14
_OFF_MIP_SIZES = 0x54
_OFF_PALETTE = 0x94


def _swap_rgba_to_bgra(rgba: bytes) -> bytearray:
    """Swap R and B channels: RGBA -> BGRA."""
    bgra = bytearray(len(rgba))
    for i in range(0, len(rgba), 4):
        bgra[i]     = rgba[i + 2]  # B
        bgra[i + 1] = rgba[i + 1]  # G
        bgra[i + 2] = rgba[i]      # R
        bgra[i + 3] = rgba[i + 3]  # A
    return bgra


def write_blp(path: str | Path, width: int, height: int, rgba: bytes) -> None:
    """Write a BLP2 file with RAW3 (uncompressed BGRA) encoding."""
    bgra = _swap_rgba_to_bgra(rgba)
    hdr = bytearray(BLP2_HEADER_SIZE)

    # Header fields
    hdr[_OFF_MAGIC:_OFF_MAGIC + 4] = BLP2_MAGIC
    struct.pack_into('<I', hdr, _OFF_VERSION, BLP2_VERSION)
    hdr[_OFF_COLOR_ENCODING] = BLP2_COLOR_ENCODING_RAW3
    hdr[_OFF_ALPHA_BIT_DEPTH] = BLP2_ALPHA_BIT_DEPTH
    hdr[_OFF_ALPHA_TYPE] = BLP2_ALPHA_TYPE
    hdr[_OFF_HAS_MIPMAPS] = 0
    struct.pack_into('<I', hdr, _OFF_WIDTH, width)
    struct.pack_into('<I', hdr, _OFF_HEIGHT, height)

    # Mipmap offsets and sizes (only level 0)
    data_size = len(bgra)
    struct.pack_into('<I', hdr, _OFF_MIP_OFFSETS, BLP2_HEADER_SIZE)
    struct.pack_into('<I', hdr, _OFF_MIP_SIZES, data_size)

    # Palette is zeroed by bytearray (unused for RAW3)

    with open(path, 'wb') as f:
        f.write(hdr)
        f.write(bgra)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def collect_pngs(args: argparse.Namespace) -> List[Path]:
    """Resolve CLI arguments into a list of PNG Paths."""
    paths: list[Path] = []
    if args.all:
        textures = Path('Textures')
        if not textures.exists():
            print("Error: Textures/ directory not found", file=sys.stderr)
            sys.exit(1)
        paths.extend(sorted(textures.rglob('*.png')))
    else:
        for arg in args.inputs:
            p = Path(arg)
            if p.is_dir():
                gen = p.rglob('*.png') if args.recursive else p.glob('*.png')
                paths.extend(sorted(gen))
            elif p.is_file() and p.suffix.lower() == '.png':
                paths.append(p)
            else:
                print(f"  Skipping {arg}", file=sys.stderr)
    return paths


def main() -> None:
    ap = argparse.ArgumentParser(
        description='Convert PNG textures to BLP2 (RAW3) for WoW addons.')
    ap.add_argument('inputs', nargs='*', help='PNG files or directories')
    ap.add_argument('-r', '--recursive', action='store_true',
                    help='Recurse into subdirectories')
    ap.add_argument('-o', '--output-dir',
                    help='Output directory (default: same as input)')
    ap.add_argument('--all', action='store_true',
                    help='Convert every PNG under Textures/')
    ap.add_argument('--dry-run', action='store_true',
                    help='List files without converting')
    args = ap.parse_args()

    pngs = collect_pngs(args)
    if not pngs:
        print("No PNG files found.", file=sys.stderr)
        sys.exit(1)

    ok, fail = 0, 0
    for png in pngs:
        out_dir = Path(args.output_dir) if args.output_dir else png.parent
        blp = out_dir / (png.stem + '.blp')
        if args.dry_run:
            print(f"  {png} -> {blp}")
            continue
        try:
            w, h, rgba = read_png(png)
            write_blp(blp, w, h, rgba)
            kb = blp.stat().st_size / 1024
            print(f"  {png} -> {blp}  ({w}x{h}, {kb:.1f} KB)")
            ok += 1
        except Exception as exc:
            print(f"  ERROR {png}: {exc}", file=sys.stderr)
            fail += 1

    if not args.dry_run:
        print(f"\nConverted: {ok}  Errors: {fail}")


if __name__ == '__main__':
    main()
