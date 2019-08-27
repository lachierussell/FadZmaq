# Flutter
Flutter is a cross platform development framework by Google. Make sure you have it installed on your system, steps can be found here: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)


## Android
To push a build to a physical device or to an android emulator, you will need the Android SDK. Download it here: [https://developer.android.com/studio](https://developer.android.com/studio)

## iOS
Flutter should work with OSX and iOS but I have neither to test with unfortunately. Android studio will work on OSX if you wish to build to an android emulator from there though.


# Running Flutter
Run `flutter doctor` to check whether your flutter build has everything it needs to work. For example it may need licenses agreed to, the doctor command will alert you to anything that needs to be fixed
Flutter will build and run if you have a single device connected (virtual or physical). If you're like me and your phone model wasn't supported by your system you might need to add it to the `udev rules` if that is the case let me (Jordan) know and I'll see if I can help.

To build and run you have to do either of the following in the project root (fadzmaq):

    flutter run -t “lib/main.dart”

    flutter run -t “lib/main_testserver.dart”

 We'll be building two configurations so by default the app will look for `localhost` for the server information, and test server will look at Lachie's test server.

More configurations may be created as we go on but these two should serve us for the time being

## IDE
You can also run flutter from your chosen IDE, hot reloading is available on any IDE and will load any changes you make on the fly, which can be very useful for positioning widgets. I have made a launch json for VS Code which includes both build configurations for the app. Make sure you open the root folder of the flutter project rather than the git or you won’t be using the launch setup, and it also lanches a bit strangely.

## SDK
Flutter will automatically detect devices connected to your system, be it an android phone via usb or an android emulator running. You will need to have the android sdk for whichever version of android you are trying to build installed - so keep note if your phone and emulator are different versions you’ll need both versions of that sdk installed. Installing individual version sdks can be done from android studio sdk manager.

# Widgets
Flutter uses ‘widgets’ to build the look of the app. Custom widgets can be built by extending or combining basic widget classes. Widgets can be stateless or have states, stateless widgets are immutable, and stateful widgets are used for any widget that will change over time, even if it is not necessarily storing that state.

To learn more have a look at the Getting Started project here: [https://flutter.dev/docs/get-started/codelab](https://flutter.dev/docs/get-started/codelab)