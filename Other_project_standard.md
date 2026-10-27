# BREB HRMS (rms_app)

A Flutter app for the Bangladesh Rural Electrification Board (BREB) HR management system. It targets Android, iOS, web, Windows, macOS and Linux, so every screen must work on phones, tablets and desktop/web windows.

The user communicates in Bengali/Banglish. Reply in Bengali unless they write in English.

## Commands

```sh
flutter pub get
flutter analyze                 # must report "No issues found!"
flutter test                    # all tests must pass
flutter run -d chrome           # quick responsive check: resize the window
flutter run --dart-define=API_BASE_URL=http://host:port   # other backend
```

Before calling any task done, run `flutter analyze` and `flutter test` and report the real result.

## Architecture: feature-first Clean Architecture

```
lib/
├── main.dart                  # builds AppDependencies, provides them, runs MaterialApp.router
├── core/                      # shared by every feature; never imports a feature's pages/providers
│   ├── di/injector.dart       # the ONLY place that constructs and wires everything
│   ├── layout/responsive.dart # Breakpoints + ResponsiveCenter
│   ├── network/               # ApiEndpoints, ApiException, api_response helpers, AuthInterceptor
│   ├── router/app_router.dart # AppRoutes constants + createAppRouter()
│   ├── services/              # platform wrappers (e.g. BiometricAuthService)
│   ├── l10n/app_strings.dart  # every user-facing string, Bangla + English
│   ├── theme/                 # AppColors (raw values), AppPalette (per-theme), AppTheme
│   ├── widgets/               # widgets shared by several features (e.g. UserAvatar)
│   ├── session/  storage/  utils/
└── features/<feature>/
    ├── data/
    │   ├── datasources/       # <x>_remote_datasource.dart: abstract class + Impl, talks to Dio
    │   ├── models/            # <x>_model.dart extends the domain entity, owns fromJson
    │   └── repositories/      # <x>_repository_impl.dart implements the domain interface
    ├── domain/                # pure Dart: no Flutter, no Dio, no data/ or presentation/ imports
    │   ├── entities/          # plain immutable classes, NO fromJson/toJson
    │   ├── repositories/      # abstract interfaces
    │   ├── usecases/          # one class per action, exposes call()
    │   ├── services/          # pure domain helpers (e.g. route_permission.dart)
    │   └── errors/            # feature-specific exceptions
    └── presentation/
        ├── pages/             # <x>_page.dart, one per route
        ├── providers/         # <x>_provider.dart (ChangeNotifier)
        └── widgets/           # widgets used only by this feature
```

Rules:
- New feature: create `features/<name>/` with the same `data/domain/presentation` layout. Presentation-only features (like `splash`, `home`) may skip `data/` and `domain/`.
- Dependency direction: presentation → domain ← data. Domain imports nothing from the other two layers.
- JSON parsing lives only in `data/models/` (see `MenuNodeModel`, `UserModel`). Entities stay JSON-free.
- Every loose file goes into a named sub-folder; don't leave files directly in `domain/` or `data/`.
- Wire every new datasource, repository, use case and service in `core/di/injector.dart` and add it to `AppDependencies`. Widgets and providers never call `SomeService()` themselves; they receive dependencies through constructors or Provider.
- No mutable globals (the router used to be one and leaked state between tests).
- File names are `snake_case.dart`; the class name matches (`login_page.dart` → `LoginPage`). Private helper widgets live in the same file as `_PrivateWidget`.
- Use relative imports inside `lib/`, and `package:rms_app/...` imports in `test/`.

## State management: Provider

- Use `provider` with `ChangeNotifier`. Don't add Riverpod, Bloc, GetX or similar.
- One provider per feature (`AuthProvider`, `MenuProvider`). It calls use cases, never datasources or Dio directly.
- Register providers in the `MultiProvider` in `main.dart`. Plain services (not notifiers) use `Provider<T>.value(value: deps.x)`.
- In `build`, use `context.watch<T>()` or `Consumer<T>`. In callbacks and `initState`, use `context.read<T>()`.
- Expose state through private fields and getters, and call `notifyListeners()` after each change. Model flow states with an enum (see `AuthStatus`).
- Catch the domain exceptions (`AuthException`, `ApiException`) in the provider and turn them into a user-facing `errorMessage`. Never let a raw exception reach the UI.
- Keep small ephemeral UI state (a toggle local to one page) in a `StatefulWidget` with `setState`. That's fine; it doesn't need a provider.

## Routing: go_router

