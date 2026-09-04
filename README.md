# Retail UI

World of Warcraft (Classic Era) addon that brings the modern retail UI to Classic.

## Development

- Built on [Ace3](https://www.wowace.com/projects/ace3) (`AceAddon`, `AceDB`,
  `AceConfig`, ...), vendored under `Libs/`.
- Targets Classic Era (current interface version in `RetailUI.toc`).
- Configure in-game with `/rui` or `/retailui`.

## Linting

This project uses [luacheck](https://github.com/lunarmodules/luacheck) for static analysis.

**Install locally:**

```sh
# Windows (WSL)
sudo apt-get install lua-check

# macOS
brew install luacheck
```

**Run:**

```sh
luacheck .
```

Luacheck runs automatically on every push and pull request via GitHub Actions.

## Texture Conversion

PNG source files are converted to BLP2 format (RAW3 with alpha) for WoW. BLP files are git-ignored (build artifacts).

**Convert all textures:**

```sh
python3 Scripts/convert_textures.py --all
```

**Convert specific files:**

```sh
python3 Scripts/convert_textures.py Textures/UnitFrame/PlayerFrame/PlayerFrame.png
```

**Dry run (preview only):**

```sh
python3 Scripts/convert_textures.py --dry-run --all
```

No external dependencies required (Python 3.6+ stdlib only).
