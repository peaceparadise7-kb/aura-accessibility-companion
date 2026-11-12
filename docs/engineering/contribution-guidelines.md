# AURA Contribution Guidelines

Welcome to the AURA project. As an accessibility-focused application for visually impaired and elderly users, our engineering quality and verification standards are exceptionally high.

---

## 1. Branching Strategy

We follow GitHub Flow with strict feature branches:
- `main` / `master`: Production-ready, fully tested releases.
- `develop`: Integration branch for active phase development.
- `feature/<issue-number>-<short-description>`: Individual feature work.
- `fix/<issue-number>-<short-description>`: Bug and regression fixes.

---

## 2. Commit Message Convention

We strictly adhere to [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Types:
- `feat`: New user-facing accessibility feature or capability.
- `fix`: Bug fix in recognition, UI, or platform adapters.
- `docs`: Documentation updates or ADR additions.
- `style`: Formatting, missing semi-colons, no code changes.
- `refactor`: Refactoring without changing functional behavior.
- `test`: Adding or refactoring unit, widget, or contract tests.
- `chore`: Build scripts, CI workflow changes, dependencies.

### Scopes:
`mobile`, `backend`, `native-android`, `native-ios`, `ml`, `shared`, `infra`

---

## 3. Pull Request Requirements

Before opening a Pull Request:
1. Ensure all formatting checks pass (`dart format`, `ruff check`).
2. Ensure static analysis passes with zero warnings (`flutter analyze`, `ruff`).
3. Ensure all tests pass (`flutter test`, `pytest`).
4. Validate that all new accessibility elements provide explicit `Semantics` tags, >= 48dp touch targets, and auditory cues.
5. Never introduce unverified dependencies or commit secrets/API keys.
