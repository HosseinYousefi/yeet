import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Put this as your routeInformationParser in [MaterialApp.router].
class YeetInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(routeInformation.location ?? '/');

  @override
  RouteInformation? restoreRouteInformation(String location) =>
      RouteInformation(location: location);
}
