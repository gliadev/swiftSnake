# CLAUDE.md - SwiftSnake Project Guide

## Project Overview

SwiftSnake is a modern iOS Snake game built with SwiftUI and SwiftData. It implements the classic Nokia Snake gameplay with touch controls, score tracking, and a persistent ranking system. The project uses MVVM architecture with no external dependencies.

## Tech Stack

- **Language**: Swift 6 (Swift 5.0 compatibility mode)
- **UI**: SwiftUI
- **Persistence**: SwiftData
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
│   │   ├── SnakeGameModel.swift   # Core game logic (movement, collisions, scoring)
│   │   ├── ScoreRecord.swift      # SwiftData @Model for persistent scores
│   │   ├── GameData.swift         # Game state data model
│   │   ├── HUDViewModel.swift     # HUD formatting logic
│   │   ├── RankingViewModel.swift # Ranking display formatting
│   │   └── HashableCGPoint.swift  # CGPoint hashing utility
│   ├── Views/
│   │   ├── WelcomeView.swift      # Main menu with top 5 scores
│   │   ├── GameView.swift         # Gameplay screen with touch gestures
│   │   ├── GameHUDView.swift      # Score/time HUD overlay
│   │   ├── NameEntryView.swift    # Post-game name input + save
│   │   └── RankingView.swift      # Top 10 ranking display
│   ├── Assets.xcassets/           # App icons, colors
│   └── Preview Content/           # SwiftUI preview assets
├── swiftSnakeTests/               # Unit tests (Swift Testing)
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

Located in `swiftSnakeTests/swiftSnakeTests.swift`. Uses the Swift Testing framework (`import Testing`):
- `scoreRecordEfficiencyShouldBeCorrect()` — verifies efficiency = score / duration
- `formatDateShouldReturnString()` — verifies date formatting produces non-empty output

Tests use `@testable import swiftSnake` and the `#expect(...)` assertion macro.

### UI Tests

Located in `swiftSnakeUITests/`. Uses XCTest. Currently contains template scaffolding.

## Architecture

**MVVM pattern** with clear separation:

- **Models**: `SnakeGameModel` (game logic as `ObservableObject`), `ScoreRecord` (SwiftData `@Model`), `GameRecord` (codable struct), `GameData`
- **ViewModels**: `HUDViewModel`, `RankingViewModel` — formatting/presentation logic
- **Views**: SwiftUI views using `@StateObject`, `@Environment(\.modelContext)` for dependency injection

### Key Game Mechanics (SnakeGameModel)

- Grid-based movement on a 20px grid
- Game area: 400x800 points
- Game loop: 0.3s timer intervals
- Scoring: +10 per food consumed
- Collision: wall boundaries (with 4px margin) and self-collision
- Direction: prevents immediate 180-degree reversals
- Efficiency metric: `score / duration` (points per second)

### Data Flow

1. `swiftSnakeApp` creates a `ModelContainer` with `ScoreRecord` schema
2. `WelcomeView` is the root view, displaying top scores and a play button
3. `GameView` owns a `SnakeGameModel` via `@StateObject`
4. On game over, `NameEntryView` saves a `ScoreRecord` to SwiftData
5. `RankingView` queries and displays persisted scores

## Code Conventions

- **Language**: Code comments and variable names mix Spanish and English. Comments are predominantly in Spanish.
- **Naming**: Standard Swift conventions — types are `PascalCase`, properties/methods are `camelCase`
- **No linter or formatter configured** (no SwiftLint, no SwiftFormat)
- **No CI/CD pipeline** configured
- **No `.gitignore`** file present — be cautious about committing Xcode user data or build artifacts
- **No external dependencies** — only Apple frameworks (SwiftUI, SwiftData, Foundation, Combine)

## Common Patterns

- `@Published` properties on `ObservableObject` classes for reactive UI updates
- `@Environment(\.modelContext)` for SwiftData access in views
- `Timer.scheduledTimer` for the game loop and elapsed time tracking
- `NavigationStack` / `NavigationLink` for view navigation
- SwiftData `@Query` for fetching persisted records in views

## Important Notes

- The `SnakeGameModel` uses `@Environment(\.modelContext)` at the class level, but this only works in SwiftUI views. The actual `modelContext` is passed explicitly to `saveToRanking(name:modelContext:)`.
- Screen dimensions (400x800) are hardcoded constants in `SnakeGameModel` — not adaptive to device screen size.
- The ranking button is noted as hidden in v1 per the README roadmap.
