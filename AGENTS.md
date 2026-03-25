# AGENTS.md

> Template for AI coding agents.

---

## Project Snapshot

- Project name: mber_base
- Project type: mobile app / library
- One-line description: Base template and core framework for games developed by M-BER studio using Godot Engine.
- Primary users: Game developers at M-BER studio.
- Business/domain context: Mobile game development (Android/iOS).
- Lifecycle stage: prototype
- Maintainers / owning team: Peter Zakharov
- Default branch: <main_branch_name>
- Repo status notes: active development; iOS build and multiple game genre templates in TODO list.

---

## Agent Principles

Unless the user explicitly asks otherwise, the agent should:

- prefer the smallest safe change that solves the task;
- preserve existing architecture and naming conventions;
- update tests when behavior changes;
- update docs, config, or examples when they become stale because of the change;
- verify work before finishing;
- avoid speculative refactors;
- ask before destructive, irreversible, expensive, or production-affecting operations.

### Optimize For

1. Correctness
2. Maintainability
3. Speed

---

## Sources Of Truth

Consult these references before making non-trivial changes:

| Source | Path / URL | When To Use It |
| --- | --- | --- |
| Project Configuration | `mber-base/project.godot` | Checking engine settings, autoloads, and display resolution |
| Export Settings | `mber-base/export_presets.cfg` | Investigating Android/iOS build configurations and permissions |
| Dependencies & Tasks | `README.md` | Checking required SDK tools or project roadmap |

If documentation and code disagree, prefer `code` and mention the mismatch in your final summary.

---

## Tech Stack

### Core Stack

- Language(s): GDScript, Bash, Python
- Runtime(s): Godot 4.6
- Framework(s): Godot Engine
- Package manager(s): <package_managers_and_versions>
- Build tool(s): Godot Export CLI, Custom Bash scripts
- Database(s): <db_and_versions>
- Messaging / queueing: none
- Cache / storage: <tool_or_none>
- Hosting / infrastructure: mobile (Android/iOS)

### Key Libraries And Services

| Area | Library / Service | Version | Purpose | Notes / Constraints |
| --- | --- | --- | --- | --- |
| Physics | Jolt Physics | <version> | 3D Physics engine | Specified in project.godot |
| SDK | JDK | 17 | Android Build | Required for Gradle |
| Rendering | GL Compatibility | <version> | Mobile rendering | Set as default for mobile |

### Version Policy

- Required versions: Godot 4.6, JDK 17
- Version source of truth: `README.md`
- Dependency update policy: <manual | renovate | dependabot | scheduled>
- Compatibility requirements: Android SDK Min 24, Target 35

---

## Architecture

- Architecture style: Signal-driven / Singleton-managed (Godot standard)
- High-level description: Centralized management through a GameManager singleton for scene transitions and UI stacks.
- Main modules / bounded contexts: core (GameManager), ui (Common/Main Menu), scenes, scripts (Build/Platform)
- Main data flow: Nodes -> GameManager (Autoload) -> SceneTree
- State management approach: GameManager handles menu stacks and async loading.
- Integration boundaries: Android/iOS OS signals (vibration, safe area, back button).
- Areas under migration: iOS build system is currently a placeholder.
- Hard constraints: Must support high-resolution mobile displays (1920x1080) and safe-area margins.

### Architectural Rules

- Put `Global Logic` in `mber-base/core/`, not in `individual scenes`.
- Keep `UI logic` independent from `business logic` by using GameManager safe-area and menu methods.
- New work in `Build scripts` must follow `scripts/android/build.sh` pattern.
- Reuse abstractions from `SafeAreContainer.gd` for all mobile UI layouts.

---

## Repository Structure

