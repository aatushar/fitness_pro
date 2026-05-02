import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupDependencies();
  runApp(const FitnessProApp());
}