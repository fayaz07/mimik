# Dependency Injection Containers Documentation

This document explains the Factory-based DI containers used in the Mimik project.

## DI Container Structure

The DI containers are defined in `DI/` directory and wire up ViewModels with their dependencies.

## Main Container File

### Container.swift

Located at `Mimik/DI/Container.swift`, this file configures the main DI container for:

1. **Workspace operations**
2. **App operations**
3. **Language operations**
4. **Translation operations**

## DI Containers by Domain

### 1. Workspace Container (`WorkspaceDataContainerDI.swift`)

```swift
extension Container {
  // Workspace Repository
  var workspaceLocalSource: Factory<WorkspaceLocalDataSource> {
    self { WorkspaceLocalDataSource(context: self.managedObjectContext()) }
      .scope(.singleton)
  }

  var workspaceRepository: Factory<WorkspaceRepository> {
    self { WorkspaceRepositoryImpl(
      localSource: self.workspaceLocalSource(),
      langRepo: self.langRepo(),
    ) }
    .scope(.shared)
  }

  // Create Workspace UseCase
  var createUsecase: Factory<CreateWorkspaceUsecase> {
    self { CreateWorkspaceUsecase(repo: self.workspaceRepository()) }
    .scope(.shared)
  }

  // Get Workspace UseCase
  var getUsecase: Factory<GetWorkspaceUsecase> {
    self { GetWorkspaceUsecase(repo: self.workspaceRepository()) }
    .scope(.shared)
  }

  // Language switching
  var switchDefaultLangUsecase: Factory<SwitchDefaultLanguageUsecase> {
    self { SwitchDefaultLanguageUsecase(repo: self.workspaceRepository()) }
      .scope(.shared)
  }

  // Create Workspace ViewModel
  var createWorkspaceViewModel: Factory<CreateWorkspaceVM> {
    self { CreateWorkspaceVM(usecase: self.createUsecase()) }
      .scope(.shared)
  }
}
```

**Scoped Services:**
- `.singleton` - Single instance, shared across the app
- `.shared` - Shared instance within workspace

---

### 2. Apps Container (`AppsDataContainerDI.swift`)

```swift
extension Container {
  // Apps Repository
  var appsLocalSource: Factory<WSAppsLocalDataSource> {
    self { WSAppsLocalDataSource(context: self.managedObjectContext()) }
      .scope(.singleton)
  }

  var appsRepository: Factory<WSAppsRepo> {
    self { WSAppsRepoImpl(localSource: self.appsLocalSource()) }
    .scope(.shared)
  }

  // Add App UseCase
  var addAppUsecase: Factory<AddAppUseCase> {
    self { AddAppUseCase(
      repo: self.workspaceRepository(),
      appsRepo: self.appsRepository()
    ) }
    .scope(.shared)
  }

  // Add App ViewModel
  var addAppViewModel: Factory<AddAppVM> {
    self { AddAppVM(usecase: self.addAppUsecase()) }
    .scope(.shared)
  }
}
```

---

### 3. Language Container (`LangContainerDI.swift`)

```swift
extension Container {
  // Language Data Source
  var langDataSource: Factory<LangDataSource> {
    self { LangDataSource() }
      .scope(.singleton)
  }

  // Language Repository
  var langRepo: Factory<LangRepository> {
    self { LangRepository(dataSource: self.langDataSource()) }
      .scope(.shared)
  }

  // Workspace Languages
  var workspaceLanguagesLocalDataSource: Factory<WSLanguagesLocalDataSource> {
    self { WSLanguagesLocalDataSource(context: self.managedObjectContext()) }
      .scope(.singleton)
  }

  var workspaceLangRepo: Factory<WSLanguagesRepo> {
    self { WSLanguagesRepoImpl(localSource: self.workspaceLanguagesLocalDataSource()) }
      .scope(.shared)
  }

  // Add Language UseCase
  var addLangUsecase: Factory<AddLanguageUsecase> {
    self { AddLanguageUsecase(
      repo: self.workspaceLangRepo(),
      langRepo: self.langRepo()
    ) }
    .scope(.shared)
  }

  // Toggle Language Status UseCase
  var toggleLangStatusUsecase: Factory<ToggleLangStatusUsecase> {
    self { ToggleLangStatusUsecase(repo: self.workspaceLangRepo()) }
      .scope(.shared)
  }

  // Language ViewModels
  var workspaceLanguagesViewModel: Factory<WSLanguagesViewModel> {
    self { WSLanguagesViewModel(
      usecase: self.addLangUsecase(),
      getWorkspaceUsecase: self.getUsecase(),
      switchLanguageUsecase: self.switchDefaultLangUsecase(),
      toggleLangStatusUsecase: self.toggleLangStatusUsecase(),
    ) }
    .scope(.shared)
  }
}
```

