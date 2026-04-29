# Data Flow Documentation

This document describes how data flows through the Mimik application.

## Overview

The app follows the **Clean Architecture** data flow pattern:

```
User Interaction → View → ViewModel → UseCase → Repository → DataSource → Persistence
```

## Core Data Entity Flow

### Workspace Flow

```
User Action: Tap "Create New Workspace"
    ↓
CreateWorkspaceScreen (UI)
    ↓
CreateWorkspaceVM (@Observable state)
    ↓
CreateWorkspaceUsecase
    ↓
WorkspaceRepository
    ↓
WorkspaceLocalDataSource (CoreData)
    ↓
WorkspaceEntity created
    ↓
Transform to WorkspaceDTO
    ↓
Update ViewModel state
    ↓
UI updates automatically (@Published)
```

### App CRUD Flow

```
User Action: Tap "Add App"
    ↓
AddAppScreen (UI)
    ↓
AddAppVM (@Observable state)
    ↓
AddAppUsecase
    ↓
WSAppsRepository + WorkspaceRepository
    ↓
WSAppsLocalDataSource (CoreData)
    ↓
AppEntity created
    ↓
Transform to WSAppDTO
    ↓
Update ViewModel state
    ↓
UI updates automatically
```

### Language CRUD Flow

```
User Action: Tap "Add Language"
    ↓
WorkspaceLanguagesScreen (UI)
    ↓
WSLanguagesViewModel (@Observable state)
    ↓
AddLanguageUsecase (and/or ToggleLangStatusUsecase)
    ↓
WSLanguagesRepository + LangRepository
    ↓
WSLanguagesLocalDataSource (CoreData)
    ↓
WorkspaceLangEntity created/updated
    ↓
Transform to WSLangDTO
    ↓
Update ViewModel state
    ↓
UI updates automatically
```

### Translation Group CRUD Flow

```
User Action: Tap "Add Translation Group"
    ↓
AddTranslationGroupScreen (UI)
    ↓
AddTranslationGroupViewModel (@Observable state)
    ↓
CreateTranslationUsecase (and/or ListTranslationsUsecase)
    ↓
WSTranslationRepository
    ↓
TranslationGroupLocalDataSource (CoreData)
    ↓
TranslationGroupEntity created/updated
    ↓
Transform to TranslationGroupDTO
    ↓
Update ViewModel state
    ↓
UI updates automatically
```

### Translation Key CRUD Flow

```
User Action: Add translation key
    ↓
WSTranslationsScreen (UI)
    ↓
WSTranslationsViewModel (@Observable state)
    ↓
CreateTranslationUsecase (and/or ListTranslationsUsecase)
    ↓
WSTranslationRepository
    ↓
[WSTranslationKeyLocalDataSource + WSTranslationGroupLocalDataSource + WSTranslationValueLocalDataSource]
    ↓
[TranslationKeyEntity + TranslationGroupEntity + TranslationValueEntity]
    ↓
Transform to TranslationKeyDTO + TranslationValueDTO
    ↓
Update ViewModel state
    ↓
UI updates automatically
```

---

## Data Transformation Pattern

### Entity → DTO

```swift
// Workspace
extension WorkspaceEntity {
  func toDTO() -> WorkspaceDTO {
    return WorkspaceDTO(
      id: self.id,
      name: self.name,
      desc: self.description,
      defLang: self.defLang,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt,
      lastAccessed: self.lastAccessed
    )
  }
}

// App
extension AppEntity {
  func toDTO() -> WSAppDTO {
    return WSAppDTO(
      id: self.id,
      name: self.name,
      description: self.description,
      workspaceId: self.workspaceId,
      appPlatformId: self.appPlatformId,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt,
      lastAccessed: self.lastAccessed
    )
  }
}

// Workspace Language
extension WorkspaceLangEntity {
  func toDTO() -> WSLangDTO {
    return WSLangDTO(
      id: self.id,
      code: self.langCode,
      name: self.name,
      workspaceId: self.workspaceId,
      defaultLang: self.isDefault,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}

// Translation Group
extension TranslationGroupEntity {
  func toDTO() -> TranslationGroupDTO {
    return TranslationGroupDTO(
      id: self.id,
      name: self.name,
      workspaceId: self.workspaceId,
      parentId: self.parentId,
      level: self.level,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}

// Translation Key
extension TranslationKeyEntity {
  func toDTO() -> TranslationKeyDTO {
    return TranslationKeyDTO(
      id: self.id,
      key: self.key,
      workspaceId: self.workspaceId,
      groupId: self.groupId,
      excludedApps: self.excludedApps,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}

// Translation Value
extension TranslationValueEntity {
  func toDTO() -> TranslationValueDTO {
    return TranslationValueDTO(
      id: self.id,
      keyId: self.keyId,
      workspaceId: self.workspaceId,
      groupId: self.groupId,
      langCode: self.langCode,
      value: self.value,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}
```

### DTO → Entity

