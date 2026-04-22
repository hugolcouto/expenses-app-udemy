# Modals & Navigation Guide

## What is a Modal?

A **Modal** is a dialog window/panel that displays over the main content and requires user interaction before returning to the main application. It "pauses" the main app interaction until the modal is closed.

### Characteristics

- 📌 Overlays the main UI
- 📌 Requires action before dismissal (usually)
- 📌 Takes focus from main content
- 📌 Often blocks interaction with background

---

## Bottom Sheet Modal Implementation

### File Location

`lib/main.dart` - `ExpensesApp` class

### Overview

The Expenses app uses a **Bottom Sheet Modal** to display the transaction form.

### What is a Bottom Sheet?

A **Bottom Sheet** is a modal that slides up from the bottom of the screen. It's perfect for:

- Quick input forms
- Menus
- Action options
- Additional content

### Basic Implementation

```dart
void _openTransactionFormModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return TransactionForm(onSubmit: _addTransaction);
    },
  );
}
```

### How It Works

1. **User Action**: Clicks FAB or AppBar button
2. **Function Called**: `_openTransactionFormModal()` invoked
3. **Modal Displayed**: `showModalBottomSheet()` shows the modal
4. **Widget Returned**: `TransactionForm` component displayed
5. **User Submits**: Form calls `_addTransaction()` callback
6. **Modal Closes**: `Navigator.of(context).pop()` closes modal
7. **List Updated**: Parent state updates, UI rebuilds

### Call Points

**Floating Action Button**:

```dart
floatingActionButton: FloatingActionButton(
  onPressed: () => _openTransactionFormModal(context),
  backgroundColor: Theme.of(context).primaryColor,
  child: Icon(Icons.add, color: Colors.white),
)
```

**AppBar Icon Button**:

```dart
appBar: AppBar(
  title: Text("Despesas Pessoais"),
  actions: [
    IconButton(
      onPressed: () => _openTransactionFormModal(context),
      icon: Icon(Icons.add),
      color: Colors.white,
    ),
  ],
)
```

Both trigger the same modal.

---

## showModalBottomSheet() API

### Function Signature

```dart
Future<T> showModalBottomSheet<T>(
  {required BuildContext context,
  required WidgetBuilder builder,
  // Optional parameters:
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  double? constraints,})
```

### Required Parameters

| Parameter | Type          | Purpose                            |
| --------- | ------------- | ---------------------------------- |
| `context` | BuildContext  | Build context of parent            |
| `builder` | WidgetBuilder | Function that builds modal content |

### Current Project Configuration

```dart
showModalBottomSheet(
  context: context,                        // Get from parent context
  builder: (_) {                          // Build modal UI
    return TransactionForm(onSubmit: _addTransaction);
  },
)
```

### Optional Parameters (Common)

```dart
showModalBottomSheet(
  context: context,
  builder: (_) => MyModal(),
  isDismissible: true,              // Allow tap outside to close
  enableDrag: true,                 // Allow drag to close
  backgroundColor: Colors.white,    // Modal background
  shape: RoundedRectangleBorder(   // Rounded top corners
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
    ),
  ),
  isScrollControlled: false,        // Fixed height vs scrollable
)
```

---

## Modal Lifecycle

### Sequence Diagram

```
User Action (FAB click)
        ↓
_openTransactionFormModal() called
        ↓
showModalBottomSheet() triggered
        ↓
builder() executes
        ↓
TransactionForm() created & rendered
        ↓
User interacts with form
        ↓
User submits form
        ↓
onSubmit callback executed
        ↓
_addTransaction() processes data
        ↓
Navigator.pop() called in _addTransaction
        ↓
Modal dismissed (slides down)
        ↓
Previous screen visible again
```

### Component States

```
Modal Display
     ↓
[TransactionForm - Stateful Widget]
  ├── State: titleController, valueController
  ├── Rendering: Text fields, button
  └── Interaction: User input
     ↓
Modal Interaction
     ↓
Submit Button Pressed
  ├── _submitForm() called
  ├── Validation performed
  └── onSubmit callback invoked
     ↓
Modal Closing
     ↓
Navigator.pop() removes modal
  └── Modal animates down
     ↓
Return to Previous Screen
  ├── ExpensesApp rendered
  ├── _transactions list updated
  └── TransactionList shows new data
```

