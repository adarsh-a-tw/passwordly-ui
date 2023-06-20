import 'package:flutter/material.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';

// Wrapper class for navigator push methods
class PasswordlyNavigator {
  static Future<T?> pushNamedAndRemoveUntilWithArguments<T extends Object?>(
    BuildContext context,
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    final args = arguments is Map<RouteArgumentKey, dynamic>
        ? arguments
        : <RouteArgumentKey, dynamic>{RouteArgumentKey.shouldSlideLeft: false};

    return Navigator.pushNamedAndRemoveUntil(
      context,
      newRouteName,
      predicate,
      arguments: args,
    );
  }

  static Future<T?> pushNamedWithArguments<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    final args = arguments is Map<RouteArgumentKey, dynamic>
        ? arguments
        : <RouteArgumentKey, dynamic>{RouteArgumentKey.shouldSlideLeft: false};

    return Navigator.pushNamed(
      context,
      routeName,
      arguments: args,
    );
  }
}
