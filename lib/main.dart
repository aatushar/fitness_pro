import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection.dart';
import 'core/storage/global_token.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupDependencies();
  
  // Initialize global token on app startup
  await globalToken.initializeToken();
  
  runApp(const FitnessProApp());
}