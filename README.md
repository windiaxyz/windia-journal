# AuraPal (Flutter)

AuraPal is a cross-platform Flutter app (Android + iOS) for **entertainment/self-reflection-only** aura and palm readings.

> ⚠️ Not medical, diagnostic, treatment, legal, or financial advice.

## Features
- Selfie Aura scan (camera/gallery) with deterministic aura archetype mapping.
- Palm scan + guided Q&A for explainable trait output.
- Daily horoscope generated offline via deterministic seeded PRNG.
- Friends list with invite code + QR and compatibility score.
- History of derived readings only (raw photos not stored by default).
- Privacy-first settings: sharing toggles, derived-only sharing, export JSON, delete local data/account.
- Default local-only mode with optional Firebase cloud sync mode.

## Architecture
- Feature-first UI modules under `lib/features/`.
- Services under `lib/services/` for analysis, mapping, persistence, horoscope, and compatibility logic.
- Models under `lib/models/`.
- Offline-first using Hive local persistence.

## Windows-friendly Android setup
1. Install Flutter stable and Android Studio on Windows.
2. Run:
   ```bash
   flutter doctor
   flutter pub get
   flutter run -d android
   ```
3. Ensure camera permission prompts are accepted on first launch.

## iOS
- Build/run on macOS with Xcode:
  ```bash
  flutter run -d ios
  ```

## Permissions
Add these before production release:
- Android: camera/photos permissions in `android/app/src/main/AndroidManifest.xml`.
- iOS: camera/photo usage descriptions in `ios/Runner/Info.plist`.

## Optional Firebase setup
Default mode is local-only. For Firebase mode:
1. Add Firebase project and initialize FlutterFire.
2. Add config files:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
3. Wire `firebase_options.dart` + initialization in `main.dart`.
4. Use these collection paths:
   - `users/{uid}` profile + privacy + latest summary
   - `users/{uid}/friends/{friendUid}` relationship + share status
   - `invites/{code}` invite code mapping with expiry

## Testing
Pure-function tests included:
- Aura mapping from image metrics
- Seeded horoscope deterministic generation
- Compatibility score math

Run:
```bash
flutter test
```
