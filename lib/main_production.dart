import 'package:chatup/app/app.dart';
import 'package:chatup/bootstrap.dart';
import 'package:chatup/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
