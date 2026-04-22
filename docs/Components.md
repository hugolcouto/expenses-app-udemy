# Components Guide

## Overview

The Expenses app is built with reusable, self-contained components. Each component has a specific responsibility and can be understood independently, though they work together in the main application.

## Component Architecture

```
ExpensesApp (Main Container)
├── AppBar
│   └── Title + Add Button
├── Body
│   ├── Graph Component
│   └── TransactionList Component
│       └── Transaction Items (built dynamically)
└── FloatingActionButton
    └── Opens TransactionForm (in Modal)

Modal
└── TransactionForm Component
```

---

## 1. Graph Component

### File Location

`lib/components/graph.dart`

### Type

**Stateless Widget**

### Purpose

Displays a visual representation section for transaction data (currently a placeholder for graph visualization).

### Implementation

```dart
class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Gráfico',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
      ),
    );
  }
}
```

### Structure Breakdown

| Component  | Purpose                                   |
| ---------- | ----------------------------------------- |
| `SizedBox` | Container with full width, defined height |
| `Card`     | Material Design card with elevation       |
| `Padding`  | Spacing around content                    |
| `Text`     | Display "Gráfico" label                   |

### Theme Integration

```dart
// Uses theme colors and styles
color: Theme.of(context).primaryColor,           // Teal background
style: Theme.of(context).appBarTheme.titleTextStyle,  // Styled text
```

### Properties

- **Width**: `double.infinity` (takes full available width)
- **Color**: `primaryColor` (Teal from theme)
- **Elevation**: 3 (shadow depth)
- **Padding**: 8.0 (all sides)

### Future Enhancement

Currently a placeholder. Could be enhanced with:

```dart
// Pseudo-code for future implementation
class Graph extends StatelessWidget {
  final List<Transaction> transactions;

  const Graph({required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Calculate summary data
    double totalSpent = transactions
        .fold(0, (sum, t) => sum + t.value);

    double monthlyAverage = totalSpent /
        (transactions.isEmpty ? 1 :
         transactions.map((t) => t.date.month).toSet().length);

    return Card(
      child: Column(
        children: [
          Text('Total: R\$ ${totalSpent.toStringAsFixed(2)}'),
          Text('Monthly Avg: R\$ ${monthlyAverage.toStringAsFixed(2)}'),
          // Actual chart widget here (charts package)
        ],
      ),
    );
  }
}
```

### Usage

```dart
// In ExpensesApp build method
Column(
  children: [
    Graph(),  // No props needed - stateless
    TransactionList(transactions: _transactions),
  ],
)
```

---

## 2. TransactionList Component

### File Location

`lib/components/transaction_list.dart`

### Type

**Stateless Widget**

### Purpose

Displays a scrollable list of all transactions with their details (title, value, date).

### Implementation

```dart
class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
            ),
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Transaction value
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "R\$ ${transaction.value.toStringAsFixed(2)
                          .replaceAll('.', ',')}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Right: Transaction title and date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        transaction.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        DateFormat('d/MM/y').format(transaction.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### Constructor

```dart
const TransactionList({
  super.key,
  required this.transactions,
});

final List<Transaction> transactions;  // Passed from parent
```

**Props**:

- `transactions` (required) - List of Transaction objects to display

### Widget Tree

```
SizedBox (400px height)
└── ListView.builder
    └── Card (repeated for each transaction)
        └── Padding
            └── Row (2 columns layout)
                ├── Container (left column - value)
                └── Column (right column - title & date)
```

### Key Features

#### 1. **Efficient List Rendering with ListView.builder**

```dart
ListView.builder(
  itemCount: transactions.length,     // Number of items
  itemBuilder: (context, index) {     // Builds each item
    final transaction = transactions[index];
    return Card(...);
  },
)
```

**Why `ListView.builder`?**

- ✅ Only renders visible items (memory efficient)
- ✅ Scrollable list
- ✅ Supports dynamic lists
- ✅ Better performance for large lists

#### 2. **Currency Formatting**

```dart
// Input: 50.00
// Process:
// - toStringAsFixed(2) → "50.00"
// - replaceAll('.', ',') → "50,00"
// Output: "R$ 50,00"

