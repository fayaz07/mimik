# Mimik Project Architecture Overview

## Project Summary

Mimik is a **Translation Management iOS App** built with **Swift + SwiftUI**. It helps developers and product teams manage multi-language translation workflows, track translation progress, and organize translations by workspace.

## Core Architecture Pattern

The app follows **Clean Architecture** with the following layers:

```
┌─────────────────────────────────────────────────────┐
│                    Presentation Layer                 │
│              (View - SwiftUI) + ViewModel            │
│  - Features/ directory contains UI screens            │
│  - UI/Common/ contains reusable components           │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│                    Business Logic Layer               │
│                     Use Cases                         │
│  - Data/Usecase/ directory                            │
│  - Contains create, get, add, toggle, switch use cases│
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│                   Repository Layer                    │
│  - Data/Repository/ directory                          │
│  - Protocols + implementations                        │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│                   Data Source Layer                   │
│  - Data/Source/ directory                              │
│  - CoreData data sources                              │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│                   Persistence Layer                   │
│  - CoreData models and schemas                         │
└─────────────────────────────────────────────────────┘
```

## State Management

The app uses Swift 5.3+ `@Observable` protocol composition for reactive state.

```swift
@Observable
class WorkspaceDetailViewModel {
  @Published var viewState: ViewState<WorkspaceDTO> = ViewState.loading()
}
```

## Dependency Injection

The app uses the **Factory** library for dependency injection (not Swinject as initially thought).

Key DI container files:
- `Container.swift` - Main container configuration
- `WorkspaceDataContainerDI.swift` - Workspace-related DI
- `AppsDataContainerDI.swift` - App-related DI
- `LangContainerDI.swift` - Language-related DI
- `TranslationContainerDI.swift` - Translation-related DI

## CoreData Models

Located in `App/Data/Sources/AppModels.xcdatamodeld`:

### Entities

| Entity | Description |
|--------|-------------|
| Workspace | Top-level organization container |
| App | Apps within a workspace (iOS, Android, Web, etc.) |
| WorkspaceLang | Languages configured for a workspace |
| TranslationGroup | Hierarchical group for organizing translations |
| TranslationKey | Translation key/label |
| TranslationValue | Translation value per language |

## Key Directories

```
Mimik/
├── App/                    # App entry point, root views
│   ├── ContentView.swift   # Main app content
│   └── AppNavigationRouter.swift # Navigation stack management
│
├── Data/                   # Data layer
│   ├── Models/            # DTOs (Transfer Objects)
│   ├── Repository/        # Repository protocols + implementations
│   ├── Usecase/           # Business logic use cases
│   ├── Transformer/       # Data transformation utilities
│   └── Sources/           # CoreData data sources
│       └── AppModels.xcdatamodeld
│
├── DI/                     # Dependency injection containers
│   ├── Container.swift
│   ├── WorkspaceDataContainerDI.swift
│   ├── AppsDataContainerDI.swift
│   ├── LangContainerDI.swift
│   └── TranslationContainerDI.swift
│
├── Features/               # Feature modules (UI + ViewModels)
│   ├── Home/              # Home screen and view model
│   ├── Workspace/         # Workspace detail and related screens
│   ├── Translations/      # Translation management screens
│   ├── Settings/          # Settings screen
│   └── Router/            # Navigation routing
│
├── UI/                     # UI components
│   ├── Common/            # Reusable components
│   └── Workspace/         # Workspace-specific UI
│
└── Preview Content/        # SwiftUI previews
```

## Data Flow Pattern

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│   View  │────▶│ ViewModel│────▶│ UseCase │────▶│Repository│
└─────────┘     └─────────┘     └─────────┘     └─────────┘
                                                            │
                                                            ▼
                                                   ┌─────────────────┐
                                                   │   Data Source   │
                                                   │  (CoreData)     │
                                                   └─────────────────┘
```

## Common Patterns

### ViewState Pattern

```swift
enum ViewState<Data> {
  case loading
  case idle
  case success(Data)
  case error(Error)
  case empty
}
```

### DTO Pattern

Entities are transformed to DTOs for cross-layer communication:

```swift
struct WorkspaceDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let name: String
  let desc: String
  let defLang: String
  let createdAt: Date
  let updatedAt: Date
  let lastAccessed: Date
}
```

### Repository Protocol Pattern

```swift
protocol WorkspaceRepository {
  func getById(id: UUID) async throws -> WorkspaceEntity?
  func getAll() async throws -> [WorkspaceDTO]
  func create(name: String, description: String) async throws -> WorkspaceDTO
  func delete(id: UUID) async throws
  func findByName(name: String) async throws -> [WorkspaceEntity]
  func saveAccessTime(id: UUID) async throws
  func switchDefaultLang(id: UUID, lang: String) async throws -> WorkspaceDTO?
}
```

## Async/Await Pattern

All data operations use `async/await` for non-blocking I/O:

```swift
func getAll() async throws -> [WorkspaceDTO]
func create(name: String, description: String) async throws -> WorkspaceDTO
func delete(id: UUID) async throws
```

## Date Management

- `createdAt`: When record was created
- `updatedAt`: Last modification timestamp
- `lastAccessed`: When workspace was last accessed
- `Date()`: Current date for timestamps

## Error Handling

Use Cases validate input and return errors:

```swift
func validate(name: String, desc: String) -> (Bool, String?, String?)
// Returns: (isValid, nameError?, descError?)
```

## Security Considerations

- Input validation in use cases
- Language code validation
- Access time tracking for analytics

## Next Steps

This overview documents the architectural patterns. For detailed documentation:
- See [screens/README.md](../screens/README.md) for screen details
- See [components/README.md](../components/README.md) for component details
- See [models/README.md](../models/README.md) for data models
