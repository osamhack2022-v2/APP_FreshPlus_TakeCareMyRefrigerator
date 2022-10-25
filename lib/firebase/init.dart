import 'package:firebase_core/firebase_core.dart';
import 'package:helloworld/firebase_options.dart';

Future<void> initialize() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
}
