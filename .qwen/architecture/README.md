# Mimik Architecture Documentation

This directory contains technical documentation for the Mimik application.

## Files

| File | Description |
|------|-----|
| `overview.md` | High-level architecture, layer structure, and design principles |
| `di-containers.md` | Dependency injection containers and their usage |
| `repositories.md` | Repository patterns and persistence abstraction |
| `viewmodels.md` | ViewModel pattern and state management |
| `validation.md` | Validation rules and error handling |
| `models.md` | Core data entities, DTOs, and domain models |
| `summary.md` | Complete architecture summary |

## Quick Summary

### Application Structure

```
Mimik/
├── .qwen/
│   └── architecture/
│       ├── overview.md          # Layer structure
│       ├── di-containers.md     # DI containers
│       ├── repositories.md      # Persistence layer
│       ├── viewmodels.md        # State management
│       ├── validation.md        # Validation rules
│       ├── models.md            # Data models
│       └── README.md            # This file
└── Sources/
    ├── Mimik/
    │   ├── Workspace/           # Workspace module
    │   ├── App/                 # App module
    │   ├── Language/            # Language module
    │   ├── Translation/         # Translation module
    │   └── UseCase/             # Use case implementations
```

### Core Patterns

1. **MVVM**: Model-View-ViewModel architecture
2. **Clean Architecture**: Use Cases orchestrate repositories
3. **Repository Pattern**: Persistence abstraction
4. **Dependency Injection**: Managed by DI containers
5. **ViewState Pattern**: Consistent UI state management

### Key Components

| Component | Responsibility |
|-----------|---------------|
| ViewModels | UI state, user interactions |
| Use Cases | Business logic orchestration |
| Repositories | Data persistence |
| DI Containers | Dependency management |
| ViewModels | State management via @Observable |

### Data Flow

```
[UI] -> [ViewModel] -> [Use Case] -> [Repository] -> [Persistence]
     |                    |                 |
     +---> UI Updates <---+---+---------->+
```

### Summary

| Layer | Components | Responsibilities |
|-------|-----------|-----------------|
| **UI** | ViewModels | State management, UI interactions |
| **Use Case** | Use Cases | Business logic orchestration |
| **Repository** | Repositories | Persistence operations |
| **DI Container** | DI Containers | Dependency injection |

---

## Navigation

### For Developers

- Start with `overview.md` to understand the architecture
- See `di-containers.md` for how to inject dependencies
- Use `viewmodels.md` for UI state management
- Implement repositories using `repositories.md`
- Add validation using `validation.md`

### For Testing

- Mock repositories using protocols
- Test use cases in isolation
- Test viewmodels with state management
- Validate input with validators

### For Code Review

- Check MVVM compliance
- Verify repository patterns
- Ensure proper dependency injection
- Validate validation rules
- Review use case implementations

---

## See Also

- Swift Architecture: https://github.com/swift-server/swift-docc-plugin
- SwiftUI Best Practices: https://developer.apple.com/tutorials/swiftui/viewmodels
- Clean Architecture: Uncle Bob's blog
- Repository Pattern: Martin Fowler

---

## Contact

For questions or clarifications, refer to the code comments or create issues in the repository.