```text
./
├─ mber-base/            # Main Godot project directory
│  ├─ assets/            # Fonts, textures, and .tres themes
│  ├─ core/              # GameManager.gd and global singletons
│  ├─ scenes/            # Tscn files and accompanying scripts
│  ├─ ui/                # UI components and safe-area handling
│  └─ project.godot      # Godot engine project file
├─ scripts/              # Automation and build scripts
│  ├─ android/           # Android build bash scripts
│  └─ ios/               # iOS build placeholders
└─ README.md             # Project documentation
```

### Directory Responsibilities

| Path | Responsibility | Typical Contents | Must Not Contain |
| --- | --- | --- | --- |
| `mber-base/core/` | Global state & orchestration | `GameManager.gd` | UI specific nodes |
| `mber-base/ui/common/` | Reusable UI logic | `SafeAreaContainer.gd` | Game-specific mechanics |
| `scripts/` | Project automation | `.sh`, `.py` scripts | Game assets or GDScript |

---

## Environment Setup

### Required Tooling

- Required tools: Godot 4.6, JDK 17, Android Studio SDK Tools (Build-tools, Platform-tools, CMake, NDK)
- Install dependencies: <exact_command>
- Start local environment: Open `mber-base/project.godot` in Godot Editor
- Start dependent services only: <exact_command>
- Seed / bootstrap data: <exact_command>
- Load environment variables from: <path>
- Required local services: none

---

## Development Commands

| Task | Command | Scope | Notes |
| --- | --- | --- | --- |
| Build Android (Release) | `./scripts/android/build.sh` | repo | Outputs to /dist |
| Build Android (Debug) | `./scripts/android/build.sh --debug` | repo | |
| Generate Tree | `./scripts/repo2txt` | repo | Internal tool for code dumping |

---

## Testing Guide

- Test framework(s): <frameworks>
- Unit test location(s): <paths>
- Integration test location(s): <paths>
- E2E test location(s): <paths>
- Naming pattern(s): <*.test.ts | test_*.py | etc>
- CI workflow location: <path>

---

## Code Style And Naming

- Formatter: Built-in Godot Formatter
- Linter: Godot GDScript Linter
- Type policy: Moderate (Optional static typing in GDScript)
- Comments policy: Heading blocks for sections (e.g., `── Menu stack ──`)
- Import policy: `uid://` or `res://` paths

### Naming Conventions We Prefer

| Item | Preferred | Avoid | Example |
| --- | --- | --- | --- |
| Files | snake_case | PascalCase | `main_menu.gd` |
| Classes / components | PascalCase | snake_case | `class_name GameManager` |
| Functions / methods | snake_case | camelCase | `_on_test_button_pressed` |
| Variables (Private) | `_` prefix | public names | `_menu_stack` |

---

## Preferred Patterns And Reference Implementations

### Good Examples To Copy

- `mber-base/core/GameManager.gd`: Implementation of async scene loading and UI stack management.
- `mber-base/ui/common/SafeAreaContainer.gd`: Dynamic calculation of mobile safe areas.

---

## Data, Contracts, Codegen, And Migrations

- Schema location: <path>
- Migration location: <path>
- API contract location: <path>
- Event contract location: <path_or_none>
- Generated code location: <path>
- Regeneration command: <command>

---

## Security And Safety Boundaries

### Hard Rules

- Never commit keystore files or passwords in `export_presets.cfg`.
- Never hardcode Android/iOS sensitive permissions unless necessary.

### Human Approval Required Before

- Modifying `export_presets.cfg` for production releases.
- Changing `GameManager.gd` core loading logic.

---

## Git, PR, And Definition Of Done

- Branch naming convention: <pattern>
- Commit message convention: <pattern>
- PR title convention: <pattern>
- Changelog policy: <when_and_how_to_update>

---

## Known Pitfalls

- **Viewport Scaling**: Always use `SafeAreaContainer` for UI elements to avoid content being cut off by notches or home indicators.
- **Async Loading**: Ensure the requested resource is a `PackedScene` before calling `change_scene_to_packed` in the `GameManager`.
