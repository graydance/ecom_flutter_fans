import 'package:flutter/material.dart';
import 'package:fans/app.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

Future<void> main() async {
  configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ReduxApp());
}
