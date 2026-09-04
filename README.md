# Retail UI

World of Warcraft (Classic Era) addon that brings the modern retail UI to Classic.

This project is being rebuilt from scratch, feature by feature, with a focus on
simple, clean implementations rather than a one-to-one port.

## Status

Early setup. No user-facing features yet — just the addon skeleton (Ace3
bootstrap, saved variables, options panel).

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

## Install (manual, for development)

Copy this repository into
`World of Warcraft\_classic_era_\Interface\AddOns\`, making sure the folder is
named `RetailUI`.
