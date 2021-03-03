import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:yeet/yeet.dart';

typedef WidgetBuilder = Widget Function(Map<String, String> params);

/// The class that defines your routing tree structure.
///
/// If several Yeets match a given path the very top one will be chosen.
class Yeet {
  static YeeterDelegate of(BuildContext context) {
    return Router.of(context).routerDelegate as YeeterDelegate;
  }

  /// The blueprint path for this yeet.
  ///
  /// You can use parameters and regexes inside paranthesis.
  /// For example `'/user/:id(/d+)'` means the path should match
  /// `'/user/10'` but not `'/user/alice'`.
  ///
  /// It can also be relative. For example if the parent yeet has a
  /// path of `'/profile'` and this yeet has a path of `'settings'`
  /// it's actually matching `'/profile/settings'`.
  final String? path;

  final WidgetBuilder? builder;
  final List<Yeet>? children;
  final List<String> parameters;
  late final RegExp? regExp;
  final bool persist;

  Yeet({
    this.path,
    bool caseSensitive = true,
    this.persist = false,
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
        caseSensitive: caseSensitive,
      );
    } else {
      regExp = null;
    }
  }
}