"R\$ ${transaction.value.toStringAsFixed(2).replaceAll('.', ',')}"
```

**Localization**: Formats to Brazilian Portuguese currency format.

#### 3. **Date Formatting**

```dart
// Requires: import 'package:intl/intl.dart';

DateFormat('d/MM/y').format(transaction.date)
// April 22, 2024 → "22/04/24"
```

#### 4. **Responsive Layout with Row**

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Left: value (teal, bold, large)
    // Right: title and date (gray, smaller)
  ],
)
```

**Layout**: Two-column layout with space between items

### Styling

| Element         | Style                  |
| --------------- | ---------------------- |
| Card background | `Colors.grey.shade200` |
| Value text      | Teal, bold, 20px       |
| Title text      | Dark gray, bold, 16px  |
| Date text       | Light gray, 12px       |
| Card corners    | Circular, radius 20    |
| Padding         | 10px all sides         |

### Data Flow

```
Parent (ExpensesApp) has List<Transaction>
        ↓
Passes to TransactionList as prop
        ↓
ListView.builder iterates over each
        ↓
Card widget created for each transaction
        ↓
Data extracted and displayed
```

### Usage

```dart
// In ExpensesApp build method
TransactionList(transactions: _transactions)
```

### Limitations & Future Improvements

**Current Limitations**:

- ❌ No delete functionality
- ❌ No edit functionality
- ❌ No empty state message
- ❌ Fixed height (400px) - not responsive

**Future Enhancements**:

```dart
// Empty state
if (transactions.isEmpty) {
  return Center(
    child: Text('No transactions yet'),
  );
}

// Swipe to delete
Dismissible(
  key: Key(transaction.id),
  onDismissed: (direction) {
    // Delete transaction
  },
  child: Card(...),
)

// Responsive height
LayoutBuilder(
  builder: (context, constraints) {
    return SizedBox(
      height: constraints.maxHeight * 0.5,
      child: ListView.builder(...),
    );
  },
)
```

---

## 3. TransactionForm Component

### File Location

`lib/components/transaction_form.dart`

### Type

**Stateful Widget**

### Purpose

Provides a form for users to input transaction details (title and value) and submit them.

### Implementation

```dart
class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, required this.onSubmit});

  final void Function(String, double) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  void _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(
      valueController.text.replaceAll(',', '.')
    );

    if (title != "" && value != null) {
      widget.onSubmit(title, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            // Title input field
            TextField(
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: titleController,
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Título",
              ),
            ),
            // Value input field
            TextField(
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: valueController,
              onSubmitted: (_) => _submitForm(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Valor",
              ),
            ),
            // Submit button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _submitForm,
              child: Text(
                "Nova transação",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    super.dispose();
  }
}
```

### Constructor

```dart
const TransactionForm({
  super.key,
  required this.onSubmit,
});

final void Function(String, double) onSubmit;  // Callback function
```

**Props**:

- `onSubmit` (required) - Callback function `(String, double) → void`

### State

```dart
final titleController = TextEditingController();
final valueController = TextEditingController();
```

**Purpose**: Track text input from user

### Widget Structure

```
Card (elevated)
└── Padding
    └── Column (vertical layout)
        ├── TextField (title)
        ├── TextField (value)
        └── ElevatedButton (submit)
```

### Key Features

#### 1. **TextEditingController**

```dart
final titleController = TextEditingController();

// Accessing the value
String title = titleController.text;

// Clearing the field
titleController.clear();

// Listening for changes
titleController.addListener(() {
  print(titleController.text);
});

// Cleanup - MUST do this!
@override
void dispose() {
  titleController.dispose();  // Prevents memory leaks
  super.dispose();
}
```

#### 2. **TextField Configuration**

**Title Field**:

