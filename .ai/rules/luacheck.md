# Luacheck

After making changes to any `.lua` files, always run `luacheck .` to verify the code has no errors or warnings.

## `.luacheckrc` globals

When adding WoW API functions, frames, or other environment globals to `.luacheckrc`:

- Use `globals`, **not** `read_globals`. `globals` allows read and write access, which matches how WoW API works (the client provides these, addons call them). `read_globals` only allows reads and flags writes as errors, which is unnecessarily restrictive for WoW API.
- Group entries by category using comments:
  - `-- WoW API: Namespaces` — e.g. `C_AddOns`, `C_Item`, `C_Timer`
  - `-- WoW API: UI` — e.g. `CreateFrame`, `UIParent`, frame names
  - `-- WoW API: Functions` — standalone API functions like `UnitHealth`, `GetTime`
  - `-- Addon Libraries` — e.g. `LibStub`
  - `-- Lua Built-ins` — only if overriding standard globals (avoid if possible)
- Keep categories alphabetically sorted within each group.
