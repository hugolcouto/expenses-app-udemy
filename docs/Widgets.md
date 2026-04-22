# Flutter Widgets: Stateless & Stateful

## What is a Widget?

A **Widget** is the fundamental building block of any Flutter application. Everything in Flutter is a widget—from buttons to layouts to entire screens. Widgets are immutable declarations of UI that describe how a part of the user interface should appear.

## Widget Lifecycle

All widgets have a lifecycle:

```
Widget Creation
     ↓
Widget Rendering
     ↓
Widget Update (if needed)
     ↓
Widget Disposal
```

## Stateless Widgets

### Definition

A **Stateless Widget** is a widget whose state cannot change. Once created, its properties are immutable and don't change during the widget's lifetime.

### Characteristics

- ✅ Immutable - properties cannot change
- ✅ Simple and lightweight
- ✅ Pure function of input (props)
- ✅ No internal state
- ✅ Faster to build
- ✅ Easy to test

### Structure

```dart
class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Hello World');
  }
}
```

### Key Method

- **`build(BuildContext context)`** - Only method to override. Returns the widget tree.

### Lifecycle (Simple)

```
build() → Widget rendered → Never updated
```

### Examples in the Project

#### 1. **Graph Widget** (`lib/components/graph.dart`)

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

**Why Stateless?**

- Doesn't need to update itself
- Just displays theme-based styling
- Pure representation of the graph section

#### 2. **TransactionList Widget** (`lib/components/transaction_list.dart`)

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
            // ... item UI
          );
        },
      ),
    );
  }
}
```

**Why Stateless?**

- Receives transaction list as parameter
- Doesn't modify transactions internally
- Pure display of data passed from parent
- Parent (ExpensesApp) manages the state

#### 3. **App Widget** (`lib/main.dart`)

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpensesApp(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Quicksand",
        appBarTheme: AppBarTheme(...),
        colorScheme: ColorScheme.fromSeed(...),
      ),
    );
  }
}
```

**Why Stateless?**

- Configuration widget
- Theme doesn't change at runtime
- Only creates the app structure

### When to Use Stateless Widgets

✅ Displaying static information  
✅ Creating reusable UI components that receive props  
✅ Building presentation layers  
✅ Creating configuration widgets  
✅ When data comes from parent widget or theme

---

## Stateful Widgets

### Definition

A **Stateful Widget** is a widget that can change its appearance in response to events triggered during the widget's lifetime.

### Characteristics

- 🔄 Mutable state - internal data can change
- 🔄 More complex but more powerful
- 🔄 Requires State class
- 🔄 Can handle user input
- 🔄 Can manage internal state
- 🔄 Slower to build than stateless

### Structure

```dart
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          counter++;
        });
      },
      child: Text('Count: $counter'),
    );
  }
}
```

### Key Methods

1. **`createState()`** - Creates the State instance
2. **`build(BuildContext context)`** - Returns the widget tree (in State class)
3. **`setState(VoidCallback fn)`** - Notifies framework of state changes
4. **`initState()`** - Called when State is created (optional)
5. **`dispose()`** - Called when State is disposed (optional)

### Lifecycle (Detailed)

```
StatefulWidget Created
          ↓
createState() called
          ↓
initState() called (optional initialization)
          ↓
build() called (render UI)
          ↓
User interacts / Event occurs
          ↓
setState() called (update state)
          ↓
build() called again (re-render)
          ↓
dispose() called (cleanup)
```

### Examples in the Project

#### 1. **ExpensesApp Widget** (`lib/main.dart`)

