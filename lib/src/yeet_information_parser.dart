import 'package:flutter/widgets.dart';

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