---

### 4. Translation Container (`TranslationContainerDI.swift`)

```swift
extension Container {
  // Translation Key
  var trslnKeyLocalSource: Factory<WSTranslationKeyLocalDataSource> {
    self { WSTranslationKeyLocalDataSource(context: self.managedObjectContext()) }
      .scope(.singleton)
  }

  // Translation Group
  var trslnGroupLocalSource: Factory<WSTranslationGroupLocalDataSource> {
    self { WSTranslationGroupLocalDataSource(context: self.managedObjectContext()) }
      .scope(.singleton)
  }

  // Translation Value
  var trslnValueLocalSource: Factory<WSTranslationValueLocalDataSource> {
    self { WSTranslationValueLocalDataSource(context: self.managedObjectContext()) }
      .scope(.singleton)
  }

  // Translation Repository
  var trslnRepo: Factory<WSTranslationRepo> {
    self { WSTranslationRepoImpl(
      localKeySource: self.trslnKeyLocalSource(),
      localGroupSource: self.trslnGroupLocalSource(),
      localValueSource: self.trslnValueLocalSource()
    ) }
    .scope(.shared)
  }

  // List Translations UseCase
  var listTrslnUsecase: Factory<ListTranslationsUsecase> {
    self { ListTranslationsUsecase(repo: self.trslnRepo()) }
      .scope(.shared)
  }

  // Create Translation UseCase
  var createTrslnUsecase: Factory<CreateTranslationUsecase> {
    self { CreateTranslationUsecase(repo: self.trslnRepo()) }
      .scope(.shared)
  }

  // Translation ViewModels
  var trlsnScreenViewModel: Factory<WSTranslationsViewModel> {
    self { WSTranslationsViewModel(listUseCase: self.listTrslnUsecase()) }
    .scope(.shared)
  }

  var addTrslnGroupViewModel: Factory<AddTranslationGroupViewModel> {
    self { AddTranslationGroupViewModel(createUseCase: self.createTrslnUsecase()) }
    .scope(.shared)
  }
}
```

---

## Repository Layer

### Workspace Repository (`WorkspaceRepository.swift`)

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

final class WorkspaceRepositoryImpl: WorkspaceRepository {
  private let localSource: WorkspaceLocalDataSource
  private let langRepo: LangRepository

  func getById(id: UUID) async throws -> WorkspaceEntity? {
    return try await localSource.getById(id)
  }

  func getAll() async throws -> [WorkspaceDTO] {
    let entities = try await localSource.getAll()
    return entities.map { $0.toDTO() }
  }

  func create(name: String, description: String) async throws -> WorkspaceDTO {
    let entity = try await localSource.create(
      name: name,
      description: description
    )
    return entity.toDTO()
  }

  func delete(id: UUID) async throws {
    try await localSource.delete(id)
  }

  func findByName(name: String) async throws -> [WorkspaceEntity] {
    return try await localSource.findByName(name)
  }

  func saveAccessTime(id: UUID) async throws {
    try await localSource.saveAccessTime(id)
  }

  func switchDefaultLang(id: UUID, lang: String) async throws -> WorkspaceDTO? {
    let updated = try await localSource.switchDefaultLang(id, lang)
    return updated?.toDTO()
  }
}
```

### WSApps Repository (`WSAppsRepo.swift`)

```swift
protocol WSAppsRepo {
  func getById(id: UUID) async throws -> AppEntity?
  func getByWorkspaceId(workspaceId: UUID) async throws -> [WSAppDTO]
  func create(name: String, description: String, workspaceId: UUID, appPlatformId: String) async throws -> WSAppDTO
  func delete(id: UUID) async throws
  func findByName(name: String, workspaceId: UUID, appPlatformId: String) async throws -> [AppEntity]
  func saveAccessTime(id: UUID) async throws
}

final class WSAppsRepoImpl: WSAppsRepo {
  private let localSource: WSAppsLocalDataSource

