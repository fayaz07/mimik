# ViewModels Documentation

This document describes all ViewModels in the Mimik application.

## Overview

All ViewModels use Swift's `@Observable` macro (from Swift 5.10+) to automatically track state changes and trigger UI updates.

---

## Workspace ViewModels

### CreateWorkspaceVM

```swift
@Observable
class CreateWorkspaceVM {
  @Published var name: String = ""
  @Published var description: String = ""
  @Published var viewState: ViewState<WorkspaceDTO> = ViewState.loading()
  @Published var viewModelError: String?

  private let usecase: CreateWorkspaceUsecase

  // Initialize with factory
  init(usecase: CreateWorkspaceUsecase) {
    self.usecase = usecase
  }

  // Execute create operation
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

  // Reset form
  func reset() {
    self.name = ""
    self.description = ""
    self.viewModelError = nil
  }
}
```

---

### GetWorkspaceViewModel

```swift
@Observable
class GetWorkspaceViewModel {
  @Published var viewState: ViewState<WorkspaceDTO> = ViewState.idle()
  @Published var workspace: WorkspaceDTO?
  @Published var viewModelError: String?

  private let usecase: GetWorkspaceUsecase

  // Initialize with factory
  init(usecase: GetWorkspaceUsecase) {
    self.usecase = usecase
  }

  // Fetch workspace by ID
  func fetch(id: UUID) async {
    self.viewState = .loading
    do {
      self.workspace = try await usecase.execute(id: id)
      self.viewState = .success(workspace!)
    } catch {
      self.viewState = .error(error)
      self.viewModelError = error.localizedDescription
    }
  }

  // Reset
  func reset() {
    self.workspace = nil
    self.viewState = .idle
  }
}
```

---

### WorkspaceDetailViewModel

```swift
@Observable
class WorkspaceDetailViewModel {
  @Published var viewState: ViewState<WorkspaceDTO> = ViewState.idle()
  @Published var workspace: WorkspaceDTO?
  @Published var viewModelError: String?

  // Dependencies
  private let getUsecase: GetWorkspaceUsecase
  private let createUsecase: CreateWorkspaceUsecase
  private let deleteUsecase: DeleteWorkspaceUsecase
  private let switchLanguageUsecase: SwitchDefaultLanguageUsecase
  private let listAppsUsecase: ListAppsUsecase
  private let listLanguagesUsecase: ListWorkspaceLanguagesUsecase
  private let toggleLangStatusUsecase: ToggleLangStatusUsecase

  // Initialize with factory
  init(
    getUsecase: GetWorkspaceUsecase,
    createUsecase: CreateWorkspaceUsecase,
    deleteUsecase: DeleteWorkspaceUsecase,
    switchLanguageUsecase: SwitchDefaultLanguageUsecase,
    listAppsUsecase: ListAppsUsecase,
    listLanguagesUsecase: ListWorkspaceLanguagesUsecase,
    toggleLangStatusUsecase: ToggleLangStatusUsecase
  ) {
    self.getUsecase = getUsecase
    self.createUsecase = createUsecase
    self.deleteUsecase = deleteUsecase
    self.switchLanguageUsecase = switchLanguageUsecase
    self.listAppsUsecase = listAppsUsecase
    self.listLanguagesUsecase = listLanguagesUsecase
    self.toggleLangStatusUsecase = toggleLangStatusUsecase
  }

  // Fetch workspace
  func fetch(id: UUID) async {
    self.viewState = .loading
    do {
      self.workspace = try await getUsecase.execute(id: id)
      self.viewState = .success(workspace!)
    } catch {
      self.viewState = .error(error)
    }
  }

  // Switch default language
  func switchLanguage(id: UUID, lang: String) async {
    do {
      self.workspace = try await switchLanguageUsecase.execute(id: id, lang: lang)
    } catch {
      self.viewModelError = error.localizedDescription
    }
  }

  // Add language
  func addLanguage(id: UUID, lang: String) async {
    do {
      try await toggleLangStatusUsecase.execute(id)
    } catch {
      self.viewModelError = error.localizedDescription
    }
  }

  // Delete workspace
  func deleteWorkspace(id: UUID) async {
    do {
      try await deleteUsecase.execute(id: id)
      self.workspace = nil
    } catch {
      self.viewModelError = error.localizedDescription
    }
  }

  // Reset
  func reset() {
    self.workspace = nil
    self.viewState = .idle
  }
}
```

---

### WorkspaceListViewModel

