# MobSur Flutter Demo App

A sample Flutter app that shows how to use the [MobSur Flutter SDK](https://pub.dev/packages/mobsur_flutter_sdk) (2.0.0).

## Requirements

- Flutter 3.38.1 or newer (Dart 3.10)
- iOS: Xcode 27, iOS 15.0 or newer
- Android: JDK 17, Android SDK 36, minSdk 24

## Run

```sh
flutter pub get
flutter run
```

Options, passed with `--dart-define`:

| Define | What it does |
|---|---|
| `MOBSUR_APP_ID=<App ID>` | Uses another app from the MobSur dashboard. The demo App ID is the default. |
| `MOBSUR_BASE_URL=<url>` | Points the app at staging or a local MobSur server instead of production. |
| `MOBSUR_DEBUG=true` | Prints SDK logs in a release build. Debug builds always print them. |

## Test a survey

1. Type an event name (default `MY_Event`) and tap **Start the survey**. If a live survey listens for
   that event, it opens in a sheet. The console shows what the SDK does (lines starting with `MobSur ::`).
2. The screen lists the surveys the SDK has for this device. The SDK fetches them at launch, when the
   user ID changes, and 6 hours after the last fetch. A survey you just created in the dashboard shows
   up only after you restart the app.

Limits to keep in mind while testing:

- **One survey per app session.** Once a survey opened (even if you closed it with X), nothing else
  opens until you restart the app.
- **A finished survey never opens again for the same user**, and the server skips users who already
  answered. To see it again, tap **New test user**, then restart the app.

## Known issue

`flutter build ios --simulator` fails with Flutter 3.38.7 and Xcode 27
(`does not contain architectures "arm64 x86_64"`): Xcode 27's `lipo -verify_arch` accepts only one
architecture. Use `flutter run` on a simulator instead. Device builds are not affected.