  func getById(id: UUID) async throws -> AppEntity? {
    return try await localSource.getById(id)
  }

  func getByWorkspaceId(workspaceId: UUID) async throws -> [WSAppDTO] {
    let entities = try await localSource.getByWorkspaceId(workspaceId)
    return entities.map { $0.toDTO() }
  }

  func create(name: String, description: String, workspaceId: UUID, appPlatformId: String) async throws -> WSAppDTO {
    let entity = try await localSource.create(
      name: name,
      description: description,
      workspaceId: workspaceId,
      appPlatformId: appPlatformId
    )
    return entity.toDTO()
  }

  func delete(id: UUID) async throws {
    try await localSource.delete(id)
  }

  func findByName(name: String, workspaceId: UUID, appPlatformId: String) async throws -> [AppEntity] {
    return try await localSource.findByName(name, workspaceId: workspaceId, appPlatformId: appPlatformId)
  }

  func saveAccessTime(id: UUID) async throws {
    try await localSource.saveAccessTime(id)
  }
}
```

### WSLanguages Repository (`WSLanguagesRepo.swift`)

```swift
protocol WSLanguagesRepo {
  func getByWorkspaceId(workspaceId: UUID) async throws -> [WorkspaceLangEntity]
  func add(workspaceId: UUID, lang: String) async throws -> WorkspaceLangEntity
  func toggleActiveStatus(id: UUID) async throws -> WorkspaceLangEntity?
}

final class WSLanguagesRepoImpl: WSLanguagesRepo {
  private let localSource: WSLanguagesLocalDataSource

  func getByWorkspaceId(workspaceId: UUID) async throws -> [WorkspaceLangEntity] {
    return try await localSource.getByWorkspaceId(workspaceId)
  }

  func add(workspaceId: UUID, lang: String) async throws -> WorkspaceLangEntity {
    return try await localSource.add(workspaceId: workspaceId, lang: lang)
  }

  func toggleActiveStatus(id: UUID) async throws -> WorkspaceLangEntity? {
    return try await localSource.toggleActiveStatus(id)
  }
}
```

### WSTranslation Repository (`WSTranslationRepo.swift`)

```swift
protocol WSTranslationRepo {
  func addTranslation(key: String, workspaceId: UUID, excludedApps: [UUID]) async throws -> TranslationKeyDTO
  func addDefGroup(workspaceId: UUID) async throws -> TranslationGroupDTO
  func addGroup(workspaceId: UUID, name: String, parentId: UUID?) async throws -> TranslationGroupDTO
  func fetchAllGroups(workspaceId: UUID) async throws -> [TranslationGroupDTO]
}

final class WSTranslationRepoImpl: WSTranslationRepo {
  private let localGroupSource: WSTranslationGroupLocalDataSource
  private let localKeySource: WSTranslationKeyLocalDataSource
  private let localValueSource: WSTranslationValueLocalDataSource

  func addTranslation(key: String, workspaceId: UUID, excludedApps: [UUID]) async throws -> TranslationKeyDTO {
    let key = try await localKeySource.add(key: key, workspaceId: workspaceId, excludedApps: excludedApps)
    return key.toDTO()
  }

  func addDefGroup(workspaceId: UUID) async throws -> TranslationGroupDTO {
    let group = try await localGroupSource.addDefGroup(workspaceId: workspaceId)
    return group.toDTO()
  }

  func addGroup(workspaceId: UUID, name: String, parentId: UUID?) async throws -> TranslationGroupDTO {
    let group = try await localGroupSource.add(workspaceId: workspaceId, name: name, parentId: parentId)
    return group.toDTO()
  }

  func fetchAllGroups(workspaceId: UUID) async throws -> [TranslationGroupDTO] {
    let groups = try await localGroupSource.fetchAllGroups(workspaceId)
    return groups.map { $0.toDTO() }
  }
}
```

---

## Use Case Layer

Use Cases are pure business logic without side effects. They orchestrate multiple repository operations.

### CreateWorkspaceUsecase

```swift
final class CreateWorkspaceUsecase {
  private let repo: WorkspaceRepository

  init(repo: WorkspaceRepository) {
    self.repo = repo
  }

