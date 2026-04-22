# Project Architecture

## Overview

The Expenses app follows a layered architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer                             │
│  (Widgets, Components, and User Interactions)           │
├─────────────────────────────────────────────────────────┤
│               Business Logic Layer                      │
│    (State Management and Data Manipulation)             │
├─────────────────────────────────────────────────────────┤
│                  Data Layer                             │
│           (Models, DTOs, and Data Structures)           │
└─────────────────────────────────────────────────────────┘
```

## Directory Structure

### Root Level Files

- **pubspec.yaml**: Project configuration and dependency management
- **pubspec.lock**: Locked dependency versions for consistency
- **analysis_options.yaml**: Dart linting rules and code quality settings
- **README.md**: Project overview

### Key Directories

#### `/lib` - Application Source Code

The main application code directory containing all Dart files:

```
lib/
├── main.dart              # Entry point, App setup, root widgets
├── models/                # Data models and DTOs
│   └── transaction.dart   # Transaction data structure
└── components/            # Reusable UI components
    ├── graph.dart         # Graph/Chart display widget
    ├── transaction_form.dart    # Form component for input
    └── transaction_list.dart    # List display component
```

#### `/assets` - Static Resources

```
assets/
└── fonts/                 # Custom font files
    ├── Domine/           # Domine font family
    └── Quicksand/        # Quicksand font family (primary)
```

#### Platform-Specific Directories

- **/android**: Android-specific code, Gradle configuration
- **/ios**: iOS-specific code, Xcode configuration
- **/web**: Web platform configuration
- **/linux**: Linux platform configuration
- **/macos**: macOS platform configuration
- **/windows**: Windows platform configuration

#### Build & Test Directories

- **/build**: Compiled output and build artifacts
- **/test**: Unit tests and widget tests

## Architectural Layers

### 1. Data Layer (`lib/models/`)

**Responsibility**: Define data structures and models

**Components**:

- `Transaction` class - DTO (Data Transfer Object) representing a transaction
- Immutable data structures for reliability

**Pattern**: DTO (Data Transfer Object)

- Uses final properties
- Requires all fields in constructor
- No methods except basic getters

### 2. Business Logic Layer (`lib/main.dart`)

**Responsibility**: Manage state and business operations

**Key Elements**:

- `_ExpensesAppState` - Manages transaction list
- `_addTransaction()` - Business logic for adding transactions
- `_openTransactionFormModal()` - Navigation and modal handling
- State management via `setState()`

**State Management Approach**:

- Local state using `setState()`
- Transaction list stored in widget state
- Direct state mutation with `setState()` callback

### 3. UI/Presentation Layer (`lib/components/`, `lib/main.dart`)

**Responsibility**: Display data and handle user interactions

**Components**:

- **App** (Stateless) - Root widget, theme configuration
- **ExpensesApp** (Stateful) - Main app structure and state holder
- **TransactionForm** (Stateful) - Form input component
- **TransactionList** (Stateless) - Displays transaction list
- **Graph** (Stateless) - Displays graph visualization

## Data Flow

### Adding a Transaction

```
User Action (FAB Click)
        ↓
_openTransactionFormModal()
        ↓
Bottom Sheet Modal Displayed
        ↓
User Enters Data in TransactionForm
        ↓
_submitForm() triggered
        ↓
_addTransaction() called via callback
        ↓
setState() updates _transactions list
        ↓
UI Rebuilds
        ↓
TransactionList reflects new data
```

### Widget Tree Structure

```
App (MaterialApp)
  └── ExpensesApp (Scaffold)
      ├── AppBar
      │   └── IconButton (Add)
      ├── Body (Column)
      │   ├── Graph
      │   └── TransactionList
      │       └── ListView.builder
      │           └── TransactionItem Cards
      └── FloatingActionButton (Add)
```

## State Management Strategy

### Current Approach: setState()

The app uses `setState()` for state management:

```dart
void _addTransaction(String title, double value) {
  final newTransaction = Transaction(...);
  setState(() {
    _transactions.add(newTransaction);  // State update
  });
  Navigator.of(context).pop();
}
```

**Characteristics**:

- ✅ Simple and straightforward
- ✅ Good for small to medium apps
- ✅ Built into Flutter framework
- ⚠️ Can lead to performance issues in large apps
- ⚠️ Less testable

**Alternative Approaches** (for future scaling):

- **Provider**: Simple dependency injection and state management
- **Riverpod**: Modern state management with better performance
- **Bloc**: Complex state management for large applications
- **GetX**: Reactive state management and navigation

## Dependency Injection

Currently, the app uses:

- **Direct instantiation** for components
- **Callback functions** for parent-child communication
- **Theme access** via `Theme.of(context)`

Example:

```dart
// Components receive data and callbacks as constructor parameters
TransactionForm(onSubmit: _addTransaction)
TransactionList(transactions: _transactions)
```

## Theme Architecture

**Theme Configuration**:

- Centralized in `App` widget (Stateless)
- Uses Material Design 3
- `ThemeData` with custom colors and fonts
- `ColorScheme` with seed color approach

**Color Scheme**:

- Primary: Teal
- Secondary: Red
- Seed: Red (for Material Design 3 dynamic colors)

**Typography**:

- Font Family: Quicksand (primary)
- Font Family: Domine (available)

## Component Reusability

### Highly Reusable

- **TransactionList**: Takes transaction list as prop, completely pure
- **Graph**: Standalone stateless widget
- **TransactionForm**: Accepts onSubmit callback, reusable

### Tightly Coupled

- **ExpensesApp**: Contains business logic and state
- **main.dart**: Contains App configuration

## Future Architectural Improvements

### 1. Separate Constants

```
lib/
├── config/
│   └── constants.dart    # App-wide constants
```

### 2. Separate Themes

```
lib/
├── theme/
│   └── app_theme.dart    # Theme configuration
```

### 3. Separate Services

```
lib/
├── services/
│   └── transaction_service.dart    # Business logic
```

### 4. Better State Management

```
// Consider Provider or Riverpod for scalability
// Separate state from UI logic
```

### 5. Repository Pattern

```
lib/
├── repositories/
│   └── transaction_repository.dart    # Data access layer
```

## Performance Considerations

### Current Optimizations

1. **Stateless widgets** where state isn't needed (TransactionList, Graph)
2. **ListView.builder** for efficient list rendering
3. **const constructors** for immutable widgets
4. **Theme caching** via theme data

### Potential Improvements

1. Add `ListView.separated()` for item dividers
2. Implement pagination for large transaction lists
3. Use `const` more consistently across widgets
4. Add image caching for any future image assets
5. Consider `BLoC` for complex filtering/sorting operations

## Testing Architecture

The project structure supports:

- **Unit tests** - Test data models and business logic
- **Widget tests** - Test individual components
- **Integration tests** - Test entire user flows

Example test location:

```
test/
├── models/
│   └── transaction_test.dart
├── components/
│   └── transaction_list_test.dart
└── integration_tests/
    └── app_flow_test.dart
```

---

For more details on specific components, see:

- [Widgets Guide](./Widgets.md) - Widget types and implementation
- [Components Guide](./Components.md) - Individual component details
- [Models Guide](./Models.md) - Data structure documentation
