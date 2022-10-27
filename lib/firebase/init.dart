import '/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initialize() async {
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform);
}