# Ihsan V2

Sacred Night concept prototype for the Ihsan Muslim super app, built in Flutter.

## What is implemented

- Flutter app shell with a Sacred Night design system
- Animated splash and onboarding flow
- Five-tab navigation:
  - Home
  - Quran
  - Prayer
  - Community
  - More
- Interactive concept previews for core experiences:
  - Prayer arc timeline
  - Quran reader
  - Tasbeeh counter
  - Masjid finder map
  - Notification center
  - Zakat calculator
  - AI scholar chat
  - Ramadan mode
  - Family dashboard
  - Universal search
  - Accessibility settings
- Full 69-screen concept atlas from the PDF spec, grouped by phase and accessible in-app

## Architecture

- `lib/theme.dart`
  - Sacred Night palette, typography, gradients, and theme tokens
- `lib/data.dart`
  - Screen inventory from the concept doc plus mock data for prayer, Quran, community, commerce, and family flows
- `lib/app.dart`
  - App shell, onboarding, reusable glass/atmospheric UI, navigation, and interactive concept screens
- `lib/main.dart`
  - Provider bootstrap and app entrypoint

## Run locally

```bash
flutter pub get
flutter run
```

## Verification

```bash
flutter analyze
flutter test
```

## Media capture

```bash
./tool/capture_media.sh
```

Generated artifacts:

- screenshots: `artifacts/screenshots/`
- walkthrough video: `artifacts/ihsan-feature-walkthrough.mp4`

## Release packaging

```bash
./tool/build_release.sh
```

Release outputs are written to:

- `artifacts/releases/web`
- `artifacts/releases/app-release.apk` when Android SDK/signing are available
- `artifacts/releases/app-release.aab` when Android SDK/signing are available

See `docs/production-deployment.md` for the remaining external requirements for real store deployment.

## Notes

- This codebase is a high-fidelity front-end prototype derived from the concept document.
- It uses mock data and local state rather than a live backend.
- The next production step would be wiring the experience to the backend architecture described in the concept:
  - Supabase
  - search
  - local Quran/prayer data
  - push notifications
  - AI services
