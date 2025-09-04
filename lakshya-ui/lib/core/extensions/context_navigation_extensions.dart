import 'package:flutter/material.dart';

/// Extension on BuildContext for convenient access to common Flutter APIs
extension ContextExtensions on BuildContext {
  /// Navigation shortcuts
  NavigatorState get navigator => Navigator.of(this);

  /// Push a new route
  Future<T?> push<T extends Object?>(Route<T> route) {
    return Navigator.of(this).push(route);
  }

  /// Push a named route
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  /// Push and replace current route
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> newRoute, {
    TO? result,
  }) {
    return Navigator.of(this).pushReplacement(newRoute, result: result);
  }

  /// Push named route and replace current
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, result: result, arguments: arguments);
  }

  /// Push and remove all previous routes
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) {
    return Navigator.of(this).pushAndRemoveUntil(newRoute, predicate);
  }

  /// Push named route and remove all previous routes
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(newRouteName, predicate, arguments: arguments);
  }

  /// Pop current route
  void pop<T extends Object?>([T? result]) {
    return Navigator.of(this).pop(result);
  }

  /// Pop until a specific route
  void popUntil(RoutePredicate predicate) {
    return Navigator.of(this).popUntil(predicate);
  }

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// Pop to root (remove all routes except first)
  void popToRoot() {
    return Navigator.of(this).popUntil((route) => route.isFirst);
  }
}

/// Extension for Material page routes
extension MaterialPageRouteExtensions on BuildContext {
  /// Push a Material page route
  Future<T?> pushMaterialRoute<T extends Object?>(
    Widget page, {
    String? routeName,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return push<T>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  /// Push and replace with Material page route
  Future<T?>
  pushReplacementMaterialRoute<T extends Object?, TO extends Object?>(
    Widget page, {
    String? routeName,
    TO? result,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return pushReplacement<T, TO>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      result: result,
    );
  }
}
