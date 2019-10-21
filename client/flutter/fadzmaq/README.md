# About Flutter
Flutter is a cross platform development framework by Google. Make sure you have it installed on your system, steps can be found here: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)


## Android
To push a build to a physical device or to an android emulator, you will need the Android SDK. Download it here: [https://developer.android.com/studio](https://developer.android.com/studio)

## iOS
Flutter also works with macOS and iOS but you must be running macOS to build for it.

## IDE
You can also run flutter from your chosen IDE, hot reloading is available on any IDE and will load any changes you make on the fly. Make sure you open the root folder of the flutter project rather than the git or you won’t be using the launch setup, and it also lanches a bit strangely.

## SDK
Flutter will automatically detect devices connected to your system, be it an android phone via usb or an android emulator running. You will need to have the android sdk for whichever version of android you are trying to build installed - so keep note if your phone and emulator are different versions you’ll need both versions of that sdk installed. Installing individual version sdks can be done from android studio sdk manager.

## Widgets
Flutter uses ‘widgets’ to build the look of the app. Custom widgets can be built by extending or combining basic widget classes. Widgets can be stateless or have states, stateless widgets are immutable, and stateful widgets are used for any widget that will change over time, even if it is not necessarily storing that state.

To learn more have a look at the Getting Started project here: [https://flutter.dev/docs/get-started/codelab](https://flutter.dev/docs/get-started/codelab)
# Fadzmaq Install

Before starting you will need to have Flutter installed, a Firebase account setup and a copy of the server running.

## Signing Cetificate for Android
For authentication to work with Android you must either add a keystore to use as a signing certificate, or add your environment's signing certificate to those accepted by the firebase project. More information on this can be found at [https://developer.android.com/studio/publish/app-signing](https://developer.android.com/studio/publish/app-signing)

## Flutter
Run `flutter doctor` to ensure your flutter environment is correctly configured, the doctor command will alert you to anything that needs to be fixed.

Flutter will only run a debug build if you have a single device connected (virtual or physical). If your phone model wasn't supported by your system you might need to add it to the `udev rules` of your system.

## Build Configuration
To build and run you have to do either of the following in the project root (fadzmaq):

    flutter run -t “lib/main.dart”

    flutter run -t “lib/main_testserver.dart”

By default the app will look for a locally running instance of the server, and the test server information can be configured for a  remote server. These configurations are stored in `lib/resources` 

