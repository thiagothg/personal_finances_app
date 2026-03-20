# Project Architecture

This project follows a **Feature-Driven Clean Architecture** pattern. The codebase is organized by layers to separate concerns, improve testability, limit regressions, and keep the user interface decoupled from the business logic.

## Directory Structure
```text
lib/
 ├ core/
 │   ├ theme/
 │   ├ router/
 │   ├ constants/
 │   ├ utils/
 │
 ├ shared/
 │   ├ widgets/
 │   ├ services/
 │   └ providers/
 │
 ├ features/
 │   ├ dashboard/
 │   ├ transactions/
 │   ├ accounts/
 │   ├ people/
 │   ├ categories/
 │   ├ investments/
 │   ├ settings/
 │
 ├ data/
 │   ├ models/
 │   ├ dto/
 │   ├ repositories/
 │   └ datasource/
 │
 ├ domain/
 │   ├ entities/
 │   ├ repositories/
 │   └ usecases/
 │
 ├ app.dart
 └ main.dart
```

---

## 1. Layers Overview

### 1.1 Domain Layer (`lib/domain/`)
The absolute core of the application. It is completely independent of Flutter, Riverpod, or any external device-specific libraries.
- **Entities**: Core business objects (e.g., `User`, `Transaction`, `Account`).
- **Repositories**: Abstract definitions (interfaces) of data operations required by the Use Cases.
- **Usecases**: Specific pieces of business logic that orchestrate one focused operation at a time.

### 1.2 Data Layer (`lib/data/`)
The concrete implementation of the domain's abstract contracts. It manages external APIs, local databases, networks, and device sensors.
- **Models/DTOs**: Data transfer objects for APIs or database tables (e.g., Freezed and json_serializable classes). They often include from/to Domain Entity mappers.
- **Datasources**: Direct communication with external boundaries (e.g., Drift Database DAOs, Dio REST clients, SharedPreferences).
- **Repositories**: Concrete implementations of the interfaces defined in the Domain layer.

### 1.3 Features Layer (`lib/features/`)
The Presentation/UI layer organized distinctively by independent features.
- Contains the UI elements exclusively for robust feature sets (e.g., `dashboard`, `transactions`).
- Powered by Riverpod: Provider definitions, Notifiers, and pure declarative Widgets.

### 1.4 Shared Layer (`lib/shared/`)
Contains common elements used across multiple features to explicitly prevent code duplication.
- **Widgets**: Reusable UI components (e.g., generic custom buttons, form fields, cards).
- **Services**: Shared internal integrators or utilities.
- **Providers**: Global State or Configuration providers accessible across various domains.

### 1.5 Core Layer (`lib/core/`)
Foundational app configurations and bootstrapping boilerplate.
- **Theme**: Unified Colors, Typography, AppTheme mappings.
- **Router**: GoRouter configuration, path constants.
- **Constants**: Global strings, dimensions, environment variables.
- **Utils**: Broadly applicable helper functions and extensions.

---

## 2. Architecture Rules

- **Dependency Inversion**: The `domain` layer must NOT depend on any other architectural layer (e.g., no imports from `data` or `features`).
- **Data Abstraction**: The `features` layer communicates with data sources strictly through `domain/usecases` or `domain/repositories`. Do not instantiate `data/repositories` directly in the UI.
- **Feature Isolation**: Code inside `features/A/` should not import code from `features/B/`. Shared code must be moved to `shared/` or `domain/`.

---

## 3. Dart/Flutter Conventions

- Use `const` constructors for immutable widgets.
- Leverage Freezed for immutable state classes and unions.
- Use arrow syntax for simple functions and methods.
- Prefer expression bodies for one-line getters and setters.
- Use trailing commas for better formatting and diffs.
- Use `log` instead of `print` for debugging.
- Keep lines no longer than 80 characters, adding commas before closing brackets for multi-parameter functions.

---

## 4. Error Handling and Validation

- Implement error handling in views using `SelectableText.rich` instead of SnackBars.
- Display errors in `SelectableText.rich` with red color for visibility.
- Handle empty states within the displaying screen.
- Use `AsyncValue` for proper error handling and loading states.

---

## 5. State Management (Riverpod)

