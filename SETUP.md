# TaskFlow - Setup Guide

## Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (Hive, Stacked, Freezed)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

## Troubleshooting

**Build runner fails:**
```bash
flutter clean && flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**iOS pods issue:**
```bash
cd ios && pod install && cd ..
```

See `pubspec.yaml` for full dependency list.

