import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

class Yeeter {
  final String? path;
  final Widget? Function(
      Map<String, String> pathParams, Map<String, String> queryParams)? builder;
  final List<Yeeter>? children;
  final _key = GlobalKey<NavigatorState>();
  final RegExp? _regExp;

  Yeeter({
    this.path,
    this.builder,
    this.children,
  })  : assert(path != null || children != null,
            'Both path and children cannot be null.'),
        _regExp = path == null
            ? null
            : pathToRegExp(path.startsWith('/') ? path.substring(1) : path);

  Widget build(BuildContext context) {
    final yeeters = children;
    if (yeeters == null) {
      return Container();
    }
    return Container();
  }
}
