# Data Models Documentation

This document describes all CoreData models used in the Mimik application.

## CoreData Model

The CoreData model is located at:
`Mimik/App/Data/Sources/AppModels.xcdatamodeld`

## Entities

### 1. Workspace

The top-level organizational container for all translation work.

**Attributes:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Primary key |
| `name` | String | Display name (e.g., "My App") |
| `description` | String? | Optional description |
| `defLang` | String | Default language code (e.g., "en") |
| `createdAt` | Date | Creation timestamp |
| `updatedAt` | Date | Last modification timestamp |
| `lastAccessed` | Date | Last access timestamp |

**Relationships:**

| Relationship | Type | Description |
|--------------|------|-------------|
| `apps` | to-many | Apps in this workspace |
| `languages` | to-many | Languages in this workspace |
| `translationGroups` | to-many | Translation groups |

---

### 2. App

Represents different app platforms within a workspace.

**Attributes:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Primary key |
| `name` | String | Platform name (e.g., "iOS", "Android", "Web") |
| `description` | String? | Optional description |
| `workspaceId` | UUID | Workspace this app belongs to |
| `appPlatformId` | String | Platform identifier for sorting |
| `createdAt` | Date | Creation timestamp |
| `updatedAt` | Date | Last modification timestamp |
| `lastAccessed` | Date | Last access timestamp |

**Relationships:**

| Relationship | Type | Description |
|--------------|------|-------------|
| `workspace` | to-one | Parent workspace |

---

### 3. WorkspaceLang

Languages configured for a specific workspace.

**Attributes:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Primary key |
| `langCode` | String | Language code (e.g., "en", "es", "ja") |
| `name` | String | Display name (e.g., "English") |
| `workspaceId` | UUID | Workspace this language belongs to |
| `isDefault` | Bool | Is this the default language? |
| `createdAt` | Date | Creation timestamp |
| `updatedAt` | Date | Last modification timestamp |

**Relationships:**

| Relationship | Type | Description |
|--------------|------|-------------|
| `workspace` | to-one | Parent workspace |
| `translationValues` | to-many | Translation values for this language |

---

### 4. TranslationGroup

Hierarchical groups for organizing translations.

**Attributes:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Primary key |
| `name` | String | Group name |
| `workspaceId` | UUID | Parent workspace |
| `parentId` | UUID? | Parent group (if any) |
| `level` | Int | Nesting level |
| `createdAt` | Date | Creation timestamp |
| `updatedAt` | Date | Last modification timestamp |

**Relationships:**

| Relationship | Type | Description |
|--------------|------|-------------|
| `workspace` | to-one | Parent workspace |
| `parent` | to-one | Parent group |
| `children` | to-many | Child groups |
| `translationKeys` | to-many | Translation keys |

**Navigation:**

- Fetch direct children: `group.children`
- Fetch all descendants: `group.allChildren`

---

### 5. TranslationKey

Translation keys/labels in a specific group.

**Attributes:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Primary key |
| `key` | String | Translation key (e.g., "welcome.title") |
| `workspaceId` | UUID | Parent workspace |
| `groupId` | UUID | Translation group |
| `excludedApps` | Set<App> | Apps excluded from this key |
| `createdAt` | Date | Creation timestamp |
| `updatedAt` | Date | Last modification timestamp |

**Relationships:**

| Relationship | Type | Description |
|--------------|------|-------------|
| `workspace` | to-one | Parent workspace |
| `group` | to-one | Translation group |
| `translationValues` | to-many | Translation values |
| `translationValue.en` | to-one | Default language value |

---

### 6. TranslationValue

Translation value for a specific language.

**Attributes:**

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID | Primary key |
| `keyId` | UUID | Translation key |
| `workspaceId` | UUID | Parent workspace |
| `groupId` | UUID | Translation group |
| `langCode` | String | Language code |
| `value` | String | Translation value |
| `createdAt` | Date | Creation timestamp |
| `updatedAt` | Date | Last modification timestamp |

**Relationships:**

| Relationship | Type | Description |
|--------------|------|-------------|
| `workspace` | to-one | Parent workspace |
| `group` | to-one | Translation group |
| `key` | to-one | Translation key |
| `key.defaultLangValue` | to-one | Value for default language |

---

## Data Transfer Objects (DTOs)

### WorkspaceDTO

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

### WSAppDTO

```swift
struct WSAppDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let name: String
  let description: String
  let workspaceId: UUID
  let appPlatformId: String
  let createdAt: Date
  let updatedAt: Date
  let lastAccessed: Date
}
```

### WSLangDTO

```swift
struct WSLangDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let code: String
  let name: String
  let workspaceId: UUID
  let defaultLang: Bool
  let createdAt: Date
  let updatedAt: Date
}
```

### TranslationGroupDTO

```swift
struct TranslationGroupDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let name: String
  let workspaceId: UUID
  let parentId: UUID?
  let level: Int
  let createdAt: Date
  let updatedAt: Date
}
```

### TranslationKeyDTO

```swift
struct TranslationKeyDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let key: String
  let workspaceId: UUID
  let groupId: UUID
  let excludedApps: [UUID]
  let createdAt: Date
  let updatedAt: Date
}
```

### TranslationValueDTO

```swift
struct TranslationValueDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let keyId: UUID
  let workspaceId: UUID
  let groupId: UUID
  let langCode: String
  let value: String
  let createdAt: Date
  let updatedAt: Date
}
```

---

## Date Management

All entities use these timestamps:

| Timestamp | Usage |
|-----------|-------|
| `createdAt` | When the record was created |
| `updatedAt` | Last time the record was modified |
| `lastAccessed` | When the entity was last accessed |

## Conversion Extension Types

### Entity → DTO Extensions

```swift
extension WorkspaceEntity {
  func toDTO() -> WorkspaceDTO { ... }
}

extension AppEntity {
  func toDTO() -> WSAppDTO { ... }
}

extension WorkspaceLangEntity {
  func toDTO() -> WSLangDTO { ... }
}

extension TranslationGroupEntity {
  func toDTO() -> TranslationGroupDTO { ... }
}

extension TranslationKeyEntity {
  func toDTO() -> TranslationKeyDTO { ... }
}

extension TranslationValueEntity {
  func toDTO() -> TranslationValueDTO { ... }
}
```

### DTO → Entity Extensions

```swift
extension WorkspaceDTO {
  func toEntity() -> WorkspaceEntity { ... }
}

extension WSAppDTO {
  func toEntity() -> AppEntity { ... }
}

extension WSLangDTO {
  func toEntity() -> WorkspaceLangEntity { ... }
}

extension TranslationGroupDTO {
  func toEntity() -> TranslationGroupEntity { ... }
}

extension TranslationKeyDTO {
  func toEntity() -> TranslationKeyEntity { ... }
}

extension TranslationValueDTO {
  func toEntity() -> TranslationValueEntity { ... }
}
```

---

## Notes

- All `id` attributes are `UUID`
- All date attributes are `Date`
- All strings are non-optional
- Relationships use inverse naming conventions
- Optional relationships are marked with `?` in the type