---

## Closing the Modal

### Method 1: Navigator.pop()

Inside `TransactionForm._submitForm()`:

```dart
void _submitForm() {
  final title = titleController.text;
  final value = double.tryParse(valueController.text);

  if (title != "" && value != null) {
    // Send data to parent
    widget.onSubmit(title, value);

    // Close modal - THIS MUST HAPPEN
    Navigator.of(context).pop();
  }
}
```

**When Called**:

- User submits form successfully
- Data is sent to parent callback
- Modal is dismissed

### Method 2: Tap Outside (Default)

```dart
isDismissible: true,  // Allows closing by tapping outside
```

Users can tap the semi-transparent background to close without submitting.

### Method 3: Swipe Down

```dart
enableDrag: true,  // Allows dragging modal down to close
```

Users can drag the modal down from the top to close it.

### Method 4: Back Button

On Android devices, the back button automatically closes the modal.

---

## Passing Data Through Modals

### Parent → Modal

Data flows down via constructor:

```dart
// Parent creates modal with callback
showModalBottomSheet(
  context: context,
  builder: (_) {
    return TransactionForm(
      onSubmit: _addTransaction,  // Passing function
    );
  },
);

// Child receives callback
class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSubmit;

  const TransactionForm({required this.onSubmit});
}
```

### Modal → Parent

Data flows up via callback:

```dart
// Child calls parent function
widget.onSubmit(title, value);

// Parent receives and processes
void _addTransaction(String title, double value) {
  // Process data
  final newTransaction = Transaction(
    id: Random().nextDouble().toString(),
    title: title,
    value: value,
    date: DateTime.now(),
  );

  setState(() {
    _transactions.add(newTransaction);
  });

  // Close modal
  Navigator.of(context).pop();
}
```

### Data Flow Diagram

```
Parent Component
    ↓
    ├─→ Modal displayed with callback
    │       ↓
    │   Modal Component
    │       ↓
    │       ├─ Collect user input
    │       │
    │       ├─ Validate input
    │       │
    │       ├─ Call callback with data
    │       │       ↓
    │   Callback function executed
    │       ↓
    ├─← Data processed
    │
    ├─ State updated
    │
    ├─ Modal closed
    │
    └─ UI rebuilt with new data
```

---

## Navigation Stack

Flutter maintains a navigation stack (like a history):

```
Bottom: Original Screen (ExpensesApp)
   ↓
Top: Modal (TransactionForm)

When modal closes:
   ↓
Back to: Original Screen (ExpensesApp)
```

### Navigation Methods

```dart
// Push (go forward, add to stack)
Navigator.push(context, MaterialPageRoute(
  builder: (context) => NewScreen(),
));

// Pop (go back, remove from stack)
Navigator.pop(context);

// PopUntil (go back multiple levels)
Navigator.popUntil(context, ModalRoute.withName('/'));

// Named routes
Navigator.pushNamed(context, '/details');

// Bottom sheet (modal, not part of stack)
showModalBottomSheet(context: context, builder: (_) => Modal());
```

**Current Project**: Uses `showModalBottomSheet()` which doesn't add to the navigation stack—it's overlay-based.

---

## Advanced Modal Options

### Custom Modal with Shape

```dart
showModalBottomSheet(
  context: context,
  builder: (_) => TransactionForm(onSubmit: _addTransaction),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(25),
    ),
  ),
  backgroundColor: Colors.white,
  elevation: 8,
)
```

