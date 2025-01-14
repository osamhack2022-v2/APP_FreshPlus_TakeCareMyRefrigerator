import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
show defaultTargetPlatform, kIsWeb, TargetPlatform;
/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
/// options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
static FirebaseOptions get currentPlatform {
if (kIsWeb) {
return web;
}
switch (defaultTargetPlatform) {
case TargetPlatform.android:
return android;
case TargetPlatform.iOS:
return ios;
case TargetPlatform.macOS:
throw UnsupportedError(
'DefaultFirebaseOptions have not been configured for macos - '
'you can reconfigure this by running the FlutterFire CLI again.',
);
case TargetPlatform.windows:
throw UnsupportedError(
'DefaultFirebaseOptions have not been configured for windows - '
'you can reconfigure this by running the FlutterFire CLI again.',
);
case TargetPlatform.linux:
throw UnsupportedError(
'DefaultFirebaseOptions have not been configured for linux - '
'you can reconfigure this by running the FlutterFire CLI again.',
);
default:
throw UnsupportedError(
'DefaultFirebaseOptions are not supported for this platform.',
);
}
}
static const FirebaseOptions web = FirebaseOptions(
apiKey: 'AIzaSyCb7dzWlfrFOELNCYKaYwVQm-APYtNt3ws',
appId: '1:160603413044:web:557439427153a6a8928861',
messagingSenderId: '160603413044',
projectId: 'fresh-plus-osam',
authDomain: 'fresh-plus-osam.firebaseapp.com',

storageBucket: 'fresh-plus-osam.appspot.com',
measurementId: 'G-7VLH0B8XT1',
);
static const FirebaseOptions android = FirebaseOptions(
apiKey: 'AIzaSyBCZW5m3JFuxRTcMI6gDUQGDse36dnN_jg',
appId: '1:160603413044:android:a33190fcc2232602928861',
messagingSenderId: '160603413044',
projectId: 'fresh-plus-osam',
storageBucket: 'fresh-plus-osam.appspot.com',
);
static const FirebaseOptions ios = FirebaseOptions(
apiKey: 'AIzaSyDtfT7W4vDH65A5ua1JJoBjO7LaVJXE8OY',
appId: '1:160603413044:ios:5b9fd3ab01284814928861',
messagingSenderId: '160603413044',
projectId: 'fresh-plus-osam',
storageBucket: 'fresh-plus-osam.appspot.com',
iosClientId: '160603413044-8puvlhekoekdp805f8lgl9mte5vntdnr.apps.googleusercontent.com',
iosBundleId: 'com.example.helloWorld',
);
}