# Validation Documentation

This document describes all validation rules and validators in the Mimik application.

---

## Overview

Validation occurs at the **Use Case boundary**, not in the UI layer. This ensures:

- UI remains clean (no business logic)
- Validation is centralized and reusable
- Consistent error messages across the app
- Testable validation logic

---

## Workspace Validation

### ValidateWorkspaceName

```swift
struct WorkspaceValidationResult {
  let isValid: Bool
  let nameError: String?
  let descriptionError: String?
}

struct ValidateWorkspaceName {
  let minNameLength: Int = 1
  let maxNameLength: Int = 100
  let minDescriptionLength: Int = 0
  let maxDescriptionLength: Int = 500

  func validate(name: String, desc: String) -> WorkspaceValidationResult {
    let nameError = validateName(name: name, length: self.minNameLength)
    let descError = validateDescription(desc: desc, length: self.minDescriptionLength)

    return WorkspaceValidationResult(
      isValid: nameError == nil && descError == nil,
      nameError: nameError,
      descriptionError: descError
    )
  }

  private func validateName(name: String, length: Int) -> String? {
    guard name.isEmpty == false && name.count <= length else {
      return "Name must be between \(length) and \(maxNameLength) characters"
    }
    return nil
  }

  private func validateDescription(desc: String, length: Int) -> String? {
    guard desc.count <= length else {
      return "Description must be \(maxDescriptionLength) characters or less"
    }
    return nil
  }
}
```

---

## App Validation

### ValidateAppName

```swift
struct AppValidationResult {
  let isValid: Bool
  let nameError: String?
  let descriptionError: String?
}

struct ValidateAppName {
  let minNameLength: Int = 1
  let maxNameLength: Int = 100
  let minDescriptionLength: Int = 0
  let maxDescriptionLength: Int = 500

  func validate(name: String, description: String, workspaceId: UUID) -> AppValidationResult {
    let nameError = validateName(name: name, length: self.minNameLength)
    let descError = validateDescription(description: description, length: self.minDescriptionLength)

    return AppValidationResult(
      isValid: nameError == nil && descError == nil,
      nameError: nameError,
      descriptionError: descError
    )
  }

  private func validateName(name: String, length: Int) -> String? {
    guard name.isEmpty == false && name.count <= length else {
      return "Name must be between \(length) and \(maxNameLength) characters"
    }
    return nil
  }

  private func validateDescription(description: String, length: Int) -> String? -> String? {
    guard description.count <= length else {
      return "Description must be \(maxDescriptionLength) characters or less"
    }
    return nil
  }
}
```

---

## Language Validation

### ValidateLanguageCode

```swift
struct LanguageValidationResult {
  let isValid: Bool
  let codeError: String?
  let nameError: String?
}

struct ValidateLanguageCode {
  let minNameLength: Int = 1
  let maxNameLength: Int = 100

  func validate(code: String, name: String) -> LanguageValidationResult {
    let codeError = validateLanguageCode(code: code, length: self.minNameLength)
    let nameError = validateName(name: name, length: self.maxNameLength)

    return LanguageValidationResult(
      isValid: codeError == nil && nameError == nil,
      codeError: codeError,
      nameError: nameError
    )
  }

  private func validateLanguageCode(code: String, length: Int) -> String? {
    // Validate ISO 639-1/639-2 format (2-letter or 3-letter)
    guard code.isEmpty == false && code.count <= length else {
      return "Language code must be 2-3 letters (ISO 639-1/639-2)"
    }
    return nil
  }

  private func validateName(name: String, length: Int) -> String? {
    guard name.isEmpty == false && name.count <= length else {
      return "Name must be between \(length) and \(length) characters"
    }
    return nil
  }
}
```

---

## Translation Group Validation

### ValidateTranslationGroup

