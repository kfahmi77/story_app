# Story App (Dicoding Submission)

Flutter app for sharing stories with:
- Authentication (`login` / `register`)
- Story list + infinite scrolling pagination
- Story detail
- Add story with image upload
- Optional map location pin (paid flavor)
- Localization (English / Indonesian)

## Features Implemented

### Core
- Authentication flow with persisted session
- Story list with pull-to-refresh + pagination
- Story detail page
- Add story page
- User-friendly error messages

### Maps
- Story detail map (if story has `lat/lon`)
- Marker tap to show address (reverse geocoding)
- Location picker map for adding story (paid flavor only)
- Optional current location button

### Quality / Reviewer Suggestions
- Localization setting (EN / ID / device language)
- Refresh list after successful upload
- Hero animation for story image transition
- AnimatedSwitcher for location selection section
- Android build variants: `free` and `paid`

## Dependencies (high level)
- `flutter_map` + `latlong2` for OpenStreetMap UI
- `geolocator` for device location
- `geocoding` for reverse geocoding address
- `json_serializable` + `build_runner` for code generation

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Run (Android Flavors)

### Free
```bash
flutter run --flavor free --dart-define=APP_TIER=free
```

### Paid
```bash
flutter run --flavor paid --dart-define=APP_TIER=paid
```

## Build APK (Android Flavors)

### Free
```bash
flutter build apk --flavor free --dart-define=APP_TIER=free
```

### Paid
```bash
flutter build apk --flavor paid --dart-define=APP_TIER=paid
```

## Location / Map Notes
- Add story location selection is enabled only in `paid` flavor.
- Detail story map remains visible for stories that already have location data.
- Android permissions are configured in `android/app/src/main/AndroidManifest.xml`.
- iOS `NSLocationWhenInUseUsageDescription` is configured in `ios/Runner/Info.plist`.

## Submission Self-Check
- [x] Infinite scrolling pagination
- [x] Pull-to-refresh
- [x] Story refresh after upload
- [x] Localization setting
- [x] Friendly error messages
- [x] Map in story detail (with marker)
- [x] Map picker for add story (paid)
- [x] Marker tap shows address
- [x] Code generation for object classes
- [x] Android build variants (`free` / `paid`)
