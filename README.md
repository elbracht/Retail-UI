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