- Route paths are constants in `AppRoutes` (`core/router/app_router.dart`). Never hard-code path strings.
- Add new routes to `createAppRouter()`. The router instance is created in `buildAppDependencies()` and passed to `MaterialApp.router(routerConfig: deps.router)`.
- The app starts on `AppRoutes.login`; `AppRoutes.root` (`/`, e.g. the web site root) redirects there.
- Navigation: `context.go(AppRoutes.x)` replaces the stack (after login and logout), `context.push(AppRoutes.x)` opens a page the user can go back from (e.g. signup), and `context.pop()` goes back.
- Code without a `BuildContext` (network, session) navigates through an injected callback, as `SessionExpiredHandler(navigateToLogin: ...)` does. Don't import the router into `core/` services.
- Before opening a menu-gated screen, check `MenuProvider.isRouteAllowed(routeName)`.

## Colors and theme (light, dark, AMOLED)

The app has three themes, chosen in Settings: `AppTheme.light`, `AppTheme.dark` and `AppTheme.amoled`. Every screen must look right in all three.

- Raw hex values live only in `AppColors` (`core/theme/app_colors.dart`). Never write `Color(0x...)` in a widget; add a named constant to `AppColors` first.
- **Theme-dependent colors** (backgrounds, text, borders, errors, primary buttons, links): read them with `context.palette.<token>` (`core/theme/app_palette.dart`). Never use the `AppColors.light*` / `dark*` / `amoled*` groups in a widget.
- **Brand colors** are the same in every theme and may be used directly: `AppColors.navy*`, `teal`, `tealDark`, `gold`, `heroGradient`, `signInGradient`, `tileAccents`.
- `context.palette` can't go inside a `const` widget. Drop `const` on that widget only, and keep it on its constant children.
- Text on a `heroGradient` background is always `Colors.white` / `Colors.white70`, in every theme.

| `context.palette.` | Light | Dark | AMOLED | Use |
|---|---|---|---|---|
| `surface` | `#FFFFFF` | `#18213A` | `#0E0E10` | Cards, sheets, drawer, app bars |
| `background` | `#F4F6FB` | `#0D1427` | `#000000` | Scaffold background, input fill |
| `border` | `#E3E7F1` | `#2A3554` | `#26262B` | Input borders, dividers, drag handles |
| `textPrimary` | `#1A2340` | `#E8ECF5` | same as dark | Main text, labels |
| `textMuted` | `#8A93A6` | `#9AA4BA` | same as dark | Secondary text, idle icons |
| `primary` | `#14265A` navy | `#2F4F9E` | same as dark | Filled primary buttons |
| `link` | `#178A81` tealDark | `#2AC7B5` teal | same as dark | Text buttons, links, accent icons |
| `errorBg` / `errorText` / `errorBorder` | `#FCEBEA` / `#C0392B` / `#F3C8C4` | `#3A1E22` / `#FF8A80` / `#6B2E33` | same as dark | Error banners, validation, log out |

| Brand `AppColors.` | Hex | Use |
|---|---|---|
| `navyDark` / `navy` / `navyLight` | `#0E1B3D` / `#14265A` / `#1E3568` | Brand navy |
| `teal` / `tealDark` | `#2AC7B5` / `#178A81` | Accent, focus border, selected radio |
| `gold` | `#F2C744` | Electricity sparks, highlights (use sparingly) |
| `heroGradient` | navyDark → navy → navyLight | Page headers, splash, drawer header, home banner |
| `signInGradient` | navy → tealDark | Logo rings |
| `tileAccents` | teal, amber, blue, coral, violet, green | Home menu tile icons, cycled by position |

Visual conventions already used across the app (keep new screens consistent):
- Page header: `heroGradient`, top-left → bottom-right, with a `surface` card overlapping it upwards (`Transform.translate` of −24 to −28).
- Cards: `palette.surface`, radius 20 (tiles 12, banners 16), shadow `black @ 8%`, blur 24, offset (0, 10).
- Inputs: use `AuthTextField` (radius 12, `background` fill, `border` outline, `teal` focus). Buttons: height 50, radius 12, `palette.primary` background.
- Spacing on a 4-point scale (4, 8, 12, 16, 20, 24). Screen gutter is 16–24.
- Profile pictures: `UserAvatar` (`core/widgets/user_avatar.dart`); it shows the initials when there's no photo.
- Logos: `asset/breb/breb_logo.png` (full logo with Bengali name, white background, used on a white card), `asset/breb/breb_mark.png` (emblem only, used in small circular/rounded spots). Declare new assets in `pubspec.yaml`.
- App (launcher) icon: configured only through `flutter_launcher_icons.yaml`, from the images in `asset/icon/`; run `dart run flutter_launcher_icons` after changes. It is the BREB emblem's bulb on the emblem's blue `#25276D`, with the sunburst centered and the neck running off the bottom edge. The Android adaptive foreground keeps the sunburst 62dp wide inside the 108dp layer (safe zone) with `adaptive_icon_foreground_inset: 0`. Don't use the full logo (its Bangla text is unreadable at icon size). The app's display name is "BREB HRMS" (Android label, iOS `CFBundleDisplayName`, web manifest/title).
- Native launch screen (before Flutter starts): configured only through `flutter_native_splash.yaml`. Never hand-edit `android/app/src/main/res` launch files or the iOS `LaunchScreen.storyboard`/launch images; change the yaml and run `dart run flutter_native_splash:create`. It shows a white background (`AppColors.launchBackground`) with the full logo at 160dp/pt. The generator treats source images as 4x on both Android and iOS (640px = 160). The Android 12+ icon is a separate 1152px canvas with the logo inside the 768px circle. The app opens straight on Login after the native launch screen: there is no Flutter splash. `SplashPage` (`features/splash/`) is kept but not routed; add a route and set `initialLocation` back to it only if the user asks for the animated splash again.

