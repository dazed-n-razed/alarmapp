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

## Files of interest
- `lib/features/onboarding/onboarding_screen.dart` — Onboarding UI and responsive layout.
- `lib/features/home/home_screen.dart` — Entry Home screen with location fetch flow.
- `lib/features/home/home_alarm.dart` — Alarm management screen with scheduling and notifications.
- `lib/widgets/onboarding_button.dart` — Custom button used across onboarding/home screens.
- `pubspec.yaml` — Asset definitions and dependencies (e.g., `flutter_local_notifications`, `intl`).
- `android/app/build.gradle.kts` — Enabled core library desugaring and dependency for desugaring.

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