```dart
TextField(
  controller: titleController,        // Track input
  onSubmitted: (_) => _submitForm(),  // Submit on enter
  onTapOutside: (event) =>
    FocusManager.instance.primaryFocus?.unfocus(),  // Hide keyboard
  decoration: InputDecoration(
    border: OutlineInputBorder(...),
    focusedBorder: OutlineInputBorder(...),  // Blue border when focused
    labelText: "Título",
  ),
)
```

**Value Field**:

```dart
TextField(
  controller: valueController,
  keyboardType: TextInputType.numberWithOptions(
    decimal: true,  // Allows decimal numbers
  ),
  // ... rest of config
)
```

#### 3. **Validation and Parsing**

```dart
void _submitForm() {
  final title = titleController.text;

  // Parse with error handling
  final value = double.tryParse(
    valueController.text.replaceAll(',', '.')  // Handle , or .
  );

  // Validation
  if (title != "" && value != null) {
    // Call parent callback
    widget.onSubmit(title, value);
  }
}
```

**Validation checks**:

- ✅ Title not empty
- ✅ Value is a valid number

#### 4. **Number Formatting**

```dart
// User input: "50,00"
valueController.text.replaceAll(',', '.')
// Result: "50.00"

double.tryParse("50.00")  // Returns 50.0 or null
```

**Supports**: Both Brazilian (comma) and US (dot) decimal formats

#### 5. **Keyboard Dismissal**

```dart
onTapOutside: (PointerDownEvent event) {
  FocusManager.instance.primaryFocus?.unfocus();
}
```

**Effect**: Hides keyboard when tapping outside the field

### Styling

| Element           | Style                 |
| ----------------- | --------------------- |
| Container         | Card with elevation 5 |
| Padding           | 8.0 on all sides      |
| Text field border | Rounded (radius 20)   |
| Focused border    | Teal, width 2         |
| Button background | Primary color (teal)  |
| Button text       | White                 |
| Spacing           | 10px between elements |

### Data Flow

```
User fills form
        ↓
Presses button or hits enter
        ↓
_submitForm() called
        ↓
Validation check
        ↓
onSubmit callback invoked
        ↓
Parent (_addTransaction) processes
        ↓
Modal closes (Navigator.pop)
```

### Usage

```dart
// In ExpensesApp - open modal with form
showModalBottomSheet(
  context: context,
  builder: (_) {
    return TransactionForm(
      onSubmit: _addTransaction,  // Pass callback
    );
  },
);
```

### Lifecycle

```
1. Form opens in modal
   ↓
2. State created, controllers initialized
   ↓
3. User types and interacts
   ↓
4. Submit triggered
   ↓
5. Modal closes (parent calls Navigator.pop)
   ↓
6. dispose() called - controllers cleaned up
```

---

## Component Composition

### Parent-Child Communication

```
ExpensesApp (Parent)
    ├── data: _transactions
    ├── methods: _addTransaction
    └── children:
        ├── Graph (prop: none)
        └── TransactionList (prop: transactions)

ExpensesApp (via Modal)
    └── TransactionForm (prop: onSubmit callback)
        └── Triggers: _addTransaction
```

### Props Flow (Unidirectional)

```
Parent → Child: Data (props)
Child → Parent: Events (callbacks)
```

### Example

```dart
// Parent passes data down
TransactionList(transactions: _transactions)

// Form sends data up via callback
TransactionForm(onSubmit: _addTransaction)
```

---

## Best Practices Applied

✅ **Single Responsibility**: Each component does one thing  
✅ **Reusability**: Components can be used elsewhere  
✅ **Stateless where possible**: Graph and List are stateless  
✅ **Controlled components**: Form uses TextEditingController  
✅ **Proper cleanup**: Form disposes controllers  
✅ **Theme integration**: Uses Theme.of(context)  
✅ **Keyboard handling**: Proper focus management  
✅ **Number handling**: Supports multiple formats

---

For more details, see:

- [Widgets Guide](./Widgets.md) - Stateful vs Stateless concepts
- [Architecture Guide](./Architecture.md) - Component hierarchy
- [Modals Guide](./Modals.md) - Modal implementation details