```swift
// Workspace
struct WorkspaceDTO {
  let id: UUID
  let name: String
  let desc: String
  let defLang: String
  let createdAt: Date
  let updatedAt: Date
  let lastAccessed: Date
}

extension WorkspaceDTO {
  func toEntity() -> WorkspaceEntity {
    return WorkspaceEntity(
      id: self.id,
      name: self.name,
      description: self.desc,
      defLang: self.defLang,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt,
      lastAccessed: self.lastAccessed
    )
  }
}

// App
struct WSAppDTO {
  let id: UUID
  let name: String
  let description: String
  let workspaceId: UUID
  let appPlatformId: String
  let createdAt: Date
  let updatedAt: Date
  let lastAccessed: Date
}

extension WSAppDTO {
  func toEntity() -> AppEntity {
    return AppEntity(
      id: self.id,
      name: self.name,
      description: self.description,
      workspaceId: self.workspaceId,
      appPlatformId: self.appPlatformId,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt,
      lastAccessed: self.lastAccessed
    )
  }
}

// Workspace Language
struct WSLangDTO {
  let id: UUID
  let code: String
  let name: String
  let workspaceId: UUID
  let defaultLang: Bool
  let createdAt: Date
  let updatedAt: Date
}

extension WSLangDTO {
  func toEntity() -> WorkspaceLangEntity {
    return WorkspaceLangEntity(
      id: self.id,
      langCode: self.code,
      name: self.name,
      workspaceId: self.workspaceId,
      isDefault: self.defaultLang,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}

// Translation Group
struct TranslationGroupDTO {
  let id: UUID
  let name: String
  let workspaceId: UUID
  let parentId: UUID?
  let level: Int
  let createdAt: Date
  let updatedAt: Date
}

extension TranslationGroupDTO {
  func toEntity() -> TranslationGroupEntity {
    return TranslationGroupEntity(
      id: self.id,
      name: self.name,
      workspaceId: self.workspaceId,
      parentId: self.parentId,
      level: self.level,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}

// Translation Key
struct TranslationKeyDTO {
  let id: UUID
  let key: String
  let workspaceId: UUID
  let groupId: UUID
  let excludedApps: [UUID]
  let createdAt: Date
  let updatedAt: Date
}

extension TranslationKeyDTO {
  func toEntity() -> TranslationKeyEntity {
    return TranslationKeyEntity(
      id: self.id,
      key: self.key,
      workspaceId: self.workspaceId,
      groupId: self.groupId,
      excludedApps: self.excludedApps,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}

// Translation Value
struct TranslationValueDTO {
  let id: UUID
  let keyId: UUID
  let workspaceId: UUID
  let groupId: UUID
  let langCode: String
  let value: String
  let createdAt: Date
  let updatedAt: Date
}

extension TranslationValueDTO {
  func toEntity() -> TranslationValueEntity {
    return TranslationValueEntity(
      id: self.id,
      keyId: self.keyId,
      workspaceId: self.workspaceId,
      groupId: self.groupId,
      langCode: self.langCode,
      value: self.value,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}
```

---

## View Model State Management

### ViewState Pattern

```swift
enum ViewState<Data> {
  case loading
  case idle
  case success(Data)
  case error(Error)
  case empty
}

// Example: WorkspaceViewModel
@Observable
class WorkspaceDetailViewModel {
  @Published var viewState: ViewState<WorkspaceDTO> = ViewState.loading()

  func fetch(id: UUID) async {
    self.viewState = .loading
    do {
      let workspace = try await getUsecase.execute(id: id)
      self.viewState = .success(workspace)
    } catch {
      self.viewState = .error(error)
    }
  }
}
```

### Nested ViewModels

```swift
// CreateWorkspaceViewModel
@Observable
class CreateWorkspaceVM {
  @Published var viewState: ViewState<WorkspaceDTO> = ViewState.loading()
  @Published var viewModelError: String?

  private let usecase: CreateWorkspaceUsecase

  func execute() async {
    self.viewState = .loading
    do {
      let workspace = try await usecase.execute(
        name: self.name,
        description: self.description
      )
      self.viewState = .success(workspace)
      self.viewModelError = nil
    } catch let error as CreateWorkspaceUsecaseError {
      self.viewModelError = error.localizedDescription
      self.viewState = .error(error)
    } catch {
      self.viewState = .error(error)
    }
  }
}
```

---

## Repository Pattern

### Repository Responsibilities

1. Abstract data access from UI layer
2. Provide consistent interface for data operations
3. Handle data transformation (Entity ↔ DTO)

### Example: Workspace Repository

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

---

## Use Case Responsibilities

Use Cases orchestrate multiple repository operations and handle business logic.

### Example: CreateWorkspaceUsecase

```swift
final class CreateWorkspaceUsecase {
  private let repo: WorkspaceRepository

  func execute(name: String, description: String) async throws -> WorkspaceDTO {
    // Validation
    let isValid = ValidateWorkspaceName.validate(name: name, desc: description)
    if !isValid.isValid {
      if let nameError = isValid.nameError {
        throw CreateWorkspaceUsecaseError(nameError)
      }
    }

    // Delegation
    return try await repo.create(name: name, description: description)
  }
}
```

---

## Error Handling

### Use Case Errors

```swift
enum CreateWorkspaceUsecaseError: LocalizedError {
  case nameError(String)
  case descriptionError(String)

  var errorDescription: String? {
    switch self {
    case .nameError(let error):
      return error
    case .descriptionError(let error):
      return error
    }
  }
}
```

---

## Summary

Data flows through the application as follows:

1. **User interacts** with UI components
2. **ViewModel** captures state changes
3. **UseCase** orchestrates business logic
4. **Repository** abstracts data access
5. **DataSource** handles CoreData operations
6. **Entity** is created/fetched
7. **DTO** is transformed for UI consumption
8. **ViewModel state** is updated
9. **UI** updates automatically via `@Published`

This layered approach ensures:
- Separation of concerns
- Testability
- Maintainability
- Scalability