```swift
@Observable
class WorkspaceListViewModel {
  @Published var workspaces: [WorkspaceDTO] = []
  @Published var viewState: ViewState<[WorkspaceDTO]> = ViewState.idle()
  @Published var viewModelError: String?

  private let usecase: ListWorkspacesUsecase

  // Initialize
  init(usecase: ListWorkspacesUsecase) {
    self.usecase = usecase
  }

  // Fetch all workspaces
  func fetch() async {
    self.viewState = .loading
    do {
      self.workspaces = try await usecase.execute()
      self.viewState = .success(workspaces)
    } catch {
      self.viewState = .error(error)
      self.viewModelError = error.localizedDescription
    }
  }

  // Reset
  func reset() {
    self.workspaces = []
    self.viewState = .idle
  }
}
```

---

### ListAppsViewModel

```swift
@Observable
class ListAppsViewModel {
  @Published var apps: [WSAppDTO] = []
  @Published var viewState: ViewState<[WSAppDTO]> = ViewState.idle()
  @Published var viewModelError: String?

  private let usecase: ListAppsUsecase

  // Initialize
  init(usecase: ListAppsUsecase) {
    self.usecase = usecase
  }

  // Fetch apps for workspace
  func fetch(workspaceId: UUID) async {
    self.viewState = .loading
    do {
      self.apps = try await usecase.execute(workspaceId: workspaceId)
      self.viewState = .success(apps)
    } catch {
      self.viewState = .error(error)
      self.viewModelError = error.localizedDescription
    }
  }

  // Reset
  func reset() {
    self.apps = []
    self.viewState = .idle
  }
}
```

---

### AddAppVM

```swift
@Observable
class AddAppVM {
  @Published var name: String = ""
  @Published var description: String = ""
  @Published var viewState: ViewState<WSAppDTO> = ViewState.loading()
  @Published var viewModelError: String?

  private let usecase: AddAppUseCase

  // Initialize with factory
  init(usecase: AddAppUseCase) {
    self.usecase = usecase
  }

  // Execute
  func execute(workspaceId: UUID, appPlatformId: String) async {
    self.viewState = .loading
    do {
      let app = try await usecase.execute(
        name: self.name,
        description: self.description,
        workspaceId: workspaceId,
        appPlatformId: appPlatformId
      )
      self.viewState = .success(app)
      self.viewModelError = nil
    } catch let error as AddAppError {
      self.viewModelError = error.localizedDescription
      self.viewState = .error(error)
    } catch {
      self.viewState = .error(error)
    }
  }

  // Reset
  func reset() {
    self.name = ""
    self.description = ""
    self.viewModelError = nil
  }
}
```

---

### ListWorkspaceLanguagesViewModel

```swift
@Observable
class ListWorkspaceLanguagesViewModel {
  @Published var languages: [WSLangDTO] = []
  @Published var viewState: ViewState<[WSLangDTO]> = ViewState.idle()
  @Published var viewModelError: String?

  private let usecase: ListWorkspaceLanguagesUsecase

  // Initialize with factory
  init(usecase: ListWorkspaceLanguagesUsecase) {
    self.usecase = usecase
  }

  // Fetch languages for workspace
  func fetch(workspaceId: UUID) async {
    self.viewState = .loading
    do {
      self.languages = try await usecase.execute(workspaceId: workspaceId)
      self.viewState = .success(languages)
    } catch {
      self.viewState = .error(error)
      self.viewModelError = error.localizedDescription
    }
  }

  // Reset
  func reset() {
    self.languages = []
    self.viewState = .idle
  }
}
```

---

### AddLanguageViewModel

```swift
@Observable
class AddLanguageViewModel {
  @Published var code: String = ""
  @Published var name: String = ""
  @Published var viewState: ViewState<WSLangDTO> = ViewState.loading()
  @Published var viewModelError: String?

  private let usecase: AddLanguageUsecase

  // Initialize with factory
  init(usecase: AddLanguageUsecase) {
    self.usecase = usecase
  }

  // Execute
  func execute(workspaceId: UUID) async {
    self.viewState = .loading
    do {
      let lang = try await usecase.execute(workspaceId: workspaceId, lang: self.code)
      self.viewState = .success(lang)
      self.viewModelError = nil
    } catch let error as AddLanguageError {
      self.viewModelError = error.localizedDescription
      self.viewState = .error(error)
    } catch {
      self.viewState = .error(error)
    }
  }

  // Reset
  func reset() {
    self.code = ""
    self.name = ""
    self.viewModelError = nil
  }
}
```

---

### WSLanguagesViewModel

