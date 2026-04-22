# Expenses Personal App - Documentation

## Overview

This is a comprehensive documentation guide for the **Expenses Personal App**, a Flutter application designed to help users track their personal expenses. The app allows users to add new transactions and visualize their spending data through an intuitive interface.

## Project Information

- **Name**: expenses
- **Type**: Flutter Mobile Application
- **Description**: Personal expense tracking application
- **SDK**: Dart 3.11.3+
- **Main Dependencies**: Flutter, Material Design 3, intl (for date formatting)

## Key Features

- ✅ Add new transactions with title and value
- ✅ View transaction history
- ✅ Visual expense graph representation
- ✅ Custom theme with Material Design 3
- ✅ Bottom sheet modal for transaction input
- ✅ Responsive layout for various screen sizes

## Documentation Structure

This documentation is organized into the following sections:

### 1. [Getting Started](./GettingStarted.md)

How to set up and run the project locally, including dependencies and environment setup.

### 2. [Project Architecture](./Architecture.md)

Detailed overview of the project structure, file organization, and architectural patterns used.

### 3. [Widgets: Stateless & Stateful](./Widgets.md)

In-depth explanation of Flutter widgets, differences between stateless and stateful widgets, and how they're used in this project.

### 4. [Data Models & DTO Pattern](./Models.md)

Understanding the DTO (Data Transfer Object) pattern used in the project and the Transaction data model.

### 5. [Components Guide](./Components.md)

Detailed description of each component: TransactionForm, TransactionList, and Graph.

### 6. [Themes & Styling](./Themes.md)

Custom theme configuration, Material Design 3 integration, and styling patterns used throughout the app.

### 7. [Modals & Navigation](./Modals.md)

How modals are implemented, bottom sheet usage, and navigation patterns in the application.

---

## Project Structure

```
lib/
├── main.dart              # Application entry point and main widget
├── models/
│   └── transaction.dart   # Transaction data model (DTO)
└── components/
    ├── graph.dart         # Expense graph component
    ├── transaction_form.dart    # Form for adding transactions
    └── transaction_list.dart    # List display of transactions
```

## Key Concepts Covered

- **Stateful Widgets**: `App`, `ExpensesApp`, `TransactionForm`
- **Stateless Widgets**: `TransactionList`, `Graph`
- **State Management**: Using `setState()` for local state management
- **Data Models**: Transaction DTO pattern
- **Theme System**: Material Design 3 with custom color scheme
- **Modal Bottom Sheet**: For form input
- **List Building**: Using `ListView.builder` for dynamic lists

## Quick Start

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk     # For Android
flutter build ios     # For iOS
```

## Navigation

Each section is independently readable but interconnected. Start with [Getting Started](./GettingStarted.md) if you're new to the project, or jump directly to the section relevant to your needs.

---

**Last Updated**: April 2026  
**Version**: 1.0.0
