# Contributing to Personal Finances App

Thank you for contributing! To maintain consistency and quality across the codebase, please review the following guidelines before taking action.

## 1. Feature-First Architecture
This project relies strictly on a **Feature-First Clean Architecture**. 
Before adding a data model, use case, or UI screen, make sure you understand the separation of concerns isolated completely within a single `feature` folder. 
Please read our detailed architectural breakdown and **New Feature Checklist** in [ARCHITECTURE.md](./ARCHITECTURE.md) before scaffolding any new feature domains. 

## 2. Git & Commit Guidelines
We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Please format your commit messages appropriately:

- `feat:` for new features (e.g., `feat: Add recurring expenses screen`)
- `fix:` for bug fixes (e.g., `fix: Token parse crash during initial load`)
- `refactor:` for code changes that neither fix a bug nor add a feature (e.g., `refactor: Move auth to isolated feature structure`)
- `docs:` for documentation changes
- `test:` for adding or mutating unit and widget tests
- `chore:` for updating pubspec dependencies, running code generation, or CI/CD pipelines

## 3. Pull Requests
- Keep your changes focused. Do not mix refactoring changes with new feature additions in an unrelated branch.
- Make sure to verify that `flutter analyze` returns cleanly before pushing.
- Write unit tests for your domain repositories and use cases. Attempt to keep overall testing coverage high.

## 4. Code Generation
Whenever you modify `@riverpod` providers, `@freezed` models, or `@JsonSerializable` classes, remember to run the build runner locally:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 5. Local Setup
1. Clone the repository locally
2. Add your local `.env` configuration file
3. Run `flutter pub get`
4. Make sure your local Flutter/Dart SDK matches the versions listed in `pubspec.yaml`

Thanks for keeping our codebase clean and organized!
