import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  Future<dynamic>? navigateTo(String routeName) {
    return navigatorKey.currentState?.pushNamed(routeName);
  }

  Future<dynamic>? popAndNavigateTo(String routeName) {
    return Future.microtask(() {
      return navigatorKey.currentState?.popAndPushNamed(routeName);
    });
  }

  Future<dynamic> navigateToReplacement(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
