import 'package:flutter/widgets.dart';

/// Put this as your routeInformationParser in [MaterialApp.router].
class YeetInformationParser extends RouteInformationParser<RouteInformation> {
  @override
  Future<RouteInformation> parseRouteInformation(
          RouteInformation routeInformation) async =>
      routeInformation;

  @override
  RouteInformation? restoreRouteInformation(
          RouteInformation routeInformation) =>
      routeInformation;
}
