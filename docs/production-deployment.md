# Production deployment checklist

This repository now contains:

- a Flutter application shell
- tested web build support
- automated screenshot/video capture
- release build automation for web and Android

## What is automated now

### Quality gates

- `flutter analyze`
- `flutter test`

### Media generation

- `tool/capture_media.sh`
  - builds the web app
  - serves it locally
  - captures feature screenshots
  - generates a walkthrough MP4

### Release packaging

- `tool/build_release.sh`
  - runs analyzer/tests
  - builds a web release
  - attempts Android release artifacts if the Android SDK is available

## What still requires real production inputs

These cannot be honestly completed without your accounts, credentials, and infra decisions:

### Android

- final application signing keystore
- Play Console app setup
- package visibility/privacy declarations
- production backend URLs and API keys
- analytics/notification credentials if used

### iOS

- Apple Developer account
- App Store Connect app record
- signing certificates and provisioning profiles
- Xcode/macOS build machine

### Backend / live services

- Supabase project and secrets
- push notification credentials
- AI provider production keys
- Quran/prayer/calculation data strategy
- privacy policy and legal URLs
- production domain and hosting/CDN choice if web is deployed

## Recommended next steps

1. Provide production credentials and environment variables.
2. Decide the first live release target:
   - web
   - Android
   - iOS
3. Replace remaining mock data with live services.
4. Add store-safe legal copy:
   - privacy policy
   - terms
   - support contact
5. Configure signing and CI/CD.

## Current status

The codebase is release-oriented and demonstrable, but not yet a fully live store deployment because:

- this environment does not have Apple signing/build capability
- Android signing credentials were not provided
- the app still uses mock data rather than production APIs
