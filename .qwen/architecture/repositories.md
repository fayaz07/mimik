# Repository Documentation

This document describes all repository layers in the Mimik application.

---

## Overview

Repositories abstract persistence operations from use cases. This enables:

- Easy switching between local/remote data sources
- Testing with mock repositories
- Clean separation of concerns
- Multiple persistence strategies (CoreData, SQLite, API)

---

## Base Repository Pattern

```swift
// Local Repository
protocol WorkspaceRepository {
  func create(_ workspace: WorkspaceDTO) async throws -> WorkspaceDTO
  func update(_ workspace: WorkspaceDTO) async throws
  func delete(id: UUID) async throws
  func fetch(id: UUID) async throws -> WorkspaceDTO?
  func fetchAll() async throws -> [WorkspaceDTO]
}

// Remote Repository
protocol RemoteWorkspaceRepository {
  func fetch(id: UUID) async throws -> WorkspaceDTO?
}
```

---

## WorkspaceRepository

```swift
protocol WorkspaceRepository {
  // Create new workspace
  func create(_ workspace: WorkspaceDTO) async throws -> WorkspaceDTO

  // Update existing workspace
  func update(_ workspace: WorkspaceDTO) async throws

  // Delete workspace
  func delete(id: UUID) async throws

  // Fetch workspace by ID
  func fetch(id: UUID) async throws -> WorkspaceDTO?

  // Fetch all workspaces
  func fetchAll() async throws -> [WorkspaceDTO]

  // Delete all workspaces (for testing)
  func deleteAll() async throws

  // Clear workspace
  func clear()
}
```

---

## WSAppRepository

```swift
protocol WSAppRepository {
  // Create new app
  func create(_ app: WSAppDTO) async throws -> WSAppDTO

  // Update existing app
  func update(_ app: WSAppDTO) async throws

  // Delete app
  func delete(id: UUID) async throws

  // Fetch app by ID
  func fetch(id: UUID) async throws -> WSAppDTO?

  // Fetch all apps for a workspace
  func fetchAll(workspaceId: UUID) async throws -> [WSAppDTO]

  // Delete all apps (for testing)
  func deleteAll() async throws
}
```

---

## WSLangRepository

```swift
protocol WSLangRepository {
  // Create language
  func create(_ language: WSLangDTO) async throws -> WSLangDTO

  // Update language (name/description)
  func update(_ language: WSLangDTO) async throws

  // Toggle active status
  func toggle(id: UUID) async throws

  // Switch default language
  func switchDefault(workspaceId: UUID, lang: String) async throws

  // Delete language
  func delete(id: UUID) async throws

  // Fetch languages for workspace
  func fetch(workspaceId: UUID) async throws -> [WSLangDTO]

  // Delete all languages (for testing)
  func deleteAll(workspaceId: UUID) async throws
}
```

---

## TranslationGroupRepository

```swift
protocol TranslationGroupRepository {
  // Create group
  func create(_ group: TranslationGroupDTO) async throws -> TranslationGroupDTO

  // Update group
  func update(_ group: TranslationGroupDTO) async throws

  // Delete group
  func delete(id: UUID) async throws

  // Fetch group by ID
  func fetch(id: UUID) async throws -> TranslationGroupDTO?

  // Fetch all groups for workspace
  func fetch(workspaceId: UUID) async throws -> [TranslationGroupDTO]

  // Fetch group with children (nested)
  func fetchNested(workspaceId: UUID, parentId: UUID?) async throws -> [TranslationGroupDTO]

  // Delete all groups (for testing)
  func deleteAll(workspaceId: UUID) async throws
}
```

---

## TranslationKeyRepository

```swift
protocol TranslationKeyRepository {
  // Create key
  func create(_ key: TranslationKeyDTO) async throws -> TranslationKeyDTO

  // Update key
  func update(_ key: TranslationKeyDTO) async throws

  // Delete key
  func delete(id: UUID) async throws

  // Fetch key by ID
  func fetch(id: UUID) async throws -> TranslationKeyDTO?

  // Fetch all keys for workspace
  func fetch(workspaceId: UUID) async throws -> [TranslationKeyDTO]

  // Fetch keys for a translation group
  func fetch(workspaceId: UUID, groupId: UUID) async throws -> [TranslationKeyDTO]

  // Add excluded apps to key
  func addExcludedApp(id: UUID, appId: UUID) async throws

  // Remove excluded app from key
  func removeExcludedApp(id: UUID, appId: UUID) async throws

  // Delete all keys (for testing)
  func deleteAll(workspaceId: UUID) async throws
}
```

