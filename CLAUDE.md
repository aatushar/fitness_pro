# Fitness Pro (fitness_pro)

A Flutter app for smart gym management — members, trainers, payments and attendance in one place. Targets Android, iOS and web, so every screen must work on phones, tablets and desktop/web browser windows, portrait and landscape.

The user communicates in Bengali/Banglish. Reply in Bengali unless they write in English.

## Commands

```sh
flutter pub get
flutter analyze                 # must report "No issues found!"
flutter test                    # all tests must pass
flutter run -d chrome           # quick responsive check: resize the window
dart run build_runner build --delete-conflicting-outputs   # after editing a freezed/json model
```

Before calling any task done, run `flutter analyze` and `flutter test` and report the real result.

## Architecture: layer-first

```
lib/
├── main.dart                   # calls setupDependencies(), runs FitnessProApp
├── app.dart                    # FitnessProApp: MultiBlocProvider + MaterialApp.router
├── core/
│   ├── di/injection.dart        # the ONLY place that registers dependencies in `sl` (GetIt)
│   ├── network/api_endpoints.dart
│   ├── router/app_router.dart   # AppRouter: GoRouter instance + redirect logic
│   ├── storage/                 # token_storage.dart, global_token.dart
│   ├── theme/                   # AppColors (raw values), AppTheme (ThemeData)
│   ├── l10n/                    # app_strings.dart — add when building Bangla/English support
│   └── layout/                  # responsive.dart — add when building responsive helpers
├── data/
│   ├── datasources/             # <x>_remote_datasource.dart: abstract class + Impl, talks to Dio
│   ├── models/                  # <x>_model.dart, freezed + json_serializable
│   └── repositories/            # <x>_repository_impl.dart implements the domain interface
├── domain/
│   ├── entities/                # plain classes, no fromJson/toJson
│   ├── repositories/            # abstract interfaces
│   └── usecases/                # one class per action, exposes call()
└── presentation/
    ├── blocs/<feature>/         # <feature>_bloc.dart, _event.dart, _state.dart (or a Cubit)
    ├── pages/<feature>/         # <x>_page.dart, one per route
    └── splash/
```

Rules:
- Dependency direction: presentation → domain ← data. Domain imports nothing from `data/` or `presentation/`.
- JSON parsing lives only in `data/models/` (freezed `fromJson`/`toJson`). Entities in `domain/entities/` stay JSON-free.
- Wire every new datasource, repository, use case and bloc/cubit in `core/di/injection.dart` (`setupDependencies()`). Widgets never construct a service or repository directly — get it via `sl<T>()`, usually inside a `BlocProvider(create: (_) => sl<XBloc>())`.
- File names are `snake_case.dart`; the class name matches (`signin_page.dart` → `SigninPage`). Existing `AppTheme.dart` is the one exception — don't rename it in an unrelated change, but new files follow `snake_case.dart`.

## State management: flutter_bloc

- Use `flutter_bloc` (`Bloc`/`Cubit`). Don't add Provider, Riverpod, GetX or similar.
- One Bloc or Cubit per feature (`AuthBloc`, `ProfileBloc`, `ThemeCubit`). It calls use cases, never datasources or Dio directly.
- Provide blocs with `BlocProvider`/`MultiBlocProvider`; app-wide ones (`ThemeCubit`, `AuthBloc`) are provided once in `app.dart`, page-scoped ones (`ProfileBloc`) are provided at the route in `AppRouter`.
- Read state with `BlocBuilder`/`BlocConsumer`/`context.watch<T>()`; dispatch events with `context.read<T>().add(...)` or call a Cubit method directly.
- Model flow state with a state class/enum per feature (see `AuthState`, `ProfileState`). Catch repository/use case exceptions in the bloc and turn them into an error state with a user-facing message — never let a raw exception reach the UI.
- Small ephemeral UI state (a toggle local to one page) can stay in a `StatefulWidget` with `setState`; it doesn't need a Bloc.

## Routing: go_router

- `AppRouter` (`core/router/app_router.dart`) builds the single `GoRouter` instance, constructed with `AppRouter(sl<TokenStorage>())` in `app.dart`.
- Route paths should be named constants (e.g. an `AppRoutes` class) instead of raw strings repeated across `app_router.dart` and page navigation calls — introduce `AppRoutes` the next time routes are touched, so `'/signin'`, `'/dashboard'`, etc. have one source of truth.
- The `redirect` callback owns auth gating: no token → `/signin`; has token → role-based redirect away from the auth pages (`ROLE_MEMBER` → `/member-dashboard`, otherwise `/dashboard`). Keep new role-based destinations in that same function.
- Navigation: `context.go(path)` replaces the stack (after sign-in/out), `context.push(path)` opens a page the user can go back from, `context.pop()` goes back.
- A route that needs a page-scoped bloc wraps the page in `BlocProvider` right in the `GoRoute.builder`, as `/profile` does with `ProfileBloc`.

