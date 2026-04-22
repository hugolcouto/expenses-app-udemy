# Themes & Styling Guide

## What is a Theme in Flutter?

A **Theme** is a comprehensive collection of styling rules applied to your entire application. It defines:

- Colors (primary, secondary, background)
- Typography (fonts, sizes, weights)
- Component styles (buttons, text fields, app bars)
- Spacing and sizing

Instead of styling each widget individually, Flutter applies theme styles globally, ensuring consistency across the app.

---

## Theme Implementation

### File Location

`lib/main.dart` - `App` widget class

### Theme Configuration

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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.red,
          titleTextStyle: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 25,
            fontWeight: FontWeight(700),
            color: Theme.of(context).primaryColor,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.teal,
          secondary: Colors.red,
        ),
      ),
    );
  }
}
```

---

## Core Theme Properties

### 1. **Material Design Version**

```dart
useMaterial3: true
```

**What it does**:

- Enables Material Design 3 (latest design system)
- Modern colors, spacing, and component styles
- Better visual consistency

**Material Design 3 Features**:

- Dynamic color theming
- Updated button styles
- Enhanced visual hierarchy
- Improved typography scales

### 2. **Global Font Family**

```dart
fontFamily: "Quicksand"
```

**Effect**:

- All text widgets use Quicksand font by default
- Can be overridden per widget

**Available Fonts**:

- Quicksand (primary, configured in pubspec.yaml)
- Domine (available but not set as default)

**Override Example**:

```dart
Text(
  "Custom Font",
  style: TextStyle(fontFamily: "Domine"),
)
```

---

## AppBar Theme

### Configuration

```dart
appBarTheme: AppBarTheme(
  backgroundColor: Colors.teal,
  foregroundColor: Colors.red,
  titleTextStyle: TextStyle(
    fontFamily: "Quicksand",
    fontSize: 25,
    fontWeight: FontWeight(700),
    color: Theme.of(context).primaryColor,
  ),
)
```

### Properties Explained

| Property          | Value  | Purpose                 |
| ----------------- | ------ | ----------------------- |
| `backgroundColor` | Teal   | AppBar background color |
| `foregroundColor` | Red    | Action button colors    |
| `titleTextStyle`  | Custom | Title text appearance   |

### Title Text Style

```dart
TextStyle(
  fontFamily: "Quicksand",     // Font family
  fontSize: 25,                 // Size in logical pixels
  fontWeight: FontWeight(700),  // Weight (700 = bold)
  color: Theme.of(context).primaryColor,  // Teal color
)
```

**Result**: AppBar title is large (25px), bold, teal-colored

### AppBar in Use

```dart
AppBar(
  title: Text("Despesas Pessoais", style: TextStyle(color: Colors.white)),
  backgroundColor: Theme.of(context).primaryColor,
  actions: [
    IconButton(
      onPressed: () => _openTransactionFormModal(context),
      icon: Icon(Icons.add),
      color: Colors.white,
    ),
  ],
)
```

**Note**: The AppBar styling can use `AppBarTheme` OR be customized directly (current implementation uses both).

---

## Color Scheme (Material Design 3)

### Configuration

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.red,
  primary: Colors.teal,
  secondary: Colors.red,
)
```

### Understanding ColorScheme

The `ColorScheme` defines a complete color palette:

```dart
ColorScheme.fromSeed(
  seedColor: Colors.red,  // Base color for MD3 algorithms
  primary: Colors.teal,    // Main brand color
  secondary: Colors.red,   // Accent color
)
```

**Generated Colors** (from seedColor):

- Primary (teal) - Main UI elements
- Secondary (red) - Accent elements
- Tertiary - Generated from seed
- Surface - Background surfaces
- Background - Screen background
- Error - Error states

### Accessing Colors

```dart
// In any widget with context
Theme.of(context).primaryColor           // Teal
Theme.of(context).colorScheme.secondary  // Red
Theme.of(context).colorScheme.surface    // Generated light color
Theme.of(context).colorScheme.error      // Generated error color
```

### Color Usage in Project

```dart
// Primary color (teal)
Graph() {
  Card(color: Theme.of(context).primaryColor)  // Teal background
}

// Primary color (teal)
TransactionList() {
  Text(
    style: TextStyle(
      color: Theme.of(context).primaryColor,  // Teal text
    ),
  )
}

// Custom colors
TransactionList() {
  Card(color: Colors.grey.shade200)  // Direct color (not from theme)
}
```

---

## Color Palette Reference

### Defined Colors in Project

| Color      | Hex Value              | Usage                       |
| ---------- | ---------------------- | --------------------------- |
| Teal       | `#008080`              | Primary, AppBar background  |
| Red        | `#FF0000`              | Secondary, accent           |
| White      | `#FFFFFF`              | Text on colored backgrounds |
| Light Gray | `Colors.grey.shade200` | Card backgrounds            |
| Dark Gray  | `Colors.grey.shade800` | Text color                  |

### Color Shades

```dart
Colors.grey.shade100    // Very light gray
Colors.grey.shade200    // Light gray (used for cards)
Colors.grey.shade600    // Medium gray (date text)
Colors.grey.shade800    // Dark gray (title text)
```

---

## Typography System

### Font Hierarchy