- Use `@riverpod` annotation for generating providers.
- Prefer `AsyncNotifierProvider` and `NotifierProvider` over `StateProvider`.
- **Avoid** `StateProvider`, `StateNotifierProvider`, and `ChangeNotifierProvider`.
- Use `ref.invalidate()` for manually triggering provider updates.
- Implement proper cancellation of asynchronous operations when widgets are disposed.
- Providers should be declared globally and kept immutable.
- Always use `ConsumerWidget` or `ConsumerStatefulWidget` to access providers. Avoid passing providers around as arguments to helper widgets.

---

## 6. Routing (GoRouter)

- Define routes statically in the `core/router/` module.
- Always use declarative navigation (`context.go()` or `context.push()`) over Navigator 1.0 imperative styles.
- Use GoRouter for navigation and deep linking.

---

## 7. UI and Styling

- Use Flutter's built-in widgets and create custom widgets.
- **Always** use `LayoutBuilder` / `ConstrainedBox` approach for top-level pages to ensure they are responsive for wide screens (desktop/web/tablet). Use `constraints.maxWidth < 800` to show the standard mobile layout, and a `Row` split-screen layout for wide screens.

- Use themes for consistent styling across the app.
- Use `Theme.of(context).textTheme.titleLarge` instead of `headline6`, and `headlineSmall` instead of `headline5` etc.
- Do not hardcode colors, padding, or text styles directly in widgets.
- Always use the `core/theme/` and standard Flutter `Theme.of(context)` to access colors and typography.
- Keep widgets small and modular. Extract reusable widgets into `shared/widgets/`.
- Create small, private widget classes instead of methods like `Widget _build...`.
- Implement `RefreshIndicator` for pull-to-refresh functionality.
- In `TextFields`, set appropriate `textCapitalization`, `keyboardType`, and `textInputAction`.
- Always include an `errorBuilder` when using `Image.network`.

---

## 8. Performance Optimization

- Use `const` widgets where possible to optimize rebuilds.
- Implement list view optimizations (e.g., `ListView.builder`).
- Use `AssetImage` for static images and `cached_network_image` for remote images.
- Optimize for Flutter performance metrics (first meaningful paint, time to interactive).
- Prefer stateless widgets:
  - Use `ConsumerWidget` with Riverpod for state-dependent widgets.
  - Use `HookConsumerWidget` when combining Riverpod and Flutter Hooks.

---

## 9. Data Models & API (Freezed & json_serializable)

- All Data Models and Entities should be immutable and generated using `freezed`.
- Use `json_serializable` in combination with Freezed for DTOs and Database communication Models.
- Always keep a clear mapping between Data Models/DTOs and Domain Entities.
- Include `createdAt`, `updatedAt`, and `isDeleted` fields in database tables.
- Use `@JsonSerializable(fieldRename: FieldRename.snake)` for models.
- Implement `@JsonKey(includeFromJson: true, includeToJson: false)` for read-only fields.
- Use `@JsonValue(int)` for enums that go to the database.

---

## 10. Code Generation

- Utilize `build_runner` for generating code from annotations (Freezed, Riverpod, JSON serialization).
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after modifying annotated classes.

---

## 11. Testing

- Every domain usecase and repository must have unit tests.
- UI features should have widget tests for main user flows.
- Use `mocktail` to mock dependencies (especially Repositories and Datasources).

---

## 12. Documentation

- Document complex logic and non-obvious code decisions.
- Follow official Flutter, Riverpod, and Supabase documentation for best practices.

---

## 13. Git

- **Always** use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages. Example: `feat: add start workout session endpoint`, `fix: workout plan validation`, `docs: update architecture rules`.
- **Never** make commit without explicit permission from the user. Always wait for the user to ask for a commit.

---

## 14. MCPs

- **Always** use the Context7 MCP to search for documentation and websites.
- **Always** use the Serena MCP for semantic code retrieval and editing tools.
- **Always** use the Flutter MCP for code generation and editing tools.

---

## 15. New Feature Checklist

When creating a new feature (e.g., `transactions`), follow every step below **in order**:

### Step 1 — Domain Layer
- [ ] Create the **Entity** in `lib/domain/entities/` (e.g., `transaction.dart`).
- [ ] Define the **abstract Repository interface** in `lib/domain/repositories/` (e.g., `transaction_repository.dart`).
- [ ] Create one or more **Use Cases** in `lib/domain/usecases/` (e.g., `create_transaction.dart`, `get_transactions.dart`).

