# Semantic Commits

Always use semantic commits following the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>
```

**Types:**
- `feat` — New feature
- `fix` — Bug fix
- `docs` — Documentation only
- `style` — Formatting, no code change
- `refactor` — Code restructuring, no feature/fix
- `test` — Adding or updating tests
- `chore` — Build, CI, tooling

**Examples:**
```
feat(config): add profile switching
fix(core): handle missing saved variables
docs: update install instructions
chore(ci): add luacheck workflow
```
