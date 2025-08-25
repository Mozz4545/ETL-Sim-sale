# SIM Store Module

This module follows Clean Architecture principles with clear separation of concerns.

## Directory Structure

```
sim_store/
├── data/                    # Data Layer
│   ├── models/             # Data transfer objects
│   ├── repositories/       # Repository implementations
│   └── datasources/        # External data sources (Firebase, API)
│
├── domain/                  # Business Logic Layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
│
├── presentation/            # Presentation Layer
│   ├── pages/              # UI screens
│   ├── widgets/            # Reusable UI components
│   ├── providers/          # State management
│   └── controllers/        # Page controllers
│
├── utils/                   # Utilities
│   ├── constants/          # App constants
│   ├── helpers/            # Helper functions
│   └── validators/         # Input validation
│
└── sim_store.dart          # Main export file
```

## How to Use

### Import the module
```dart
import 'package:your_app/features/sim_store/sim_store.dart';
```

### Use pages
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SimStorePage()),
);
```

### Use providers
```dart
final simCards = ref.watch(simCardsProvider);
```

### Use utilities
```dart
final formattedPrice = SimStoreHelpers.formatPrice(price);
final isValid = SimStoreValidators.validatePhoneNumber(phone);
```

## File Naming Conventions

- **Pages**: `*_page.dart` (e.g., `sim_store_page.dart`)
- **Widgets**: `*_widget.dart` (e.g., `sim_card_widget.dart`)
- **Providers**: `*_provider.dart` (e.g., `sim_store_provider.dart`)
- **Services**: `*_service.dart` (e.g., `sim_service.dart`)
- **Models**: `*_model.dart` (e.g., `sim_card_model.dart`)
- **Helpers**: `*_helpers.dart` (e.g., `sim_store_helpers.dart`)
- **Validators**: `*_validators.dart` (e.g., `sim_store_validators.dart`)
- **Constants**: `*_constants.dart` (e.g., `sim_store_constants.dart`)

## Best Practices

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Inversion**: Higher layers don't depend on lower layers
3. **Single Responsibility**: Each file has a single, well-defined purpose
4. **Testability**: Easy to test each component in isolation
5. **Maintainability**: Clear structure makes it easy to maintain and extend

## Migration Guide

When moving from old structure to new structure, update imports:

**Old:**
```dart
import '../pages/sim_store_page.dart';
import '../providers/sim_store_provider.dart';
import '../services/sim_service.dart';
```

**New:**
```dart
import '../sim_store/presentation/pages/sim_store_page.dart';
import '../sim_store/presentation/providers/sim_store_provider.dart';
import '../sim_store/data/datasources/sim_service.dart';
```

Or simply:
```dart
import '../sim_store/sim_store.dart';
```
