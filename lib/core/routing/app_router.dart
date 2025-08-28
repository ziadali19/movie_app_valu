import 'package:flutter/material.dart';

class AppRouter {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    Object? arguments = settings.arguments;
    switch (settings.name) {
      default:
        return MaterialPageRoute(builder: (context) => const SizedBox());
    }
  }
}
