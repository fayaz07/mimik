# Complete Architecture Summary

This document provides a complete overview of the Mimik application architecture.

---

## Application Structure

```
Mimik/
├── Sources/
│   └── Mimik/
│       ├── App/
│       │   ├── Workspace/        # Workspace management
│       │   ├── App/              # Application management
│       │   ├── Language/         # Language management
│       │   ├── Translation/      # Translation management
│       │   └── UseCase/          # Business logic orchestration
│       ├── Utils/
│       │   ├── DI Container      # Dependency injection
│       │   └── Validation        # Validation rules
│       └── Persistence/
│           ├── Repository        # Persistence layer
│           └── CoreDataStore     # CoreData implementation
├── .qwen/
│   └── architecture/             # Documentation
│       ├── overview.md
│       ├── di-containers.md
│       ├── repositories.md
│       ├── viewmodels.md
│       ├── validation.md
│       ├── models.md
│       ├── README.md
│       └── summary.md
```

---

## Core Architecture Principles

### 1. Clean Architecture

- **Use Cases** orchestrate business logic
- **Repositories** handle persistence
- **View Models** manage UI state
- **UI** presents data to users

### 2. MVVM Pattern

- **Model**: DTOs, Entities
- **ViewModel**: `@Observable` state management
- **View**: SwiftUI views

### 3. Repository Pattern

- Abstraction from persistence
- Easy to swap implementations
- Testable with mocks

### 4. Dependency Injection

- DI containers manage dependencies
- Protocol-based abstractions
- Testable and maintainable

### 5. ViewState Pattern

- Consistent UI state management
- Handles loading, success, error states
- Automatic UI updates via `@Observable`

---

## Layer Responsibilities

### UI Layer (ViewModels)

| Responsibility | Example |
|---------|----------|
| Manage UI state | `@Published var viewState: ViewState<T>` |
| Handle user actions | `func execute() async` |
| Display data | Bind to SwiftUI views |
| Handle navigation | Push/present other views |

### Use Case Layer

| Responsibility | Example |
|---------|----------|
| Orchestrate business logic | `func execute() async throws` |
| Call repositories | `let result = try await repo.fetch()` |
| Validate input | `let validation = Validate(...)` |
| Return DTOs | `return WorkspaceDTO(...)` |

### Repository Layer

| Responsibility | Example |
|---------|----------|
| Data persistence | `func fetch(id: UUID) async throws` |
| CRUD operations | Create, read, update, delete |
| Data transformation | Entity <-> DTO conversion |
| Error handling | Throw `StorageError` |

### DI Container Layer

| Responsibility | Example |
|---------|----------|
| Wire dependencies | `WorkspaceRepository in Container.shared` |
| Manage lifecycle | Singleton vs per-instance |
| Configure storage | CoreDataStore initialization |

### Validation Layer

| Responsibility | Example |
|---------|----------|
| Validate input | `ValidateWorkspaceName` |
| Format data | Language code validation |
| Return errors | `workspaceNameError: String?` |

---

## Component Overview

### Workspace Component

| Component | Purpose |
|---------|----------|
| `WorkspaceDTO` | Data transfer object |
| `WorkspaceEntity` | Core data entity |
| `WorkspaceRepository` | Persistence abstraction |
| `CreateWorkspaceUsecase` | Create workspace |
| `GetWorkspaceUsecase` | Fetch workspace |
| `DeleteWorkspaceUsecase` | Delete workspace |
| `ListWorkspacesUsecase` | List all workspaces |
| `WorkspaceViewModel` | Workspace list view |
| `WorkspaceDetailViewModel` | Workspace detail view |

### App Component

| Component | Purpose |
|---------|----------|
| `WSAppDTO` | Data transfer object |
| `WSAppEntity` | Core data entity |
| `WSAppRepository` | Persistence abstraction |
| `AddAppUseCase` | Create app |
| `UpdateAppUseCase` | Update app |
| `DeleteAppUseCase` | Delete app |
| `ListAppsUseCase` | List apps for workspace |
| `ListAppsViewModel` | App list view |
| `AddAppViewModel` | Add app form |

### Language Component

| Component | Purpose |
|---------|----------|
| `WSLangDTO` | Data transfer object |
| `WSLangEntity` | Core data entity |
| `WSLangRepository` | Persistence abstraction |
| `AddLanguageUsecase` | Add language |
| `SwitchDefaultLanguageUsecase` | Set default language |
| `ListWorkspaceLanguagesUseCase` | List languages |
| `AddLanguageViewModel` | Add language form |
| `WSLanguagesViewModel` | Languages list view |

### Translation Component

