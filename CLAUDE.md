# CLAUDE.md - SwiftSnake Project Guide

## Project Overview

SwiftSnake is a modern iOS Snake game built with SwiftUI and SwiftData. It implements the classic Nokia Snake gameplay with touch controls, score tracking, and a persistent ranking system. The project uses MVVM architecture with no external dependencies.

## Tech Stack

- **Language**: Swift 6 (Swift 5.0 compatibility mode)
- **UI**: SwiftUI
- **Persistence**: SwiftData
- **Concurrency**: Swift 6 structured concurrency (`@MainActor`, `Task`, `async/await`)
- **Accessibility**: VoiceOver support, custom accessibility actions, announcements
- **Testing**: Swift Testing framework (unit tests), XCTest (UI tests)
- **Build System**: Xcode project (`.xcodeproj`) — no SPM, no CocoaPods
- **Minimum iOS**: 18.2
- **Targets**: iPhone and iPad

## Repository Structure

```
swiftSnake/
├── swiftSnake/                    # Main app source
│   ├── swiftSnakeApp.swift        # @main entry point, SwiftData container setup
│   ├── Models/
│   │   ├── SnakeGameModel.swift   # @MainActor game logic (movement, collisions, scoring)
│   │   ├── ScoreRecord.swift      # SwiftData @Model for persistent scores
│   │   ├── GameData.swift         # Game state data model (unused, reserved for v2)
│   │   ├── HUDViewModel.swift     # @MainActor GHUDViewModel — HUD formatting logic
│   │   ├── RankingViewModel.swift # @MainActor ranking display formatting
│   │   └── HashableCGPoint.swift  # Legacy file (empty — CGPoint is Hashable in iOS 18+)
│   ├── Views/
│   │   ├── WelcomeView.swift      # Main menu with top 5 scores + VoiceOver
│   │   ├── GameView.swift         # Gameplay screen + accessibility actions for directions
│   │   ├── GameHUDView.swift      # Score/time HUD overlay + accessibility
│   │   ├── NameEntryView.swift    # Post-game name input + save + accessibility
│   │   └── RankingView.swift      # Top 10 ranking display + accessibility
│   ├── Assets.xcassets/           # App icons, colors
│   └── Preview Content/           # SwiftUI preview assets
├── swiftSnakeTests/               # Unit tests (Swift Testing, @MainActor)
│   └── swiftSnakeTests.swift
├── swiftSnakeUITests/             # UI tests (XCTest)
│   ├── swiftSnakeUITests.swift
│   └── swiftSnakeUITestsLaunchTests.swift
└── swiftSnake.xcodeproj/          # Xcode project config
```

## Build & Test

This is a native Xcode project. There is no command-line build pipeline configured.

- **Build**: Open `swiftSnake.xcodeproj` in Xcode 15+, build with `Cmd+B`
- **Run**: Select a simulator or device, run with `Cmd+R`
- **Test**: Run all tests with `Cmd+U` in Xcode

### Unit Tests

Located in `swiftSnakeTests/swiftSnakeTests.swift`. Uses the Swift Testing framework (`import Testing`). The test suite is `@MainActor`-isolated for SwiftData and game model compatibility:
- `scoreRecordEfficiencyShouldBeCorrect()` — verifies efficiency = score / duration
- `scoreRecordEfficiencyZeroDuration()` — verifies zero-duration edge case returns 0
- `formatDateShouldReturnString()` — verifies date formatting produces non-empty output
- `directionChangeBlocksOpposite()` — verifies 180-degree direction reversal is blocked

Tests use `@testable import swiftSnake` and the `#expect(...)` assertion macro.

### UI Tests

Located in `swiftSnakeUITests/`. Uses XCTest. Currently contains template scaffolding.

## Architecture

**MVVM pattern** with clear separation and Swift 6 concurrency safety:

- **Models**: `SnakeGameModel` (`@MainActor ObservableObject`), `ScoreRecord` (SwiftData `@Model`), `GameRecord` (`Codable`, `Sendable` struct), `GameData`
- **ViewModels**: `GHUDViewModel`, `RankingViewModel` — both `@MainActor` for thread-safe UI updates
- **Views**: SwiftUI views using `@StateObject`, `@Environment(\.modelContext)` for dependency injection

