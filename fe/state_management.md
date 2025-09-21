# State Management Guide

This project uses Riverpod and Get_it for dependency injection and state management.

## Get_it

Classes with dependency injection via get_it are typically located in the main.dart file before runApp is executed.

Examples include `AuthService` and `ApiService`.

### Accessing Services

```dart
final authService = AuthService.I;
authService.logIn();
...
// Access classes by appending .I
```

Among these, `AuthService` manages state (login status, token status, etc.), so it uses a separate state class called `AuthState` along with the Riverpod provider pattern.

## Riverpod

### Basic Structure

Uses `NotifierProvider` as the base pattern.

When there are multiple states, use `freezed` to define the state, then write the corresponding Notifier in the same file above it. The NotifierProvider should also be written in the same file and placed at the top.

For code simplicity, omit "Notifier" when naming Provider variables.

### Example Code Structure

```dart
// 1. Provider declaration
final influencerStateProvider =
    NotifierProvider<InfluencerNotifier, InfluencerState>(
  InfluencerNotifier.new,
);

// 2. Notifier class definition
class InfluencerNotifier extends Notifier<InfluencerState> {
  @override
  InfluencerState build() {
    return const InfluencerState();
  }

  Future<void> fetchInfluencers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // API usage documentation will be written separately
    final result = await ApiService.I.fetchInfluencers();

    if (result.isSuccess) {
      state = state.copyWith(
        influencers: result.data.map((e) => InfluencerState.fromJson(e)),
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load influencer list: $e',
      );
    }
  }
  // Business logic goes here
}

// 3. State class definition
@freezed
class InfluencerState with _$InfluencerState {
  const factory InfluencerState({
    @Default([]) List<Influencer> influencers,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _InfluencerState;
}
```

## UI Implementation

### Example Usage

```dart
class InfluencerListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final influencerState = ref.watch(influencerNotifierProvider);

    ref.listen(influencerNotifierProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Influencer List')),
      body: influencerState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: influencerState.influencers.length,
              itemBuilder: (context, index) {
                final influencer = influencerState.influencers[index];
                return ListTile(
                  title: Text(influencer.name),
                  subtitle: Text('Followers: ${influencer.followerCount}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(influencerNotifierProvider.notifier).fetchInfluencers();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

## Best Practices

### ref.watch vs ref.read
- `watch`: Rebuilds widget/Provider whenever the value changes
- `read`: For one-time reads. Use in event handlers and methods

### select Usage
To observe only part of a large object, use `select` to prevent unnecessary rebuilds:

```dart
// Watch only isLoading, not the entire state
final isLoading = ref.watch(
  influencerNotifierProvider.select((state) => state.isLoading)
);
```

### family vs autoDispose
- Use `family` for Providers that need parameters
- Use `autoDispose` to release memory when not in use
- Both can be used together: `Provider.autoDispose.family`

### ConsumerWidget vs Consumer
- Use `ConsumerWidget` when the entire widget depends on Riverpod
- Use `Consumer` when only part of the widget depends on it