## Language: Bangla and English

The app language is chosen in Settings, and `MaterialApp.locale` follows it.

- Every user-facing string goes in `AppStrings` (`core/l10n/app_strings.dart`) with both translations, `_t('বাংলা', 'English')`. Read it with `AppStrings.of(context)`. Don't write new user-facing text inline in a widget.
- Show numbers in Bangla digits in Bangla mode (see `AppStrings._digits`).
- Menu items come from the server with `name` and `nameBn`. Show them with `node.displayName(bangla: strings.isBangla)`; `alternateName` gives the other language for a subtitle.
- Language names are always written in their own language (`AppStrings.bangla` = "বাংলা", `AppStrings.english` = "English").
- Every screen is translated. Nothing user-facing is hardcoded in a widget, including the app title (`onGenerateTitle`), tooltips, validators, snackbars and the biometric prompt.
- Error messages: a message from the server is shown as-is. When there is none, the provider keeps `errorMessage == null` and the UI shows `strings.genericError` in the user's language. `AuthException(null, debugMessage: ...)` keeps technical detail out of the UI.
- For tests, `AppStrings.forLanguage(bangla: true)` gives the text without a widget tree. The responsive test runs the login flow in both languages.

### Bangla rendering (so text is never garbled)

- **Font:** Bangla uses the device's own system font. A bundled Noto Sans Bengali was tried and removed because the user preferred how the system font looks, so don't bundle or force a Bangla font without asking.
- **Unicode:** type Bangla in logical order, consonant first and then the vowel sign (ক + ে, never ে + ক). Use single characters for য় (U+09DF), ড় (U+09DC), ঢ় (U+09DD), ো (U+09CB), ৌ (U+09CC) and ৎ (U+09CE), not decomposed pairs. Some fonts and older devices draw the pairs with a loose dot or a dotted circle.
- Keep Dart files UTF-8 and write Bangla as normal text, not `\u` escapes (escapes are unreadable and don't change rendering).
- `test/core/l10n/bangla_text_test.dart` scans every Bangla word in `lib/` for these mistakes and for mojibake (UTF-8 read as Latin-1). If it fails, fix the string it names; don't weaken the check.
- Bangla from the server (menu names, and any new text field) goes through `normalizeBangla` (`core/utils/bangla_text.dart`) in the data model's `fromJson`. It repairs mojibake (UTF-8 read as Latin-1/Windows-1252), removes invisible characters and joins decomposed letters.
- If a menu item's server `nameBn` is missing or has no Bangla letters (an English copy, or legacy Bijoy text), `menuBanglaFallbacks` (`features/menu/data/models/menu_bangla_names.dart`) supplies the Bangla name, keyed by the lower-case English name. The server's own valid Bangla always wins. Treat this list as a stopgap: report the item to the backend team.
- Don't cut names with `maxLines` + ellipsis. "…" in the middle of a Bangla word looks broken. Let titles wrap and let the container grow (see `MenuGridTile`). Ellipsis is fine only for secondary text.
- No `letterSpacing` on Bangla text: it pulls conjuncts apart. Where a style uses it, use `letterSpacing: strings.isBangla ? 0 : x`.
- Bangla labels are often longer. Check new screens with the responsive test in both languages, and shrink display titles slightly in Bangla if needed (see the login title).

## Settings feature

`features/settings/` is the reference for a local-storage feature: `SettingsLocalDataSource` (shared_preferences) → `SettingsRepository` → `LoadSettingsUseCase` / `SaveSettingsUseCase` → `SettingsProvider`. The provider applies a change immediately, then saves it. A failed save or load never blocks the UI. Defaults: English, Light theme. New preferences go in `AppSettings` + `AppSettingsModel` (stored by enum name, unknown values fall back to the default).

## Sign-in flow

`AuthStatus` is `idle`, `loading`, `success` or `error`. `LoginPage` switches its overlay with an `AnimatedSwitcher`:
- `loading` and `success`: `SignInProgressOverlay`. The transmission tower draws in, then energy pulses loop until the server answers; `AbsorbPointer` blocks the form. On success `_submit` sets the menu and goes straight to Home while the overlay stays up, so there is no second splash and the form never flashes back.
- `idle` and `error`: no overlay; the form shows the error.

`ElectricConnectAnimation` (the old "Connecting…" bulb) is kept but no longer used, because the user asked for Home right after the tower.

The brand animations `TransmissionTowerScene` (sign-in overlay, and the unrouted splash) and `EnergyParticles` (unrouted splash) live in `core/widgets/` for reuse. `test/features/auth/presentation/pages/login_progress_test.dart` drives this flow with a fake `AuthRepository`.

## Home and navigation

- Home (`features/home/`): `HomeTopBar` (avatar opens the drawer, Settings on the right), `WelcomeBanner`, then `MenuGrid` of the top-level menu items. There is no bottom navigation bar.
- `HomeDrawer`: user header, the full menu tree (sections expand in place), then Settings and Log out. The whole drawer scrolls.
- Tapping any menu item goes through `openMenuNode` (`features/menu/presentation/widgets/menu_node_actions.dart`): a section opens a sheet of its children; a leaf is permission-checked. No feature screens exist yet, so an allowed leaf shows "coming soon". When you build a feature screen, add its route and navigate there from `openMenuNode`.
- `menuIconFor` maps the server's `iconName` / menu name to a Material icon by keyword. Extend its rules for new modules.
- Grids are built from rows with `IntrinsicHeight` (see `MenuGrid`), not a fixed-height `GridView`, so tiles grow with large text. Use `Breakpoints.gridColumns(width)` for the column count.

## Responsive design (every screen, every device)

Supported range: 280dp foldable cover screens up to 1920dp desktop, portrait and landscape, with system font scaling up to 2.0×.

- Wrap forms and cards in `ResponsiveCenter` (`core/layout/responsive.dart`). It caps the width at `Breakpoints.formMaxWidth` (440) for forms or `Breakpoints.contentMaxWidth` (720) for lists and content, and fills the width on phones. For a `ListView`, grow the side padding with `LayoutBuilder` instead (see `HomePage`).
- Any page whose content could be taller than the screen scrolls (`SingleChildScrollView` or `ListView`). This includes bottom sheets and dialogs.
- When a design needs `Spacer`s but must also scroll, use `LayoutBuilder` → `SingleChildScrollView` → `ConstrainedBox(minWidth: maxWidth, minHeight: maxHeight)` → `IntrinsicHeight` → `Column` (see `SplashPage`). Without `minWidth`, the content drifts to the left edge on wide screens.
- Full-bleed headers use `SafeArea(bottom: false)` so content clears notches and the Dynamic Island. Don't hard-code status-bar padding.
- Text in a `Row` must be inside `Expanded` or `Flexible`. Wrap labels in fixed-height buttons in `FittedBox(fit: BoxFit.scaleDown)`.
- Use `Text.rich`, never `RichText`: `RichText` ignores the user's font-size setting.
- Size `CustomPainter` drawings relative to `size` (e.g. scale by `size.shortestSide / 400`), not with fixed pixel values.
- Every new page must be added to `test/responsive_layout_test.dart`. That test runs each screen at 10 sizes × 3 text scales and fails on any overflow.

## Backend and networking

- Base URL: `ApiEndpoints.base`, overridable with `--dart-define=API_BASE_URL=...`. Several endpoints are unconfirmed (`refresh-demo-token`, sign-up). Read the TODOs in `api_endpoints.dart` and `signup_page.dart`, and don't "fix" them without confirming with the user.
- Datasources catch `DioException` and rethrow an `ApiException`/`AuthException` with a message from `extractErrorMessage`. Use `unwrapResult` for responses that may be wrapped in `{"result": ...}`.
- Tokens are stored through the `TokenStorage` interface (`SecureTokenStorage`). `AuthInterceptor` handles refresh; if the refresh fails, it calls `SessionExpiredHandler`.
- Never call `ApiEndpoints.adminCreateUser` from the app.

## Testing

- `test/` mirrors `lib/`, e.g. `lib/core/utils/jwt_utils.dart` → `test/core/utils/jwt_utils_test.dart`.
- Add tests for every new model's `fromJson`, domain service, use case with logic, and provider flow.
- Widget tests: the login header and sign-in overlay have repeating animations, so **never use `pumpAndSettle`**. Use `pump(duration)`. After a tap that opens a route or a sheet, call `pump()` once and then `pump(duration)`: the first frame only starts the animation.
- `buildAppDependencies()` is safe to call in tests (no network or platform calls at construction), and each call returns a fresh router.
- The test font draws every glyph as a full square, so text is wider than on a real device. If an overflow appears only in tests, it is still worth fixing, because it signals a tight layout.