| Element      | Font      | Size    | Weight     | Color       | Usage            |
| ------------ | --------- | ------- | ---------- | ----------- | ---------------- |
| AppBar Title | Quicksand | 25px    | Bold (700) | Teal        | Page headers     |
| Card Title   | Quicksand | 16px    | Bold       | Dark Gray   | Item titles      |
| Card Value   | Quicksand | 20px    | Bold       | Teal        | Currency amounts |
| Card Date    | Quicksand | 12px    | Regular    | Medium Gray | Date info        |
| Button Text  | Quicksand | Default | Regular    | White       | Interactive      |

### Text Style Examples

```dart
// Large title (AppBar)
TextStyle(
  fontFamily: "Quicksand",
  fontSize: 25,
  fontWeight: FontWeight(700),
  color: Colors.teal,
)

// Card title
TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.grey.shade800,
)

// Small text (date)
TextStyle(
  fontSize: 12,
  color: Colors.grey.shade600,
)
```

---

## Component Styling

### Card Components

```dart
Card(
  elevation: 3,              // Shadow depth
  color: Colors.grey.shade200,  // Background color
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  child: // content
)
```

**Styling**:

- Elevation: Depth and shadow
- Color: Background
- Shape: Border radius (rounded corners)
- Padding: Inner spacing

### TextField Components

```dart
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,  // Teal when focused
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    labelText: "Label",
  ),
)
```

**States**:

- Default: Outlined border, rounded (20px radius)
- Focused: Teal border (2px width), rounded

### Button Components

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor,  // Teal
  ),
  onPressed: () {},
  child: Text("Button", style: TextStyle(color: Colors.white)),
)

FloatingActionButton(
  backgroundColor: Theme.of(context).primaryColor,  // Teal
  child: Icon(Icons.add, color: Colors.white),
)
```

**Styling**:

- Background: Primary color (teal)
- Icon/Text: White color for contrast

---

## Design Tokens

A **Design Token** is a named value for a design decision (color, size, spacing).

### Current Design Tokens

```dart
// Colors
primary = Colors.teal
secondary = Colors.red
surface = Colors.grey.shade200
onSurface = Colors.grey.shade800
onSurfaceVariant = Colors.grey.shade600

// Typography
fontFamily = "Quicksand"
titleLarge = TextStyle(fontSize: 25, fontWeight: 700)
bodyLarge = TextStyle(fontSize: 16)
labelSmall = TextStyle(fontSize: 12)

// Spacing
padding = 8.0, 10.0
borderRadius = 20, 10

// Elevation
cardElevation = 3, 5
```

### Using Tokens Consistently

```dart
// Good: Using theme
Text(
  "Amount",
  style: TextStyle(color: Theme.of(context).primaryColor),
)

// Less ideal: Hard-coding colors
Text(
  "Amount",
  style: TextStyle(color: Colors.teal),
)
```

---

## Extending the Theme

### Creating Theme Constants File

**Future Implementation** (`lib/config/app_theme.dart`):

```dart
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Quicksand",
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.red,
      primary: Colors.teal,
      secondary: Colors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      elevation: 0,
    ),
    // ... more theme properties
  );

  // Dark theme (future)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // ... dark theme colors
  );
}
```

### Using Custom Theme

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpensesApp(),
      theme: AppTheme.lightTheme,
    );
  }
}
```

---

## Dark Mode Support

### Current State

The app only supports light mode.

### Future Enhancement

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpensesApp(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,  // Follow system preference
    );
  }
}

// Define dark colors
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: Colors.red,
        primary: Colors.cyan,  // Lighter teal for dark
      ),
    );
  }
}
```

---

## Responsive Styling

### Using MediaQuery

```dart
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.all(
      screenWidth > 600 ? 24.0 : 16.0,  // Larger screens, larger padding
    ),
    child: // content
  );
}
```

### Responsive Text Sizes

```dart
TextStyle(
  fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 16,
)
```

---

## Accessibility Considerations

### Color Contrast

```dart
// Good contrast
Color(0xFF008080)  // Teal on white = good contrast
Color(0xFFFFFFFF)  // White on teal = good contrast

// Poor contrast (avoid)
Color(0xFFFFFF00)  // Yellow on white = bad contrast
```

### Font Sizes

```dart
// Minimum recommended sizes
labelSmall = 12,  // Body text
bodyMedium = 14,  // Default body
titleMedium = 16, // Headings
displaySmall = 24, // Large titles
```

### Using High Contrast Mode

```dart
Widget build(BuildContext context) {
  final isHighContrast =
    MediaQuery.of(context).highContrast;

  return Text(
    "Content",
    style: TextStyle(
      color: isHighContrast ? Colors.black : Colors.grey.shade800,
    ),
  );
}
```

---

## Material Design 3 Best Practices

✅ **Use ColorScheme** - Let MD3 generate harmonious colors  
✅ **Typography Scale** - Use predefined text styles  
✅ **Spacing System** - Consistent padding and margins  
✅ **Elevation** - Use elevation for depth (0, 1, 3, 6, 12)  
✅ **Color Contrast** - Ensure WCAG AA compliance  
✅ **Consistency** - Reuse theme values everywhere

---

## Theme Customization Checklist

- [ ] Define color scheme (primary, secondary, tertiary)
- [ ] Select and configure fonts
- [ ] Set typography scales
- [ ] Define component styles
- [ ] Add spacing/padding system
- [ ] Configure dark mode (optional)
- [ ] Test accessibility
- [ ] Document design tokens
- [ ] Use theme values throughout app

---

For more details, see:

- [Architecture Guide](./Architecture.md) - Theme in the system
- [Widgets Guide](./Widgets.md) - How widgets use themes
- [Components Guide](./Components.md) - Component styling examples
