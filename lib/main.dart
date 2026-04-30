import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'app.dart';

void main() {
  setupDependencies();
  runApp(const FitnessProApp());
}