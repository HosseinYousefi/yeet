import 'package:flutter/widgets.dart';

class Yeeter {
  final List<Yeeter>? children;
  final String? path;
  final Widget? view;
  final String? redirectTo;
  final Map<String, Function(String)>? parsers;

  Yeeter({
    this.children,
    this.path,
    this.view,
    this.redirectTo,
    this.parsers,
  })  : assert(view == null || redirectTo == null,
            'Both view and redirectTo cannot have value.'),
        assert(path != null || children != null,
            'Both path and children cannot be null.');
}