### Step 2 — Data Layer
- [ ] Create the **Model/DTO** with Freezed + json_serializable in `lib/data/models/` (e.g., `transaction_model.dart`).
- [ ] Add mapper methods (`toDomain()`, `fromDomain()`) on the Model.
- [ ] Create the **Datasource** in `lib/data/datasource/` (e.g., `transaction_local_datasource.dart` for Drift, or `transaction_remote_datasource.dart` for Dio).
- [ ] Implement the **concrete Repository** in `lib/data/repositories/` (e.g., `transaction_repository_impl.dart`).

### Step 3 — Providers (Riverpod)
- [ ] Create **providers** inside the feature folder `lib/features/<feature>/providers/` using `@riverpod` annotation.
- [ ] Wire up the repository and use cases through dependency injection in the providers.

### Step 4 — Presentation (Feature UI)
- [ ] Create the feature folder under `lib/features/<feature>/`.
- [ ] Add **pages** in `lib/features/<feature>/presentation/pages/`.
- [ ] Add **widgets** (feature-specific) in `lib/features/<feature>/presentation/widgets/`.
- [ ] Use `ConsumerWidget` or `ConsumerStatefulWidget` — never plain `StatelessWidget/StatefulWidget` when state is needed.

### Step 5 — Routing
- [ ] Register the new route(s) in `lib/core/router/app_router.dart`.

### Step 6 — Code Generation
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`.

### Step 7 — Testing
- [ ] Write **unit tests** for each use case and the repository in `test/unit/`.
- [ ] Write **widget tests** for the main UI flow in `test/widget/`.

### Step 8 — Verify
- [ ] Run `flutter analyze` — zero errors.
- [ ] Run `flutter test` — all tests pass.
- [ ] Manual smoke test on a device/emulator.

---

### Example: Creating the `transactions` feature

Below is what the file tree looks like after completing the checklist for a `transactions` feature:

```text
lib/
 ├ domain/
 │   ├ entities/
 │   │   └ transaction.dart              ← Entity (immutable, pure Dart)
 │   ├ repositories/
 │   │   └ transaction_repository.dart    ← Abstract interface
 │   └ usecases/
 │       ├ create_transaction.dart        ← Single-responsibility use case
 │       └ get_transactions.dart
 │
 ├ data/
 │   ├ models/
 │   │   └ transaction_model.dart         ← Freezed + json_serializable DTO
 │   ├ datasource/
 │   │   └ transaction_local_datasource.dart  ← Drift DAO
 │   └ repositories/
 │       └ transaction_repository_impl.dart   ← Concrete implementation
 │
 ├ features/
 │   └ transactions/
 │       ├ providers/
 │       │   └ transaction_providers.dart     ← @riverpod providers
 │       └ presentation/
 │           ├ pages/
 │           │   ├ transactions_list_page.dart
 │           │   └ add_transaction_page.dart
 │           └ widgets/
 │               └ transaction_card.dart      ← Small, private widget
 │
 ├ core/
 │   └ router/
 │       └ app_router.dart               ← Add /transactions route here

test/
 ├ unit/
 │   ├ create_transaction_test.dart
 │   └ transaction_repository_test.dart
 └ widget/
     └ transactions_list_page_test.dart
```

#### Example: `lib/domain/entities/transaction.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String description,
    required double amount,
    required DateTime date,
    required String accountId,
    String? categoryId,
    @Default(false) bool isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Transaction;
}
```

#### Example: `lib/domain/repositories/transaction_repository.dart`
```dart
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAll();
  Future<Transaction?> getById(String id);
  Future<void> create(Transaction transaction);
  Future<void> update(Transaction transaction);
  Future<void> delete(String id);
}
```

#### Example: `lib/features/transactions/providers/transaction_providers.dart`
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/repositories/transaction_repository.dart';

part 'transaction_providers.g.dart';

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build() async {
    final repo = ref.watch(transactionRepositoryProvider);
    return repo.getAll();
  }

  Future<void> addTransaction(Transaction t) async {
    final repo = ref.read(transactionRepositoryProvider);
    await repo.create(t);
    ref.invalidateSelf();
  }
}
```
