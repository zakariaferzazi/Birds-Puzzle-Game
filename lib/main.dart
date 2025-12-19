import 'package:flutter/material.dart';
import 'package:puzzle_hack/src/inject_dependencies.dart';
import 'package:puzzle_hack/src/ui/utils/ad_manager.dart';
import 'package:url_strategy/url_strategy.dart';
import 'src/my_app.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  AdManager().initialize();
  await injectDependencies();
  runApp(const MyApp());
}
