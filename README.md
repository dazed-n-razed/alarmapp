# AlarmApp

A Flutter mobile application prototype for a travel-oriented alarm which I did for a Job Assignment XD! Psy.

## Brief history
- Started as a simple onboarding + demo app showing videos/gifs.
- Evolved to include a Home screen and an Alarm management screen with local notification support.
- Gradually improved for responsive layout (designed from a 360x800 Figma spec) and dynamic positioning.

## Core functionalities implemented
- Onboarding flow with responsive layout and background gradient.
- Media support in onboarding (videos and GIFs provided in `assets/`).
- Home screen with a welcome message and circular image.
- Location fetch simulation which, when confirmed, navigates to the alarm manager screen.
- Alarm manager screen:
	- Add an alarm via Date + Time pickers (ensures future times only).
	- Displays list of scheduled alarms showing time and date.
	- Toggle alarms on/off (schedules or cancels notifications accordingly).
	- Uses `flutter_local_notifications` to show notifications.
	- In-app Timer fallback scheduler is implemented to trigger notifications while the app runs.
- Android build: core library desugaring enabled (required by the notification plugin).

## Figma-Based Ratio Scaling for Dynamic UI

The UI is implemented to match a Figma reference screen of 360×800 px. Rather than using absolute pixel values, the layout computes each element's position and size as a ratio of the reference screen. This keeps the visual composition consistent across different devices.

### Key dynamic ratios

- Media container height (Frame 3 top: 453px): the media (video/GIF) area occupies approximately 55% of the screen height. This is derived from the original media height (~429px) relative to the design height:

	$\dfrac{429}{800} \approx 0.536 \;\text{(≈ 0.55)}$

- Page indicator top (Frame 4 top: 632px): position the indicator at 79% of screen height:

	$\dfrac{632}{800} = 0.79$

- Action button top (Frame 5 top: 664px): position the main action button at 83% of screen height:

	$\dfrac{664}{800} = 0.83$

Practical notes:

- Compute positions at runtime using `MediaQuery.of(context).size` multiplied by the ratios above (for example `screenHeight * 0.79`).
- Use `Stack` + `Positioned` (or `Align`) to place frames by computed offsets so elements remain relative to each other when screen size changes.

## Files of interest
- `lib/features/onboarding/onboarding_screen.dart` — Onboarding UI and responsive layout.
- `lib/features/home/home_screen.dart` — Entry Home screen with location fetch flow.
- `lib/features/home/home_alarm.dart` — Alarm management screen with scheduling and notifications.
- `lib/widgets/onboarding_button.dart` — Custom button used across onboarding/home screens.
- `pubspec.yaml` — Asset definitions and dependencies (e.g., `flutter_local_notifications`, `intl`).
- `android/app/build.gradle.kts` — Enabled core library desugaring and dependency for desugaring.

## Tools & packages used

Platform & tools
- Flutter SDK (Dart) — project uses Flutter and requires the Flutter toolchain installed.
- Android SDK / Gradle — Android build uses Java 11 compatibility and core library desugaring.
- Kotlin (Gradle Android plugin used in Android build scripts).

Key Dart / Flutter packages (see `pubspec.yaml` for full list and versions):
- `flutter_local_notifications` — local notifications integration (used to show alarm notifications).
- `video_player` (^2.5.1) — playback of onboarding video assets.
- `intl` (^0.20.2) — date/time formatting for display.
- `cupertino_icons` (^1.0.8) — iOS-style icons.

Build helper added
- `com.android.tools:desugar_jdk_libs:2.1.4` — added to `android/app/build.gradle.kts` to enable core library desugaring required by some plugins.

Optional / recommended (not currently added)
- `timezone` + `flutter_native_timezone` — if you want OS-level, timezone-aware `zonedSchedule` notifications that fire when the app is killed. This repo currently implements an in-app Timer fallback for notifications while the app runs.


## How to run (Windows / PowerShell)
1. Install Flutter and ensure `flutter` is available on your PATH. See https://flutter.dev/docs/get-started/install.
2. From the project root in PowerShell, fetch packages and run the app:

```powershell
flutter pub get
flutter run
```

3. If you encounter Android build errors related to Java 8 APIs, ensure your Android SDK / Gradle tooling is up to date. We enabled core-library desugaring in `android/app/build.gradle.kts` to address known plugin requirements.

## Notes about notifications
- The app currently uses a Timer-based fallback to schedule notifications while the app runs. This works reliably while the app process is alive.
- If you need alarms to fire when the app is terminated, we should:
	- Add and initialize the `timezone` and `flutter_native_timezone` packages,
	- Initialize timezone data in `initState`, then use `flutterLocalNotificationsPlugin.zonedSchedule(...)` with `tz.TZDateTime`.
	- Configure Android and iOS native settings (notification icon, background permissions, etc.).

## Next improvements you might want
- Persist alarms to local storage (shared_preferences, hive) so alarms survive restarts.
- Use `timezone` + `flutter_native_timezone` and `zonedSchedule` for OS-level scheduling that works when the app is terminated.
- Add delete/edit alarm UI and better date/time UX (recurring alarms, snooze, labels).
- Add unit tests for alarm scheduling logic.

## Contact / Contributing
- This repository is intended as a prototype. Open an issue or create PRs for fixes or features.

---

Enjoy working with the app. EASY 

