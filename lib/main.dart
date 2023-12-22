import 'package:flutter/material.dart';
import 'package:save_card_ui_kit/utils/theme.dart';
import './app/engine/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final _myRouter = MyRouter();
  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: _myRouter.config(),
      debugShowCheckedModeBanner: false,
      title: 'Save Card Demo',
      theme: Themes.lightMode,
      themeMode: ThemeMode.light,
    );
  }
}
