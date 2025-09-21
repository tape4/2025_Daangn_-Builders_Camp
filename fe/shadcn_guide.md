# Flutter Shadcn UI Components Guide

Component usage examples for the [flutter-shadcn-ui](https://flutter-shadcn-ui.mariuti.com/) design system.

## Typography

Reference: [https://flutter-shadcn-ui.mariuti.com/typography/](https://flutter-shadcn-ui.mariuti.com/typography/)

### Text Styles
```dart
// Headings
Text(
  'H1 Large Heading',
  style: ShadTheme.of(context).textTheme.h1Large,
)

Text(
  'H1 Heading',
  style: ShadTheme.of(context).textTheme.h1,
)

Text(
  'H2 Heading',
  style: ShadTheme.of(context).textTheme.h2,
)

Text(
  'H3 Heading',
  style: ShadTheme.of(context).textTheme.h3,
)

Text(
  'H4 Heading',
  style: ShadTheme.of(context).textTheme.h4,
)

// Paragraph
Text(
  'This is a paragraph text with standard body styling.',
  style: ShadTheme.of(context).textTheme.p,
)

// Lead text - prominent introductory text
Text(
  'This is lead text, typically used for introductions.',
  style: ShadTheme.of(context).textTheme.lead,
)

// Large text
Text(
  'This is large text for emphasis.',
  style: ShadTheme.of(context).textTheme.large,
)

// Small text
Text(
  'This is small text for less prominent content.',
  style: ShadTheme.of(context).textTheme.small,
)

// Muted text - subdued styling
Text(
  'This is muted text for secondary information.',
  style: ShadTheme.of(context).textTheme.muted,
)

// Blockquote
Text(
  'This is a blockquote, used for quotations or highlighted text.',
  style: ShadTheme.of(context).textTheme.blockquote,
)
```

### Custom Font Configuration

#### Using Local Fonts
```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: UbuntuMono
      fonts:
        - asset: assets/fonts/UbuntuMono-Regular.ttf
        - asset: assets/fonts/UbuntuMono-Bold.ttf
          weight: 700
```

```dart
// In your theme configuration
ShadApp(
  theme: ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadZincColorScheme.light(),
    fontFamily: 'UbuntuMono',
  ),
  child: MyApp(),
)
```

#### Using Google Fonts
```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^latest_version
```

```dart
import 'package:google_fonts/google_fonts.dart';

ShadApp(
  theme: ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadZincColorScheme.light(),
    fontFamily: GoogleFonts.poppins().fontFamily,
  ),
  child: MyApp(),
)
```

### Typography Components Usage
```dart
// Inline code styling
RichText(
  text: TextSpan(
    style: ShadTheme.of(context).textTheme.p,
    children: [
      TextSpan(text: 'Use '),
      TextSpan(
        text: 'inline code',
        style: ShadTheme.of(context).textTheme.code,
      ),
      TextSpan(text: ' for code snippets.'),
    ],
  ),
)

// Lists (styled with standard Flutter widgets)
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('• First item', style: ShadTheme.of(context).textTheme.p),
    Text('• Second item', style: ShadTheme.of(context).textTheme.p),
    Text('• Third item', style: ShadTheme.of(context).textTheme.p),
  ],
)

// Numbered list
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('1. First step', style: ShadTheme.of(context).textTheme.p),
    Text('2. Second step', style: ShadTheme.of(context).textTheme.p),
    Text('3. Third step', style: ShadTheme.of(context).textTheme.p),
  ],
)
```

## Components

### Buttons
```dart
// Primary button
ShadButton(
  onPressed: () {},
  child: Text('Primary Button'),
)

// Secondary button
ShadButton.secondary(
  onPressed: () {},
  child: Text('Secondary Button'),
)

// Destructive button
ShadButton.destructive(
  onPressed: () {},
  child: Text('Delete'),
)

// Outline button
ShadButton.outline(
  onPressed: () {},
  child: Text('Outline Button'),
)
```

### Cards
```dart
ShadCard(
  title: Text('Card Title'),
  description: Text('Card description goes here'),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Card content'),
        ShadButton(
          onPressed: () {},
          child: Text('Action'),
        ),
      ],
    ),
  ),
)
```

### Alerts
```dart
ShadAlert(
  icon: Icon(Icons.info),
  title: Text('Alert Title'),
  description: Text('This is an alert message'),
)

// Destructive alert
ShadAlert.destructive(
  icon: Icon(Icons.warning),
  title: Text('Warning'),
  description: Text('This is a warning message'),
)
```

### Input Components
```dart
// Text input
ShadInput(
  placeholder: Text('Enter your email'),
  onChanged: (value) {},
)

// Checkbox
ShadCheckbox(
  value: isChecked,
  onChanged: (value) {
    setState(() => isChecked = value);
  },
)

// Switch
ShadSwitch(
  value: isEnabled,
  onChanged: (value) {
    setState(() => isEnabled = value);
  },
)
```

### Accordion
```dart
ShadAccordion(
  children: [
    ShadAccordionItem(
      value: 'item-1',
      title: Text('Section 1'),
      child: Text('Content for section 1'),
    ),
    ShadAccordionItem(
      value: 'item-2',
      title: Text('Section 2'),
      child: Text('Content for section 2'),
    ),
  ],
)
```

### Avatar
```dart
ShadAvatar(
  'https://example.com/avatar.jpg',
  placeholder: Text('JD'),
)

ShadAvatar.raw(
  child: Icon(Icons.person),
)
```

### Badge
```dart
ShadBadge(
  child: Text('Badge'),
)

ShadBadge.secondary(
  child: Text('Secondary'),
)

ShadBadge.destructive(
  child: Text('Error'),
)

ShadBadge.outline(
  child: Text('Outline'),
)
```

### Calendar
```dart
ShadCalendar(
  selected: selectedDate,
  onChanged: (date) {
    setState(() => selectedDate = date);
  },
)
```

### Context Menu
```dart
ShadContextMenu(
  children: [
    ShadContextMenuItem(
      child: Text('Copy'),
      onPressed: () {},
    ),
    ShadContextMenuItem(
      child: Text('Paste'),
      onPressed: () {},
    ),
  ],
  child: Container(
    padding: EdgeInsets.all(20),
    child: Text('Right click me'),
  ),
)
```

### Date Picker
```dart
ShadDatePicker(
  selected: selectedDate,
  onChanged: (date) {
    setState(() => selectedDate = date);
  },
)
```

### Dialog
```dart
ShadButton(
  onPressed: () {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text('Dialog Title'),
        description: Text('Dialog description'),
        actions: [
          ShadButton.outline(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ShadButton(
            child: Text('Confirm'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  },
  child: Text('Show Dialog'),
)
```

### Form
```dart
ShadForm(
  child: Column(
    children: [
      ShadInputFormField(
        id: 'email',
        label: Text('Email'),
        placeholder: Text('Enter your email'),
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Email required';
          return null;
        },
      ),
      ShadButton(
        child: Text('Submit'),
        onPressed: () {
          // Handle form submission
        },
      ),
    ],
  ),
)
```

### Icon Button
```dart
ShadButton.ghost(
  icon: Icon(Icons.star),
  onPressed: () {},
)

ShadButton.outline(
  icon: Icon(Icons.download),
  onPressed: () {},
)
```

### Input
```dart
ShadInput(
  placeholder: Text('Enter text'),
  onChanged: (value) {},
)

ShadInput(
  prefix: Icon(Icons.search),
  placeholder: Text('Search'),
)

ShadInput(
  suffix: ShadButton.ghost(
    icon: Icon(Icons.clear),
    onPressed: () {},
  ),
)
```

### Input OTP
```dart
ShadInputOTP(
  maxLength: 6,
  onChanged: (value) {},
)
```

### Menubar
```dart
ShadMenubar(
  children: [
    ShadMenubarMenu(
      trigger: ShadButton.ghost(
        child: Text('File'),
      ),
      children: [
        ShadMenubarItem(
          child: Text('New File'),
          onPressed: () {},
        ),
        ShadMenubarItem(
          child: Text('Open'),
          onPressed: () {},
        ),
      ],
    ),
  ],
)
```

### Popover
```dart
ShadPopover(
  popover: (context) => ShadCard(
    child: Text('Popover content'),
  ),
  child: ShadButton(
    child: Text('Open Popover'),
  ),
)
```

### Progress
```dart
ShadProgress(
  value: 0.6, // 60%
)
```

### Radio Group
```dart
ShadRadioGroup<String>(
  value: selectedValue,
  onChanged: (value) {
    setState(() => selectedValue = value);
  },
  children: [
    ShadRadio(
      value: 'option1',
      child: Text('Option 1'),
    ),
    ShadRadio(
      value: 'option2',
      child: Text('Option 2'),
    ),
  ],
)
```

### Resizable
```dart
ShadResizable(
  children: [
    ShadResizablePanel(
      defaultSize: 0.3,
      child: Container(color: Colors.red),
    ),
    ShadResizablePanel(
      defaultSize: 0.7,
      child: Container(color: Colors.blue),
    ),
  ],
)
```

### Select
```dart
ShadSelect<String>(
  placeholder: Text('Select option'),
  options: [
    ShadOption(value: 'option1', child: Text('Option 1')),
    ShadOption(value: 'option2', child: Text('Option 2')),
  ],
  selectedOptionBuilder: (context, value) => Text('Selected: $value'),
  onChanged: (value) {},
)
```

### Separator
```dart
ShadSeparator()

ShadSeparator.vertical()
```

### Sheet
```dart
ShadButton(
  onPressed: () {
    showShadSheet(
      context: context,
      builder: (context) => ShadSheet(
        title: Text('Sheet Title'),
        description: Text('Sheet description'),
        child: Column(
          children: [
            Text('Sheet content'),
            ShadButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  },
  child: Text('Open Sheet'),
)
```

### Slider
```dart
ShadSlider(
  value: sliderValue,
  onChanged: (value) {
    setState(() => sliderValue = value);
  },
  min: 0,
  max: 100,
)
```

### Sonner (Toast)
```dart
ShadButton(
  onPressed: () {
    ShadToaster.of(context).show(
      ShadToast(
        title: Text('Success'),
        description: Text('Task completed successfully'),
      ),
    );
  },
  child: Text('Show Toast'),
)
```

### Table
```dart
ShadTable(
  header: [
    Text('Name'),
    Text('Email'),
    Text('Status'),
  ],
  children: [
    ShadTableRow(
      cells: [
        Text('John Doe'),
        Text('john@example.com'),
        ShadBadge(child: Text('Active')),
      ],
    ),
    ShadTableRow(
      cells: [
        Text('Jane Smith'),
        Text('jane@example.com'),
        ShadBadge.secondary(child: Text('Pending')),
      ],
    ),
  ],
)
```

### Tabs
```dart
ShadTabs(
  defaultValue: 'tab1',
  children: [
    ShadTab(
      value: 'tab1',
      text: Text('Tab 1'),
      child: Text('Content 1'),
    ),
    ShadTab(
      value: 'tab2',
      text: Text('Tab 2'),
      child: Text('Content 2'),
    ),
  ],
)
```

### Textarea
```dart
ShadTextarea(
  placeholder: Text('Enter your message'),
  minLines: 3,
  maxLines: 6,
  onChanged: (value) {},
)
```

### Time Picker
```dart
ShadTimePicker(
  selected: selectedTime,
  onChanged: (time) {
    setState(() => selectedTime = time);
  },
)
```

### Toast
```dart
// Simple toast
ShadToast.simple(
  title: Text('Simple toast'),
)

// Success toast
ShadToast(
  title: Text('Success'),
  description: Text('Operation completed'),
  action: ShadButton.outline(
    size: ShadButtonSize.sm,
    child: Text('Undo'),
    onPressed: () {},
  ),
)

// Error toast
ShadToast.destructive(
  title: Text('Error'),
  description: Text('Something went wrong'),
)
```

### Tooltip
```dart
ShadTooltip(
  builder: (context) => Text('Tooltip content'),
  child: ShadButton(
    child: Text('Hover me'),
  ),
)
```