| Component | Purpose |
|---------|----------|
| `TranslationGroupDTO` | Data transfer object |
| `TranslationKeyDTO` | Data transfer object |
| `TranslationValueDTO` | Data transfer object |
| `TranslationGroupRepository` | Group persistence |
| `TranslationKeyRepository` | Key persistence |
| `TranslationValueRepository` | Value persistence |
| `ListTranslationsUsecase` | List translation groups |
| `AddTranslationUsecase` | Create group |
| `AddTranslationKeyUsecase` | Add key |
| `AddTranslationValueUsecase` | Add value |
| `WSTranslationsViewModel` | Translation list view |
| `AddTranslationGroupViewModel` | Add group form |

---

## Data Models

### Workspace

```swift
struct WorkspaceDTO {
  let id: UUID
  let name: String
  let desc: String
  let createdAt: Date
  let updatedAt: Date
  let defLang: String?
}
```

### App

```swift
struct WSAppDTO {
  let id: UUID
  let name: String
  let description: String
  let workspaceId: UUID
  let platform: String
  let updatedAt: Date
}
```

### Language

```swift
struct WSLangDTO {
  let id: UUID
  let code: String
  let name: String
  let workspaceId: UUID
  let isDefault: Bool
  let isActive: Bool
  let createdAt: Date
  let updatedAt: Date
}
```

### Translation Group

```swift
struct TranslationGroupDTO {
  let id: UUID
  let name: String
  let workspaceId: UUID
  let parentGroup: String?
  let languageCodes: [String]
  let keys: [TranslationKeyDTO]
}
```

### Translation Key

```swift
struct TranslationKeyDTO {
  let id: UUID
  let key: String
  let workspaceId: UUID
  let group: String
  let values: [TranslationValueDTO]
  let excludedApps: [UUID]
}
```

### Translation Value

```swift
struct TranslationValueDTO {
  let id: UUID
  let keyId: UUID
  let workspaceId: UUID
  let languageCode: String
  let value: String
}
```

---

## Validation Rules

| Entity | Field | Min | Max | Rules |
|--------|-------|-----|-----|-------|
| Workspace | name | 1 | 100 | No special chars |
| Workspace | desc | 0 | 500 | Any chars |
| App | name | 1 | 100 | No special chars |
| App | description | 0 | 500 | Any chars |
| Language | code | 2 | 3 | ISO 639-1/639-2 |
| Language | name | 1 | 100 | No special chars |
| Translation Group | name | 1 | 100 | Any chars |
| Translation Key | key | 1 | 200 | Letters, numbers, `_` `-` `.` |
| Translation Value | value | 0 | 2000 | Any chars |

---

## Error Types

### Use Case Errors

```swift
enum CreateWorkspaceUsecaseError: LocalizedError {
  case nameError(String)
  case descriptionError(String)
  case languageError(String)
}
```

### Repository Errors

```swift
enum StorageError: LocalizedError {
  case workspaceNotFound(id: UUID)
  case appNotFound(id: UUID)
  case languageNotFound(id: UUID)
  case persistenceFailed(String)
}
```

---

## Testing Strategy

### Unit Tests

| Layer | Mock | Test Cases |
|-------|-------|-------------|
| ViewModels | Use Cases | State changes, error handling |
| Use Cases | Repositories | Business logic, validation |
| Repositories | CoreDataStore | Persistence operations |

### Example Test

```swift
final class CreateWorkspaceUsecaseTests: XCTestCase {
  let mockRepo = MockWorkspaceRepository()

  func testCreateWorkspace() async throws {
    let useCase = CreateWorkspaceUsecase(workspaceRepository: mockRepo)
    let dto = WorkspaceDTO(...)

    let result = try await useCase.execute(
      name: "Test",
      description: "Test desc",
      defLang: "en"
    )

    XCTAssertEqual(result.id, dto.id)
  }
}
```

---

## Performance Considerations

### CoreData Optimization

- Use batch inserts for multiple entities
- Configure `NSPersistentContainer` with background context
- Implement change notifications for live updates
- Use `NSFetchedResultsController` for lists

### Async/Await

- All async operations are properly awaited
- No blocking main thread operations
- Task cancellation supported

### Memory Management

- Core Data manages object lifecycle
- Automatic deallocation of fetched objects
- No circular references

---

## Security Considerations

### Data Privacy

- Encrypt sensitive data (if applicable)
- Follow platform security guidelines
- No hardcoded secrets

### Input Validation

- Validate all user inputs
- Sanitize translation keys
- Check length limits

---

## Migration Notes

### From CoreData 1.x to 2.x

- Use `NSPersistentContainer`
- Configure custom contexts
- Migrate to async operations

### Breaking Changes

- Repository protocol changes
- Use case error types
- DTO structure changes

---

## References

- Swift Concurrency: https://developer.apple.com/videos/play/wwdc2021/10033/
- Clean Architecture: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- MVVM Pattern: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel

---

## See Also

- Architecture documentation in `.qwen/architecture/`
- Code comments in `Sources/Mimik/`
- Swift Evolution Proposals
- Apple Developer Documentation
