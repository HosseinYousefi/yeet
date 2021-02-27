import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

typedef WidgetBuilder = Widget Function(Map<String, String> params);

class Yeet {
  final String? path;
  final WidgetBuilder? builder;
  final List<Yeet>? children;
  final List<String> parameters;
  late final RegExp? regExp;

  Yeet({
    this.path,
    this.builder,
    this.children,
  }) : parameters = [] {
    if (children != null && children!.isEmpty) {
      throw ArgumentError('children cannot be empty');
    }
    if (path == null && children == null) {
      throw ArgumentError('Both path and children cannot be null.');
    }
    if (path != null) {
      regExp = pathToRegExp(
        path!,
        parameters: parameters,
        prefix: true,
      );
    } else {
      regExp = null;
    }
  }
}
