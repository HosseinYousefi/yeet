import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

typedef WidgetBuilder = Widget Function(Map<String, String> params);

enum YeetPersistence {
  persistent,
  releasing,
}

class Yeet {
  final String? path;
  final WidgetBuilder? builder;
  final List<Yeet>? children;
  final List<String> parameters;
  late final RegExp? regExp;
  final YeetPersistence persistence;

  Yeet({
    this.path,
    this.builder,
    this.children,
    this.persistence = YeetPersistence.persistent,
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
      );
    } else {
      regExp = null;
    }
  }

  Widget build(BuildContext context) {
    final yeeters = children;
    if (yeeters == null) {
      return Container();
    }
    return Container();
  }
}
