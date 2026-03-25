# Project Architecture

This project follows a **Feature-First Clean Architecture** pattern. The codebase is organized primarily by independent features, and secondarily by architectural layers within those features. This ensures maximum decoupling, scalability, and allows distinct domains to be completely self-contained.

## Directory Structure
```text
lib/
 ├ core/
 │   ├ theme/
 │   ├ router/
 │   ├ network/
 │   ├ constants/
 │   └ utils/
 │
 ├ shared/
 │   ├ widgets/
 │   ├ services/
 │   └ providers/
 │
 ├ features/
 │   ├ auth/
 │   │   ├ data/
 │   │   │   ├ models/
 │   │   │   ├ datasource/
 │   │   │   └ repositories/
 │   │   ├ domain/
 │   │   │   ├ entities/
 │   │   │   ├ repositories/
 │   │   │   └ usecases/
 │   │   ├ presentation/
 │   │   └ providers/
 │   │
 │   ├ categories/
 │   │   ├ data/
 │   │   ├ domain/
 │   │   ├ presentation/
 │   │   └ providers/
 │   │
 │   └ ... (other features)
 │
 ├ app.dart
 └ main.dart
```

---

## 1. Layers Overview

### 1.1 Features Layer (`lib/features/`)
This is the core of the application logic. Every distinct functionality (like `auth`, `categories`, `transactions`) is completely isolated into its own feature folder. Inside each feature, you will find a localized version of Clean Architecture:

#### -> `domain/` (The Core logic for the feature)
Completely independent of Flutter, Riverpod, or any external libraries.
- **Entities**: Core business objects (e.g., `Category`).
- **Repositories**: Abstract definitions (interfaces) of data operations required by this feature.
- **Usecases**: Reusable classes that orchestrate one focused operation at a time (e.g., `CreateCategoryUseCase`).

#### -> `data/` (The Implementations)
Concrete implementations of the domain's interfaces. Manages external APIs, DBs, and hardware.
- **Models**: Data transfer objects (e.g., Freezed generated classes for API responses). Include mappers to turn Models into Entities.
- **Datasources**: Direct communication with external boundaries (e.g., Dio clients, Secure Storage).
- **Repositories**: Concrete class `*RepositoryImpl` conforming to the interfaces defined in the `domain` layer.

#### -> `presentation/` (The UI Elements)
Contains purely visual interface components for the feature.
- **pages**: Main routing endpoints (screens).
- **widgets**: Specific UI components scoped only to this feature.

#### -> `providers/` (State Management)
Powered by Riverpod (`@riverpod`). Acts as the glue layer, providing dependency-injected UseCases and Datasources to the Presentation Layer via ViewModels / Notifiers.

### 1.2 Shared Layer (`lib/shared/`)
Contains common elements used across multiple features to explicitly prevent code duplication.
- **Widgets**: Reusable UI components (e.g., generic custom buttons, form fields, cards).
- **Services**: Shared internal integrators.
- **Providers**: Global state that isn't functionally bound to a single feature.

### 1.3 Core Layer (`lib/core/`)
Foundational app configurations and bootstrapping boilerplate. Network configurations (`DioClient`, `TokenStorage`), Theme definitions, Router constants, and Utils.

---

## 2. Architecture Rules

- **Feature Isolation**: Code inside `features/A/` should NEVER import internal code from `features/B/data` or `features/B/presentation`. If domains need to communicate, use global riverpod providers or extract common logic into `shared/`.
- **Dependency Inversion**: Inside any feature, the `domain` folder must NOT import from `data`, `presentation`, or `providers`.
- **Data Abstraction**: The `presentation` and `providers` interact with the DB/API strictly through `domain/usecases`. UI files should NOT import HTTP clients or DataSources directly.

---

## 3. Dart/Flutter Conventions

- Use `const` constructors for immutable widgets.
- Leverage Freezed for immutable state classes and unions.
- Use trailing commas for better formatting and diffs.
- Keep lines no longer than 100 characters.
- Extract complex `Widget build(...)` implementations into smaller localized stateless widgets rather than creating dozens of `_buildHeader()` private functions.

