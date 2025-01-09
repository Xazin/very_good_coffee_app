# Very Good Coffee App

This project is a sample application leveraging Flutter to build for both iOS and Android.

## Requirements

The application fulfills these requirements:

- Pull coffee images from [Alex Flipnote's Free Coffee API](https://coffee.alexflipnote.dev)
- Load new coffee images if the current one displayed is not my favorite
- Ability to save the current coffee image locally if the user really likes it
- Ability to access saved favorite images and view them at all times, even offline

# Getting started

Before you can build the project, ensure that you have Flutter setup on your machine, and is on the same version as used for development for this application. If you're on a newer or older version of the Flutter SDK, you might experience issues.

The application is currently built using [Flutter SDK 3.27.0](https://docs.flutter.dev/release/release-notes/release-notes-3.27.0).

If you already fulfill the requirements, you can skip to the [Building the application](https://github.com/Xazin/very_good_coffee_app?tab=readme-ov-file#building-the-application) section.

## Requirements

Below is a list of requirements for building and running the application:

- Flutter SDK 3.27.0
- One of the listed: iOS Simulator, Android Emulator, or a physical iOS/Android device.

For Hardware requirements for Flutter, go to [Flutter.dev > Get started](https://docs.flutter.dev/get-started/install) and select which platform your device you're building on, is. Then you can select what the target is, select the Recommended option. _Note that the recommended option will always be either Android or iOS_.

## Building the application

Due to relying on [freezed](https://pub.dev/packages/freezed) and in turn [build_runner](https://pub.dev/packages/build_runner), we need to generate files before we can build and run the application.

Simply run the following command to generate the required code:

```bash
dart run build_runner build -d
```

_Note: The above has the argument -d which is shorthand for --delete-conflicting-outputs._

If the build_runner succeeded, you can now build and run the application using the following command:

```bash
flutter run -d <your-device>
```

To find your available devices you can run:

```bash
flutter devices
```