---

## TranslationValueRepository

```swift
protocol TranslationValueRepository {
  // Create value
  func create(_ value: TranslationValueDTO) async throws -> TranslationValueDTO

  // Update value
  func update(_ value: TranslationValueDTO) async throws

  // Delete value
  func delete(id: UUID) async throws

  // Fetch value by ID
  func fetch(id: UUID) async throws -> TranslationValueDTO?

  // Fetch all values for workspace
  func fetch(workspaceId: UUID) async throws -> [TranslationValueDTO]

  // Fetch values for a translation key
  func fetch(workspaceId: UUID, keyId: UUID) async throws -> [TranslationValueDTO]

  // Delete all values (for testing)
  func deleteAll(workspaceId: UUID) async throws
}
```

---

## Implementation

### WorkspaceEntityRepository

```swift
@MainActor
final class WorkspaceEntityRepository: WorkspaceRepository {
  private let workspaceContext: NSManagedObjectContext
  private let coreDataStore: CoreDataStore

  // Create
  func create(_ workspace: WorkspaceDTO) async throws -> WorkspaceDTO {
    return try await withCheckedThrowingContinuation { continuation in
      Task.detached {
        let entity = workspace.toEntity()
        self.workspaceContext.insert(entity)
        try? self.workspaceContext.save()
        continuation.resume(returning: entity.toDTO())
      }
    }
  }

  // Update
  func update(_ workspace: WorkspaceDTO) async throws {
    guard let entity = workspaceContext.object(with: workspace.id) else {
      throw StorageError(workspaceNotFound: workspace.id)
    }
    entity.name = workspace.name
    entity.description = workspace.desc
    entity.defLang = workspace.defLang
    entity.updatedAt = Date()
    try? workspaceContext.save()
  }

  // Fetch
  func fetch(id: UUID) async throws -> WorkspaceDTO? {
    return try await withCheckedThrowingContinuation { continuation in
      Task.detached {
        guard let entity = self.workspaceContext.object(with: id) else {
          continuation.resume(returning: nil)
          return
        }
        continuation.resume(returning: entity.toDTO())
      }
    }
  }

  // Fetch All
  func fetchAll() async throws -> [WorkspaceDTO] {
    return try await withCheckedThrowingContinuation { continuation in
      Task.detached {
        let entities = self.workspaceContext.fetch(
          WorkspaceEntity.fetchAllRequest()
        ).map { $0.toDTO() }
        continuation.resume(returning: entities)
      }
    }
  }

  // Clear
  func clear() {
    self.workspaceContext.deleteAllObjects()
    try? self.workspaceContext.save()
  }
}
```

---

## CoreDataStore

```swift
final class CoreDataStore: Sendable {
  let workspaceContext: NSManagedObjectContext

  init(modelContainer: NSPersistentContainer) {
    self.workspaceContext = modelContainer.viewContext
  }
}
```

---

## StorageError

```swift
enum StorageError: LocalizedError {
  case workspaceNotFound(id: UUID)
  case appNotFound(id: UUID)
  case languageNotFound(id: UUID)
  case translationGroupNotFound(id: UUID)
  case translationKeyNotFound(id: UUID)
  case translationValueNotFound(id: UUID)
  case persistenceFailed(String)

  var errorDescription: String? {
    switch self {
    case .workspaceNotFound(let id):
      return "Workspace with ID \(id) not found"
    case .appNotFound(let id):
      return "App with ID \(id) not found"
    case .languageNotFound(let id):
      return "Language with ID \(id) not found"
    case .translationGroupNotFound(let id):
      return "Translation group with ID \(id) not found"
    case .translationKeyNotFound(let id):
      return "Translation key with ID \(id) not found"
    case .translationValueNotFound(let id):
      return "Translation value with ID \(id) not found"
    case .persistenceFailed(let error):
      return "Persistence failed: \(error)"
    }
  }
}
```

---

## Summary

| Repository | Purpose |
|------------|----------|
| `WorkspaceRepository` | CRUD operations on workspaces |
| `WSAppRepository` | CRUD operations on apps |
| `WSLangRepository` | CRUD operations on workspace languages |
| `TranslationGroupRepository` | CRUD operations on translation groups |
| `TranslationKeyRepository` | CRUD operations on translation keys |
| `TranslationValueRepository` | CRUD operations on translation values |

All repositories:
- Follow the repository pattern
- Handle persistence at the repository layer
- Use async/await for non-blocking operations
- Throw `StorageError` for persistence failures
- Are implemented as `@MainActor` final classes