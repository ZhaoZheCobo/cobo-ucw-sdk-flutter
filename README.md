# Cobo UCW SDK Flutter

The Cobo UCW SDK provided by Cobo that allows your Client App to interact with the Cobo Server. A user-facing Client App you build that utilizes the UCW SDK is for Cobo MPC Wallets (User-Controlled Wallets). For a high-level overview of what User-Controlled Wallets are, see [Introduction to User-Controlled Wallets](https://manuals.cobo.com/en/portal/mpc-wallets/introduction#user-controlled-wallets).

## Installation

The UCW SDK is distributed as a [Flutter plugin package](https://flutter.dev/developing-packages/), making platform functionality easily available in your app.

To add the UCW SDK as a dependency in your Flutter project, follow these steps:

1 Once you have your Flutter project set up, adding UCW SDK to the `dependencies` value of your `pubspec.yaml`.

```yaml
dependencies:
  ucw_sdk:
    git:
      url: https://github.com/CoboGlobal/cobo-ucw-sdk-flutter.git
      ref: master  # Replace "master" with a specific branch, tag, or commit hash
```

You can specify the version using:

- Branch name:  `ref: master`
- Tag: `ref: v0.1.0`
- Commit hash: `ref: e68a9dd09aa20b8f4e864ae149a797c59fe7d937`

2 From the terminal, run `flutter pub get`.

## Usage

In the Dart source file where you want to use the SDK, import the necessary modules:

```dart
import 'package:ucw_sdk/ucw_sdk.dart';
import 'package:ucw_sdk/data.dart';
```

Use the SDK to initialize the secrets database and retrieve a new TSS Node ID:

```dart
String secrets = 'secrets.db';
String passphrase = 'uKm7@_NQ4xiQn7UbU-!JXaMdJa*BgNJj';

try {
    final tssNodeID = await initializeSecrets(secrets, passphrase);
    print('TSS Node ID: $tssNodeID');
} catch (e) {
    print('Failed to initialize secrets: $e');
}
```
