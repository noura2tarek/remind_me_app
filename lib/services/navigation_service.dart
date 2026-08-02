import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateTo(Widget page, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  void navigateNamedTo(
    String routeName,
    BuildContext context, {
    Object? extra,
  }) {
    Navigator.of(context).pushNamed(routeName, arguments: extra);
  }

  // Replace the current route
  void navigateReplacementNamedTo(
    String routeName,
    BuildContext context, {
    Object? extra,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: extra);
  }

  void navigateNamedAndRemoveUntil(
    String routeName,
    BuildContext context, {
    Object? extra,
  }) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(routeName, (route) => false, arguments: extra);
  }

  void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  //--- pop
  static void popGlobal([BuildContext? context]) {
    if (context != null) {
      Navigator.of(context).maybePop();
    } else {
      navigatorKey.currentState?.maybePop();
    }
  }
}