### Scrollable Modal (Large Content)

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,  // Allows full screen height
  builder: (_) {
    return SingleChildScrollView(  // Make content scrollable
      child: TransactionForm(onSubmit: _addTransaction),
    );
  },
)
```

### Modal with Barrier (Background) Customization

```dart
showModalBottomSheet(
  context: context,
  builder: (_) => TransactionForm(onSubmit: _addTransaction),
  barrierColor: Colors.black.withOpacity(0.5),  // Darker overlay
)
```

### Modal with Custom Animation

```dart
showModalBottomSheet(
  context: context,
  builder: (_) => TransactionForm(onSubmit: _addTransaction),
  transitionAnimationController: AnimationController(
    duration: Duration(milliseconds: 500),
    vsync: this,
  ),
)
```

---

## Dialog vs Bottom Sheet vs Overlay

### Dialog

```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('No')),
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Yes')),
    ],
  ),
);
```

**Use for**:

- Confirmations
- Alerts
- Simple choices

**Position**: Center of screen

### Bottom Sheet (Current Project)

```dart
showModalBottomSheet(
  context: context,
  builder: (_) => ComplexForm(),
);
```

**Use for**:

- Complex forms
- Lists of actions
- Detailed input

**Position**: Slides from bottom

### Overlay

```dart
Overlay.of(context).insert(OverlayEntry(
  builder: (_) => Toast(),
));
```

**Use for**:

- Floating notifications
- Tooltips
- Temporary UI

**Position**: Flexible (usually top/bottom edges)

---

## Error Handling in Modals

### Try-Catch Pattern

```dart
void _submitForm() {
  try {
    final title = titleController.text;
    final value = double.tryParse(valueController.text);

    if (title.isEmpty) throw 'Title required';
    if (value == null || value <= 0) throw 'Valid value required';

    widget.onSubmit(title, value);
    Navigator.of(context).pop();
  } catch (e) {
    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

### Validation Messages

```dart
class TransactionForm extends StatefulWidget {
  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  String? _titleError;
  String? _valueError;

  void _submitForm() {
    setState(() {
      _titleError = titleController.text.isEmpty ? 'Required' : null;
      _valueError = double.tryParse(valueController.text) == null
        ? 'Invalid number'
        : null;
    });

    if (_titleError == null && _valueError == null) {
      widget.onSubmit(titleController.text,
        double.parse(valueController.text));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            errorText: _titleError,
          ),
        ),
        // ... more fields
      ],
    );
  }
}
```

---

## Best Practices

✅ **Always close modals**: Don't leave modals open  
✅ **Validate before closing**: Ensure valid data  
✅ **Provide feedback**: Show success/error messages  
✅ **Allow escape**: Enable isDismissible and enableDrag  
✅ **Clear data**: Clear controllers when closed  
✅ **Responsive**: Test on different screen sizes  
✅ **Accessibility**: Ensure keyboard navigation works  
✅ **Performance**: Don't pass large objects into modals unnecessarily

---

## Common Issues & Solutions

### Issue: Modal doesn't close

```dart
// ❌ Wrong: Context is from wrong widget
showModalBottomSheet(
  context: myWidget.context,  // Wrong context
  builder: (_) => Form(),
);

// ✅ Correct: Use actual context parameter
void _openForm(BuildContext context) {
  showModalBottomSheet(
    context: context,  // Correct context
    builder: (_) => Form(),
  );
}
```

### Issue: Keyboard overlaps form

```dart
// ✅ Solution: Use isScrollControlled
showModalBottomSheet(
  context: context,
  isScrollControlled: true,  // Allows keyboard to push modal up
  builder: (_) => SingleChildScrollView(
    child: TransactionForm(onSubmit: _addTransaction),
  ),
)
```

### Issue: State not updating after modal closes

```dart
// ✅ Solution: Use setState in parent
void _addTransaction(String title, double value) {
  setState(() {  // Rebuild parent
    _transactions.add(Transaction(...));
  });
  Navigator.of(context).pop();
}
```

---

## Future Enhancements

### Modal with Progress

```dart
bool _isLoading = false;

Future<void> _submitForm() async {
  setState(() => _isLoading = true);

  try {
    await saveTransaction();
    Navigator.of(context).pop();
  } catch (e) {
    // Show error
  } finally {
    setState(() => _isLoading = false);
  }
}
```

### Multiple Steps Modal

```dart
int _step = 0;

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      if (_step == 0) StepOne(),
      if (_step == 1) StepTwo(),
      if (_step == 2) StepThree(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_step > 0)
            ElevatedButton(
              onPressed: () => setState(() => _step--),
              child: Text('Back'),
            ),
          if (_step < 2)
            ElevatedButton(
              onPressed: () => setState(() => _step++),
              child: Text('Next'),
            ),
          if (_step == 2)
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
        ],
      ),
    ],
  );
}
```

---

For more details, see:

- [Widgets Guide](./Widgets.md) - Widget lifecycle
- [Components Guide](./Components.md) - TransactionForm details
- [Architecture Guide](./Architecture.md) - Data flow patterns