```swift
@Observable
class WSLanguagesViewModel {
  @Published var languages: [WSLangDTO] = []
  @Published var viewState: ViewState<[WSLangDTO]> = ViewState.idle()
  @Published var viewModelError: String?

  private let addUsecase: AddLanguageUsecase
  private let getUsecase: GetWorkspaceUsecase
  private let switchUsecase: SwitchDefaultLanguageUsecase
  private let toggleUsecase: ToggleLangStatusUsecase

  // Initialize with factory
  init(
    usecase: AddLanguageUsecase,
    getUsecase: GetWorkspaceUsecase,
    switchUsecase: SwitchDefaultLanguageUsecase,
    toggleUsecase: ToggleLangStatusUsecase
  ) {
    self.addUsecase = usecase
    self.getUsecase = getUsecase
    self.switchUsecase = switchUsecase
    self.toggleUsecase = toggleUsecase
  }

  // Fetch languages
  func fetch(workspaceId: UUID) async {
    self.viewState = .loading
    do {
      self.languages = try await getUsecase.execute(id: workspaceId)?.toDTO() ?? []
      self.viewState = .success(languages)
    } catch {
      self.viewState = .error(error)
      self.viewModelError = error.localizedDescription
    }
  }

  // Add language
  func addLanguage(workspaceId: UUID, lang: String) async {
    do {
      try await addUsecase.execute(workspaceId: workspaceId, lang: lang)
      await fetch(workspaceId: workspaceId)
    } catch {
      self.viewModelError = error.localizedDescription
    }
  }

  // Toggle active status
  func toggleStatus(id: UUID) async {
    do {
      try await toggleUsecase.execute(id: id)
      await fetch(workspaceId: id)
    } catch {
      self.viewModelError = error.localizedDescription
    }
  }

  // Switch default language
  func switchDefault(id: UUID, lang: String) async {
    do {
      try await switchUsecase.execute(id: id, lang: lang)
      await fetch(workspaceId: id)
    } catch {
      self.viewModelError = error.localizedDescription
    }
  }

  // Reset
  func reset() {
    self.languages = []
    self.viewState = .idle
  }
}
```

---

## Translation ViewModels

### WSTranslationsViewModel

```swift
@Observable
class WSTranslationsViewModel {
  @Published var groups: [TranslationGroupDTO] = []
  @Published var viewState: ViewState<[TranslationGroupDTO]> = ViewState.idle()
  @Published var viewModelError: String?

  private let listUseCase: ListTranslationsUsecase

  // Initialize with factory
  init(listUseCase: ListTranslationsUsecase) {
    self.listUseCase = listUseCase
  }

  // Fetch translation groups
  func fetch(workspaceId: UUID) async {
    self.viewState = .loading
    do {
      self.groups = try await listUseCase.execute(workspaceId: workspaceId)
      self.viewState = .success(groups)
    } catch {
      self.viewState = .error(error)
      self.viewModelError = error.localizedDescription
    }
  }

  // Reset
  func reset() {
    self.groups = []
    self.viewState = .idle
  }
}
```

### AddTranslationGroupViewModel

```swift
@Observable
class AddTranslationGroupViewModel {
  @Published var name: String = ""
  @Published var viewState: ViewState<TranslationGroupDTO> = ViewState.loading()
  @Published var viewModelError: String?

  private let createUseCase: CreateTranslationUsecase

  // Initialize with factory
  init(createUseCase: CreateTranslationUsecase) {
    self.createUseCase = createUseCase
  }

  // Execute
  func execute(workspaceId: UUID) async {
    self.viewState = .loading
    do {
      let group = try await createUseCase.execute(workspaceId: workspaceId, name: self.name)
      self.viewState = .success(group)
      self.viewModelError = nil
    } catch let error as CreateTranslationUsecaseError {
      self.viewModelError = error.localizedDescription
      self.viewState = .error(error)
    } catch {
      self.viewState = .error(error)
    }
  }

  // Reset
  func reset() {
    self.name = ""
    self.viewModelError = nil
  }
}
```

---

## ViewState Pattern

```swift
enum ViewState<Data> {
  case loading
  case idle
  case success(Data)
  case error(Error)
  case empty

  var isLoading: Bool {
    switch self {
    case .loading:
      return true
    default:
      return false
    }
  }

  var data: Data? {
    switch self {
    case .success(let data):
      return data
    default:
      return nil
    }
  }

  var isIdle: Bool {
    switch self {
    case .idle:
      return true
    default:
      return false
    }
  }

  init() {
    self = .idle
  }

  init(loading: Bool = false) {
    self = loading ? .loading : .idle
  }

  init(empty: Bool = false) {
    self = empty ? .empty : .idle
  }

  init(_ data: Data?) {
    if let data = data {
      self = .success(data)
    } else {
      self = .empty
    }
  }

  init(error: Error) {
    self = .error(error)
  }
}
```

---

## Summary

All ViewModels follow this pattern:

1. **Properties**: `@Published` for state, regular properties for UI state
2. **Initial State**: `@Published var viewState: ViewState<T> = ViewState.loading()`
3. **Execution Method**: `func execute(_ params:) async`
4. **Error Handling**: Catch errors and set `viewModelError`
5. **Reset Method**: `func reset()` to clear state

This pattern ensures:
- Automatic UI updates via `@Observable`
- Consistent state management
- Clear separation of concerns
- Easy testing and maintenance