## Theme and dark mode

The app has light and dark themes, toggled by `ThemeCubit` (`presentation/blocs/theme/theme_cubit.dart`) and persisted with `shared_preferences` (`is_dark` key). `MaterialApp.router` in `app.dart` wires `theme: AppTheme.light`, `darkTheme: AppTheme.dark`, `themeMode: themeMode`. Every screen must look right in both.

- Raw hex values live only in `AppColors` (`core/theme/app_colors.dart`), grouped `dark*` / `light*` / shared brand colors (`purple`, `purpleDark`, `purpleGlow`). Never write `Color(0x...)` directly in a widget — add a named constant to `AppColors` first.
- Prefer reading colors through `Theme.of(context)` (`colorScheme`, `scaffoldBackgroundColor`) so a widget automatically follows light/dark, instead of branching on `AppColors.dark*` vs `AppColors.light*` by hand. Where a token isn't on `ThemeData` yet, branch once on `Theme.of(context).brightness == Brightness.dark` rather than scattering the check.
- Brand color `AppColors.purple` (and `purpleDark`, `purpleGlow`) is the same in both themes and may be used directly (primary buttons, focus accents, glows).
- Call `context.read<ThemeCubit>().toggleTheme()` from a Settings-style toggle; don't flip `ThemeMode` any other way.

## Language: Bangla and English

Not yet implemented — add it the same way as the theme toggle when the first user-facing text needs translating:

- Add `core/l10n/app_strings.dart` with every user-facing string carrying both translations, e.g. a small `AppStrings` class with a `_t('বাংলা', 'English')` helper and a static `of(context)`/`forLanguage(bangla: ...)` accessor. Don't hardcode new user-facing text (titles, buttons, snackbars, validators) directly in a widget once this exists — add it to `AppStrings` first.
- Add a `LocaleCubit` (same shape as `ThemeCubit`: persists the choice in `shared_preferences`, exposes it via `BlocBuilder`) so language can be toggled from Settings and `MaterialApp.locale`/`AppStrings.of(context)` follows it app-wide.
- Show language names in their own language ("বাংলা", "English"), never translated into the other language.
- Bangla rendering, once Bangla text exists:
  - Use the device's system font for Bangla; don't bundle a Bangla font without asking.
  - Type Bangla in logical order (consonant then vowel sign), and use the single Unicode codepoints for য়/ড়/ঢ়/ো/ৌ/ৎ, not decomposed pairs.
  - Keep Dart source UTF-8 and write Bangla as literal text, not `\u` escapes.
  - Bangla text coming from the server (not typed in the app) should be normalized (mojibake/invisible-character repair) in the model's `fromJson`, the same way `data/models/` already owns all JSON parsing.
  - Don't truncate Bangla titles with `maxLines` + ellipsis; let them wrap.
  - No `letterSpacing` on Bangla text — it pulls conjuncts apart.

## Responsive design (every screen, every device)

Not yet formalized — follow these rules as new/changed screens are built, and add a `core/layout/responsive.dart` helper (a `Breakpoints` class + a `ResponsiveCenter` widget that caps form/content width and centers it on wide screens) the first time a screen needs it:

- Any page whose content could be taller than the screen must scroll (`SingleChildScrollView` or `ListView`) — including bottom sheets and dialogs.
- Text inside a `Row` must be wrapped in `Expanded` or `Flexible`. Wrap labels in fixed-height buttons in `FittedBox(fit: BoxFit.scaleDown)`.
- Use `Text.rich`, never `RichText` directly — `RichText` ignores the user's system font-scale setting.
- Full-bleed headers use `SafeArea` so content clears notches/the status bar; don't hard-code status-bar padding.
- Size any `CustomPainter` drawing relative to `size` (e.g. scale by `size.shortestSide / 400`), not fixed pixel values.
- Test manually with `flutter run -d chrome` by resizing the window, and with the system font scale increased, before calling a screen done.

## Backend and networking

- Base URL and paths: `ApiEndpoints` (`core/network/api_endpoints.dart`).
- `Dio` is a singleton registered in `core/di/injection.dart`, shared by every datasource.
- Datasources catch `DioException` and translate it into a clear error; don't let a raw `DioException` reach a bloc or the UI.
- Tokens are stored through `TokenStorage` (`core/storage/token_storage.dart`); `AppRouter`'s `redirect` is the only place that should read `hasToken()`/`getRoles()` for navigation decisions.

## Testing

- `test/` mirrors `lib/`. Add tests for every new model's `fromJson`, use case, and bloc (event in → state out).
- Run `flutter analyze` and `flutter test` before calling any task complete, and report the actual pass/fail result.