```dart
class ExpensesApp extends StatefulWidget {
  const ExpensesApp({super.key});

  @override
  State<ExpensesApp> createState() => _ExpensesAppState();
}

class _ExpensesAppState extends State<ExpensesApp> {
  final List<Transaction> _transactions = [];

  void _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(...),
      body: Column(
        children: [
          Graph(),
          TransactionList(transactions: _transactions),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

**Why Stateful?**

- Manages list of transactions (mutable state)
- State changes when user adds transaction
- Needs to rebuild UI when list changes
- Handles business logic for adding transactions

**State Variables**:

- `_transactions` - List of transactions (private, mutable)

**State Methods**:

- `_addTransaction()` - Adds new transaction to state
- `_openTransactionFormModal()` - Opens transaction form modal
- `setState()` - Triggers rebuild with new data

#### 2. **TransactionForm Widget** (`lib/components/transaction_form.dart`)

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
    final value = double.tryParse(valueController.text.replaceAll(',', '.'));
    if (title != "" && value != null) {
      widget.onSubmit(title, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextField(
            controller: titleController,
            onSubmitted: (_) => _submitForm(),
            decoration: InputDecoration(labelText: "Título"),
          ),
          TextField(
            controller: valueController,
            onSubmitted: (_) => _submitForm(),
            decoration: InputDecoration(labelText: "Valor"),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text("Nova transação"),
          ),
        ],
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

**Why Stateful?**

- Manages `TextEditingController` (mutable state)
- Controllers track text input changes
- Validates and processes user input
- Needs to maintain controller lifecycle

**State Variables**:

- `titleController` - Controls title text field
- `valueController` - Controls value text field

**Key Pattern**: **Controlled TextFields**

- `TextEditingController` manages text value
- Allows reading, clearing, and validation
- Must be disposed to prevent memory leaks

---

## Key Differences Summary

| Aspect          | Stateless       | Stateful                                 |
| --------------- | --------------- | ---------------------------------------- |
| **Mutability**  | Immutable       | Mutable state                            |
| **Complexity**  | Simple          | Complex                                  |
| **Classes**     | 1 (Widget only) | 2 (Widget + State)                       |
| **Methods**     | `build()`       | `createState()`, `build()`, `setState()` |
| **Rebuilds**    | Never updates   | Updates on `setState()`                  |
| **Use Case**    | Display data    | Handle user interaction                  |
| **Performance** | Faster          | Slower                                   |
| **Testability** | Easier          | Harder                                   |

## BuildContext

Both stateless and stateful widgets receive a `BuildContext`:

```dart
Widget build(BuildContext context) {
  // Access theme
  Theme.of(context).primaryColor;

  // Access navigator
  Navigator.of(context).pop();

  // Access screen size
  MediaQuery.of(context).size.width;

  // Access parent widget data
  // (if using InheritedWidget)
}
```

`BuildContext` provides access to:

- Theme data
- Navigation
- Screen metrics
- Parent widget data
- Localization

## setState() Deep Dive

### What setState() Does

```dart
setState(() {
  // Update state variables here
  _counter++;
  _items.add(newItem);
  _isLoading = false;
});
// Automatically calls build() after this block
```

### How It Works

1. Changes the state variables
2. Marks widget as "dirty"
3. Schedules a rebuild
4. Calls `build()` method again
5. Framework compares old and new widget tree (diffing)
6. Updates only what changed in the UI

### Performance Consideration

```dart
// ❌ BAD: setState() rebuilds entire widget tree
setState(() {
  _counter++;
  _apiData = await fetchData();
});

// ✅ GOOD: Only update what's necessary
setState(() {
  _counter++;
});
// Fetch data separately if it doesn't need immediate rebuild
```

## Const Constructors

Flutter apps often use `const` with widgets for performance:

```dart
// Creates the same object - no memory allocation
const Widget1();
const Widget1();
// These are identical in memory

// Different objects
Widget2();
Widget2();
```

All widgets in this project use `const` constructors:

```dart
const Graph({super.key});
const TransactionList({super.key, required this.transactions});
```

This is a best practice for performance optimization.

## Common Patterns

### Pattern 1: Pure Stateless Component

```dart
class MyComponent extends StatelessWidget {
  const MyComponent({required this.data});
  final String data;

  @override
  Widget build(BuildContext context) => Text(data);
}
```

### Pattern 2: Callback-Based Communication

```dart
class FormComponent extends StatefulWidget {
  const FormComponent({required this.onSubmit});
  final void Function(String) onSubmit;

  @override
  State<FormComponent> createState() => _FormComponentState();
}
```

### Pattern 3: State with Controller

```dart
class InputField extends StatefulWidget {
  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(controller: _controller);
}
```

---

For practical implementation details, see:

- [Components Guide](./Components.md) - How these widgets are used
- [Models Guide](./Models.md) - Data passed to widgets
- [Architecture Guide](./Architecture.md) - Design patterns
