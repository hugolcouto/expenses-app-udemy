# Data Models & DTO Pattern

## What is a DTO?

**DTO** stands for **Data Transfer Object**. It's a design pattern used to transfer data between different parts of an application (typically between layers or across networks).

### Characteristics of DTOs

- 📦 **Simple data containers** - Hold data without behavior
- 📦 **Immutable** - Data shouldn't change after creation
- 📦 **Serializable** - Can be converted to/from JSON or other formats
- 📦 **No business logic** - Pure data representation
- 📦 **Lightweight** - Minimal overhead

## Transaction Model

### File Location

`lib/models/transaction.dart`

### Implementation

```dart
class Transaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
  });
}
```

### Field Breakdown

| Field   | Type     | Purpose                   | Example               |
| ------- | -------- | ------------------------- | --------------------- |
| `id`    | String   | Unique identifier         | "0.123456789"         |
| `title` | String   | Transaction description   | "Groceries"           |
| `value` | double   | Transaction amount        | 45.50                 |
| `date`  | DateTime | When transaction occurred | DateTime(2024, 4, 22) |

### Key Design Decisions

#### 1. **Immutability (final properties)**

```dart
final String id;
final String title;
final double value;
final DateTime date;
```

**Why immutable?**

- ✅ Thread-safe
- ✅ Predictable behavior
- ✅ Easier to debug
- ✅ Can be safely shared
- ✅ Supports value equality

#### 2. **Required Constructor Parameters**

```dart
Transaction({
  required this.id,
  required this.title,
  required this.value,
  required this.date,
})
```

**Why required?**

- ✅ Ensures complete objects
- ✅ No null values
- ✅ Forces explicit data provision
- ✅ Clear API contract

#### 3. **Named Parameters**

```dart
// Good: Clear what each value means
final transaction = Transaction(
  id: "123",
  title: "Groceries",
  value: 50.00,
  date: DateTime.now(),
);

// Bad: Hard to understand
final transaction = Transaction("123", "Groceries", 50.00, DateTime.now());
```

## Usage in the Application

### Creating Transactions

**Location**: `lib/main.dart` - `_addTransaction()` method

```dart
void _addTransaction(String title, double value) {
  final newTransaction = Transaction(
    id: Random().nextDouble().toString(),  // Generate unique ID
    title: title,                          // From form input
    value: value,                          // From form input
    date: DateTime.now(),                  // Current timestamp
  );

  setState(() {
    _transactions.add(newTransaction);
  });

  Navigator.of(context).pop();
}
```

**Data Flow**:

```
User fills form
        ↓
TransactionForm.onSubmit callback
        ↓
_addTransaction(title, value) called
        ↓
New Transaction object created
        ↓
Added to _transactions list
        ↓
setState() triggers rebuild
        ↓
TransactionList receives updated list
```

### Displaying Transactions

**Location**: `lib/components/transaction_list.dart`

```dart
ListView.builder(
  itemCount: transactions.length,
  itemBuilder: (context, index) {
    final transaction = transactions[index];
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display value
          Text(
            "R\$ ${transaction.value.toStringAsFixed(2).replaceAll('.', ',')}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Display title and date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(transaction.title),
              Text(DateFormat('d/MM/y').format(transaction.date)),
            ],
          ),
        ],
      ),
    );
  },
)
```

## DTO vs Model

### DTO (Data Transfer Object)

```dart
class Transaction {  // DTO
  final String id;
  final String title;
  final double value;
  final DateTime date;

  Transaction({...});
}
```

**Characteristics**:

- No methods
- Pure data container
- Used for transferring data
- Immutable

### Domain Model (with behavior)

```dart
class Transaction {  // Domain Model
  final String id;
  final String title;
  final double value;
  final DateTime date;

  Transaction({...});

  // Methods with business logic
  double getTaxAmount() => value * 0.15;
  bool isExpensive() => value > 1000;
  String getCategory() { /* logic */ }
}
```

**Current Project**: Uses pure DTO pattern without business logic in the model.

## Data Transformation

### Example: Converting to JSON

```dart
extension TransactionJSON on Transaction {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'date': date.toIso8601String(),
    };
  }

  static Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      value: json['value'] as double,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
```

### Example: Copying with Changes

```dart
extension TransactionCopy on Transaction {
  Transaction copyWith({
    String? id,
    String? title,
    double? value,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      date: date ?? this.date,
    );
  }
}

// Usage
final updatedTransaction = transaction.copyWith(title: 'New Title');
```

## Data Validation

### Validation at Creation

```dart
class Transaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
  }) {
    // Validation
    if (title.isEmpty) throw ArgumentError('Title cannot be empty');
    if (value <= 0) throw ArgumentError('Value must be positive');
    if (id.isEmpty) throw ArgumentError('ID cannot be empty');
  }
}
```

### Current Implementation

The project performs validation at form submission level in `TransactionForm._submitForm()`:

```dart
void _submitForm() {
  final title = titleController.text;
  final value = double.tryParse(valueController.text.replaceAll(',', '.'));

  // Validation before DTO creation
  if (title != "" && value != null) {
    widget.onSubmit(title, value);
  }
}
```

## Type Safety with DTO

### Benefits

```dart
// Type-safe access
Transaction transaction = getTransaction();
String title = transaction.title;  // Compiler knows it's String
double value = transaction.value;  // Compiler knows it's double

// No runtime type checking needed
// No null pointer exceptions for required fields
```

### Nullable Fields (if needed)

```dart
class TransactionWithCategory {
  final String id;
  final String title;
  final double value;
  final DateTime date;
  final String? category;  // Optional
  final String? notes;     // Optional

  TransactionWithCategory({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
    this.category,    // Not required
    this.notes,       // Not required
  });
}
```

## Comparison Operations

### Value Equality (if needed)

```dart
class Transaction {
  // ... fields ...

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          value == other.value &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ value.hashCode ^ date.hashCode;
}

// Usage
Transaction t1 = Transaction(...);
Transaction t2 = Transaction(...);
bool same = t1 == t2;  // Compares values, not reference
```

## Best Practices for DTOs

### ✅ DO

- **Keep DTOs simple** - Only data, no complex logic
- **Use final properties** - Ensure immutability
- **Use named parameters** - Clear and self-documenting
- **Validate at boundaries** - Check data at input points
- **Use appropriate types** - `DateTime` for dates, not String
- **Document fields** - Use comments for non-obvious fields

### ❌ DON'T

- **Add complex methods** - Keep business logic separate
- **Use nullable fields unnecessarily** - Use required when possible
- **Mutate after creation** - DTOs should be immutable
- **Store business logic** - Use separate service classes
- **Mix concerns** - Keep data transfer separate from processing

## Future Enhancements

### Equatable Package

```dart
import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double value;
  final DateTime date;

  const Transaction({...});

  @override
  List<Object> get props => [id, title, value, date];
}
```

### Freezed Package (for immutability)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String title,
    required double value,
    required DateTime date,
  }) = _Transaction;
}
```

## Summary

The `Transaction` DTO pattern used in this project:

- ✅ Simple, immutable data structure
- ✅ Required fields ensure complete objects
- ✅ Clear data representation
- ✅ Easy to test and understand
- ✅ Foundation for scaling to more complex models

---

For practical implementation, see:

- [Architecture Guide](./Architecture.md) - How DTOs fit in the system
- [Components Guide](./Components.md) - How DTOs are used in components
- [Widgets Guide](./Widgets.md) - Widget patterns that accept DTOs
