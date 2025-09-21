# Recommendations and Best Practices

## Don't Pass BuildContext to Business Logic

BuildContext should only be handled in the UI layer.


### Q: How to show dialogs then?
→ Receive response results from the logic layer and show dialogs based on those results in the UI layer.

### Q: Can I pass ref?
→ Preferably avoid it, but if necessary:
- `ref.watch` and `ref.select` should only be used in widgets
- Use `ref.read` for accessing from business logic

## Avoid Using print

Don't use `print` statements in production code.

- For debugging, use only during development and remove before release
- Use `debugPrint` or `log` instead

## Prevent Memory Leaks

When using the following objects in stateful widgets, you must dispose them properly:

- AnimationController
- TextEditingController
- ScrollController
- FocusNode
- StreamSubscription

### Proper Disposal Example

```dart
@override
void dispose() {
  // Dispose controllers
  _animationController.dispose();
  _textEditingController.dispose();
  _scrollController.dispose();
  _focusNode.dispose();

  // Cancel subscriptions
  _subscription.cancel();

  super.dispose();
}
```

Without proper disposal, memory leaks will occur.

## Avoid Deep Widget Trees

Don't create excessively deep widget trees.

### Bad Example
```dart
// Don't do this
return Container(
  child: Column(
    children: [
      Container(
        child: Row(
          children: [
            Container(
              child: Text('Deep widget tree'),
            ),
          ],
        ),
      ),
    ],
  ),
);
```

### Problems with Deep Trees
1. Severely reduced readability
2. Performance issues during rebuilds

### Good Example - Separate Widgets
```dart
// Main widget
return MainContainer(
  child: HeaderSection(),
);

// Separated widget
class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Separated widget'),
      ],
    );
  }
}
```

## Use Responsive Layouts

Device sizes vary greatly, so always build layouts relatively.

### Problems with Fixed Sizes from Figma Designs
- Overflow errors
- Broken layouts on small screens
- Wasted space on large screens

### Recommended Approaches
- Use `MediaQuery` to check device size
- Utilize `Expanded` and `Flexible` widgets
- Use `LayoutBuilder` for parent widget constraints
- Use `AspectRatio` to maintain ratios

### Good Example
```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth * 0.8, // 80% of screen width
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: HeaderWidget(),
            ),
            Expanded(
              flex: 3,
              child: ContentWidget(),
            ),
          ],
        ),
      );
    }
  );
}
```