# Copilot Instructions for MDC-100 Series Flutter App

## Project Overview
- This is a Flutter app based on the MDC-100 (Material Design Components) codelab series.
- The codebase is organized for learning and demonstration of Material Design patterns in Flutter.

## Architecture & Structure
- Main entry: [`lib/main.dart`](../lib/main.dart)
- App setup and navigation: [`lib/app.dart`](../lib/app.dart)
- Feature screens: [`lib/home.dart`, `lib/login.dart`, `lib/backdrop.dart`]
- Data models and repository: [`lib/model/`]
- UI components and custom widgets: [`lib/supplemental/`]
- Theming/colors: [`lib/colors.dart`]

## Key Patterns & Conventions
- Uses the [Provider](https://pub.dev/packages/provider) pattern for state management (if present in `pubspec.yaml`).
- Product data is loaded via `ProductsRepository` in [`lib/model/products_repository.dart`](../lib/model/products_repository.dart).
- Custom widgets (e.g., `AsymmetricView`, `ProductCard`) are in [`lib/supplemental/`].
- Navigation is handled via named routes in `app.dart`.
- Follows Material Design guidelines for UI structure and theming.

## Developer Workflows
- **Build/Run:** Use `flutter run` for development. For web, use `flutter run -d chrome`.
- **Hot reload:** Supported via standard Flutter workflow.
- **Assets:** Images and fonts are in `assets/` and `fonts/`.
- **Platform support:** Android, iOS, web, Windows, Linux, macOS (see respective folders).

## Project-Specific Notes
- The codebase is structured for clarity and learning, not for production.
- Avoid introducing external dependencies unless required for Material Design or Flutter best practices.
- Keep UI logic in widgets; business/data logic in model/repository files.
- Use the existing folder structure for new features or screens.

## References
- [Flutter documentation](https://flutter.dev/docs)
- [Material Design codelabs](https://codelabs.developers.google.com/codelabs/mdc-101-flutter)

---
_If updating this file, preserve actionable, project-specific guidance. Do not add generic advice._
