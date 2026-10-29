# MobSur Flutter Demo App

A sample Flutter app that shows how to use the [MobSur Flutter SDK](https://pub.dev/packages/mobsur_flutter_sdk) (2.0.0).

## Run

```sh
flutter pub get
flutter run
```

The app uses the demo App ID by default. To use another app from the MobSur dashboard:

```sh
flutter run --dart-define=MOBSUR_APP_ID=<your App ID>
```

Type an event name (default `MY_Event`) and tap **Start the survey**. If a live survey in the dashboard
listens for that event, it opens in a sheet. The console shows what the SDK does (lines starting with
`MobSur ::`), and the screen lists the surveys the SDK received for this device.

Requirements: Flutter 3.38+, iOS 15+, Xcode 27 for iOS builds.