  func execute(name: String, description: String) async throws -> WorkspaceDTO {
    let isValid = ValidateWorkspaceName.validate(name: name, desc: description)
    if !isValid.isValid {
      if let nameError = isValid.nameError {
        throw CreateWorkspaceUsecaseError(nameError)
      } else if let descError = isValid.descError {
        throw CreateWorkspaceUsecaseError(descError)
      }
    }

    return try await repo.create(name: name, description: description)
  }

  func validate(name: String, desc: String) -> (Bool, String?, String?) {
    let isValid = ValidateWorkspaceName.validate(name: name, desc: desc)
    return (isValid.isValid, isValid.nameError, isValid.descError)
  }
}
```

### GetWorkspaceUsecase

```swift
final class GetWorkspaceUsecase {
  private let repo: WorkspaceRepository

  init(repo: WorkspaceRepository) {
    self.repo = repo
  }

  func execute(id: UUID) async throws -> WorkspaceDTO? {
    if let workspace = try await repo.getById(id) {
      return workspace.toDTO()
    }
    return nil
  }
}
```

### AddLanguageUsecase

```swift
final class AddLanguageUsecase {
  private let repo: WSLanguagesRepo
  private let langRepo: LangRepository

  init(repo: WSLanguagesRepo, langRepo: LangRepository) {
    self.repo = repo
    self.langRepo = langRepo
  }

  func execute(workspaceId: UUID, lang: String) async throws -> WorkspaceLangEntity {
    guard let availableLang = langRepo.isValid(code: lang) else {
      throw AddLanguageError(message: "Invalid language code")
    }

    return try await repo.add(workspaceId: workspaceId, lang: lang)
  }
}
```

### ToggleLangStatusUsecase

```swift
final class ToggleLangStatusUsecase {
  private let repo: WSLanguagesRepo

  init(repo: WSLanguagesRepo) {
    self.repo = repo
  }

  func execute(id: UUID) async throws -> WorkspaceLangEntity? {
    let entity = try await repo.toggleActiveStatus(id)
    return entity
  }
}
```

### SwitchDefaultLanguageUsecase

```swift
final class SwitchDefaultLanguageUsecase {
  private let repo: WorkspaceRepository

  init(repo: WorkspaceRepository) {
    self.repo = repo
  }

  func execute(id: UUID, lang: String) async throws -> WorkspaceDTO? {
    let workspace = try await repo.switchDefaultLang(id: id, lang: lang)
    return workspace
  }
}
```

### AddAppUseCase

```swift
final class AddAppUseCase {
  private let repo: WorkspaceRepository
  private let appsRepo: WSAppsRepo

  init(repo: WorkspaceRepository, appsRepo: WSAppsRepo) {
    self.repo = repo
    self.appsRepo = appsRepo
  }

  func execute(name: String, description: String, workspaceId: UUID, appPlatformId: String) async throws -> WSAppDTO {
    let isValid = ValidateAppName.validate(name: name)
    guard isValid.isValid else {
      throw AddAppError(message: isValid.error)
    }

    let app = try await appsRepo.create(
      name: name,
      description: description,
      workspaceId: workspaceId,
      appPlatformId: appPlatformId
    )

    // Save access time for workspace
    try await repo.saveAccessTime(id: workspaceId)

    return app
  }
}
```

### AddTranslationGroupUsecase

```swift
final class AddTranslationGroupUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  func execute(workspaceId: UUID, name: String) async throws -> TranslationGroupDTO {
    return try await repo.addGroup(workspaceId: workspaceId, name: name, parentId: nil)
  }
}
```

### ListTranslationsUsecase

```swift
final class ListTranslationsUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  func execute(workspaceId: UUID) async throws -> [TranslationGroupDTO] {
    return try await repo.fetchAllGroups(workspaceId: workspaceId)
  }
}
```

---

## Factory Pattern Explanation

The Factory library creates objects with specific scopes:

- `Factory<T>` - A factory that creates instances of type `T`
- `.scope(.singleton)` - Single instance shared across the app
- `.scope(.shared)` - Shared instance within workspace scope
- `.scope(.temporary)` - New instance each time (used less frequently)

---

## Summary

The DI containers wire up the entire application architecture:

1. **Workspace Container**: Manages workspace CRUD operations
2. **Apps Container**: Manages app operations within workspaces
3. **Language Container**: Manages language configuration
4. **Translation Container**: Manages translation groups and keys

Each container provides:
- Repositories (data access layer)
- Use Cases (business logic layer)
- ViewModels (presentation layer)

This modular approach allows for easy testing and maintenance.