### Concurrency Model (Swift 6)

All `ObservableObject` classes are `@MainActor`-isolated:
- `SnakeGameModel` — game loop uses `Task` with `Task.sleep` instead of `Timer.scheduledTimer`, eliminating data race vulnerabilities
- `GHUDViewModel` — `@MainActor` ensures `@Published` properties are updated safely
- `RankingViewModel` — `@MainActor` for safe UI-bound data access
- `Direction` enum — explicitly `Sendable`
- `GameRecord` struct — explicitly `Sendable`

### Key Game Mechanics (SnakeGameModel)

- Grid-based movement on a 20px grid
- Game area: 400x800 points (hardcoded — not adaptive to device screen)
- Game loop: `Task.sleep(for: .milliseconds(300))` intervals
- Scoring: +10 per food consumed
- Collision: wall boundaries (with 4px margin) and self-collision
- Direction: prevents immediate 180-degree reversals
- Efficiency metric: `score / duration` (points per second)
- Task lifecycle: `gameLoopTask` and `timeTrackingTask` are cancelled on game over and in `deinit`

### Data Flow

1. `swiftSnakeApp` creates a `ModelContainer` with `ScoreRecord` schema
2. `WelcomeView` is the root view, displaying top scores and a play button
3. `GameView` owns a `SnakeGameModel` via `@StateObject`
4. On game over, `NameEntryView` saves a `ScoreRecord` to SwiftData via `@Environment(\.modelContext)`
5. `RankingView` queries and displays persisted scores

### Accessibility

All views include VoiceOver support following Apple HIG:
- **WelcomeView**: Header traits on titles, hidden decorative emoji, positional labels on score entries, hint on play button
- **GameView**: Combined accessibility element for game area, custom `.accessibilityAction` for all four directions (alternative to swipe gestures), `AccessibilityNotification.Announcement` for score changes and game over
- **GameHUDView**: Combined element with score and time labels
- **NameEntryView**: Header on score display, labeled text field with hint, dynamic button state (disabled when empty, contextual hint)
- **RankingView**: Header traits, combined row elements with positional labels

## Code Conventions

- **Language**: Code comments and variable names mix Spanish and English. Comments are predominantly in Spanish.
- **Naming**: Standard Swift conventions — types are `PascalCase`, properties/methods are `camelCase`
- **Concurrency**: All `ObservableObject` classes must be `@MainActor`. Use `Task` instead of `Timer` for game loops.
- **No linter or formatter configured** (no SwiftLint, no SwiftFormat)
- **No CI/CD pipeline** configured
- **No `.gitignore`** file present — be cautious about committing Xcode user data or build artifacts
- **No external dependencies** — only Apple frameworks (SwiftUI, SwiftData, Foundation)

## Common Patterns

- `@MainActor` on all `ObservableObject` classes for Swift 6 concurrency safety
- `@Published` properties for reactive UI updates
- `Task` with `Task.sleep` for game loops (not `Timer.scheduledTimer`)
- `[weak self]` in Task closures to prevent retain cycles
- `@Environment(\.modelContext)` for SwiftData access in views only (not in model classes)
- `NavigationStack` / `NavigationLink` for view navigation
- SwiftData `@Query` for fetching persisted records in views
- `.accessibilityLabel`, `.accessibilityHint`, `.accessibilityAction` for VoiceOver
- `AccessibilityNotification.Announcement` for dynamic game state changes

## Important Notes

- Screen dimensions (400x800) are hardcoded constants in `SnakeGameModel` — not adaptive to device screen size.
- The ranking button is hidden in v1 per the README roadmap.
- `HUDViewModel.swift` contains the `GHUDViewModel` class (the "G" prefix stands for "Game HUD").
- `GameData.swift` is a SwiftData model not currently registered in the `ModelContainer` — reserved for future use.
- `HashableCGPoint.swift` is an empty legacy file — `CGPoint` conforms to `Hashable` natively in iOS 18+.