---

## 4. State Management (Riverpod)

- Use `@riverpod` annotation for generating providers (Riverpod 2.0+).
- Prefer `AsyncNotifier` and `Notifier` architectures over legacy Providers.
- **Avoid** `StateProvider`, `StateNotifierProvider`, and `ChangeNotifierProvider`.
- Use `ref.invalidate()` for manually triggering provider updates.
- Providers should be declared globally and kept immutable.
- Always use `ConsumerWidget` or `ConsumerStatefulWidget` to build reactive UIs.

---

## 5. UI and Layout Optimizations

- Prefer `LayoutBuilder` / `ConstrainedBox` for major pages to ensure they scale across wide screens (desktop/web/tablet). Breakpoints typically sit around `maxWidth < 800`.
- Use themes for consistent styling. Instead of hardcoding `Colors.blue`, use `Theme.of(context).colorScheme.primary`.
- Rely heavily on the TextThemes (`Theme.of(context).textTheme.titleLarge`).

---

## 6. Code Generation
- Utilize `build_runner` for generating Freezed models, Riverpod Providers, and JSON serialization.
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after modifying annotated classes.

---

## 7. Testing
- Feature `usecases` and `repositories` should be comprehensively covered by unit tests in `test/unit/`.
- Feature UI pages should have basic rendering flow widget tests in `test/widget/`.
- Use `mocktail` to inject mocked Network interceptors or mocked repositories during tests.

---

## 8. New Feature Checklist

When creating a new feature (e.g., `transactions`), follow this Feature-First progression:

### Step 1 — Scaffold Feature Folder
- [ ] Create `lib/features/<feature_name>/`
- [ ] Create `data/`, `domain/`, `presentation/`, and `providers/` subdirectories.

### Step 2 — Domain Layer
- [ ] Create the **Entity** pure classes in `domain/entities/`.
- [ ] Define the **abstract Repository interface** in `domain/repositories/`.
- [ ] Create focused pieces of logic via **Use Cases** in `domain/usecases/`.

### Step 3 — Data Layer
- [ ] Create **Models** with Freezed + `.fromJson` in `data/models/`. Add `toDomain()` maps.
- [ ] Create the **Datasource** classes in `data/datasource/` to hit the actual API/DB endpoints.
- [ ] Implement the **concrete Repository** (`*RepositoryImpl`) in `data/repositories/`.

### Step 4 — Providers (Riverpod)
- [ ] Create Riverpod providers in `providers/` injecting the datasources, repositories, and usecases.
- [ ] Create the Notifiers mapped to the View logic.

### Step 5 — Presentation (UI)
- [ ] Build the screens in `presentation/pages/`.
- [ ] Extract logical segments into `presentation/widgets/`.

### Step 6 — Routing & Codegen
- [ ] Register the new screen routes in `lib/core/router/app_router.dart`.
- [ ] Run `build_runner` to generate any missing `.g.dart` or `.freezed.dart` files.

### Step 7 — Verification
- [ ] Run `flutter analyze` completely cleanly.
- [ ] Run `flutter test` completely cleanly.

---

## 9. Dates and Timezones

- **Backend (PHP/Laravel)**: Always use `UTC` for dates and times.
  - Ensure `docker/php.ini` has `date.timezone = UTC`.
  - Database records must store timestamps in UTC.
  - The API MUST always return and expect dates in UTC (ISO-8601 format).
- **Frontend (Flutter)**:
  - Parse received UTC strings from the API.
  - ONLY convert to the user's Local Timezone when displaying dates on the UI.
- **Tokens (Sanctum)**: Let Laravel handle token expiration natively via config values (`SANCTUM_ACCESS_TOKEN_TTL_MINUTES` and `SANCTUM_REFRESH_TOKEN_TTL_DAYS`). Do not manually verify tokens on the PHP side. If looking to prevent unnecessary network requests, the frontend can locally check expiration by comparing the token's UTC expiration date against the device's current UTC time.