```swift
struct TranslationGroupValidationResult {
  let isValid: Bool
  let nameError: String?
}

struct ValidateTranslationGroup {
  let minNameLength: Int = 1
  let maxNameLength: Int = 100

  func validate(name: String) -> TranslationGroupValidationResult {
    let nameError = validateName(name: name, length: self.minNameLength)

    return TranslationGroupValidationResult(
      isValid: nameError == nil,
      nameError: nameError
    )
  }

  private func validateName(name: String, length: Int) -> String? {
    guard name.isEmpty == false && name.count <= length else {
      return "Name must be between \(length) and \(maxNameLength) characters"
    }
    return nil
  }
}
```

---

## Translation Key Validation

### ValidateTranslationKey

```swift
struct TranslationKeyValidationResult {
  let isValid: Bool
  let keyError: String?
}

struct ValidateTranslationKey {
  let minKeyLength: Int = 1
  let maxKeyLength: Int = 200

  func validate(key: String) -> TranslationKeyValidationResult {
    let keyError = validateKey(key: key, length: self.minKeyLength)

    return TranslationKeyValidationResult(
      isValid: keyError == nil,
      keyError: keyError
    )
  }

  private func validateKey(key: String, length: Int) -> String? {
    // Keys should start with a letter or underscore
    guard key.isEmpty == false && key.count <= length else {
      return "Key must be between \(length) and \(maxKeyLength) characters, start with a letter or underscore"
    }

    // Keys should not contain spaces or special characters (except _ and -)
    let allowedCharacters = CharacterSet.letters.union(CharacterSet.numbers)
    .union(CharacterSet.punctuationCharacters)
    .union(CharacterSet.dashes).union(CharacterSet.underScores)
    if key.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
      return "Key should only contain letters, numbers, underscores, hyphens, and periods"
    }

    return nil
  }
}
```

---

## Translation Value Validation

### ValidateTranslationValue

```swift
struct TranslationValueValidationResult {
  let isValid: Bool
  let valueError: String?
}

struct ValidateTranslationValue {
  let minValueLength: Int = 0
  let maxValueLength: Int = 2000

  func validate(value: String) -> TranslationValueValidationResult {
    let valueError = validateValue(value: value, length: self.minValueLength)

    return TranslationValueValidationResult(
      isValid: valueError == nil,
      valueError: valueError
    )
  }

  private func validateValue(value: String, length: Int) -> String? {
    guard value.count <= length else {
      return "Value must be \(maxValueLength) characters or less"
    }
    return nil
  }
}
```

---

## Use Case Integration

### Example: CreateWorkspaceUsecase

```swift
final class CreateWorkspaceUsecase {
  private let repo: WorkspaceRepository

  func execute(name: String, description: String) async throws -> WorkspaceDTO {
    // Validation at use case boundary
    let validation = ValidateWorkspaceName.validate(name: name, desc: description)
    if !validation.isValid {
      if let nameError = validation.nameError {
        throw CreateWorkspaceUsecaseError(nameError)
      }
    }

    // Business logic
    // ...

    // Repository call
    return try await repo.create(name: name, description: description)
  }
}
```

---

## Error Types

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

## Validation Best Practices

1. **Validate at use case boundary**: Keep UI layer clean
2. **Provide clear error messages**: Users should understand why validation failed
3. **Reuse validators**: Don't duplicate validation logic
4. **Test validation**: Ensure validators work correctly
5. **Handle validation errors gracefully**: Don't crash the app

---

## Summary

| Entity | Validator | Rule |
|-------|-----------|------|
| Workspace | `ValidateWorkspaceName` | Name: 1-100 chars, Description: 0-500 chars |
| App | `ValidateAppName` | Name: 1-100 chars, Description: 0-500 chars |
| Language | `ValidateLanguageCode` | Code: 2-3 letters (ISO 639-1/639-2), Name: 1-100 chars |
| Translation Group | `ValidateTranslationGroup` | Name: 1-100 chars |
| Translation Key | `ValidateTranslationKey` | Key: 1-200 chars, alphanumeric + `_` `-` `.` |
| Translation Value | `ValidateTranslationValue` | Value: 0-2000 chars |
