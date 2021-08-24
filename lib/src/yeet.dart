import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:yeet/yeet.dart';

import 'yeet_transition.dart';

typedef YeetWidgetBuilder = Widget Function(BuildContext context);

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

  /// A function that gets the path and query parameters and builds the widget.
  final YeetWidgetBuilder? builder;

  /// A list of subyeets of this yeet.
  final List<Yeet>? children;

  /// The default transition of this yeet.
  ///
  /// Defaults to [YeetTransition.adaptive].
  final YeetTransition transition;

  /// Whether or not to maintain the state of this yeet.
  ///
  /// Defaults to true.
  final bool maintainState;

  /// Whether it's a dialog or a normal page.
  ///
  /// Dialogs have a close button instead of a back button by default.
  /// Defaults to false.
  final bool fullscreenDialog;

  final List<String> parameters;
  late final RegExp? regExp;

  Yeet({
    this.path,
    bool caseSensitive = true,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.builder,
    this.children,
    this.transition = const YeetTransition.adaptive(),
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

  @override
  bool operator ==(Object o) {
    return o is Yeet && hashCode == o.hashCode;
  }

  @override
  int get hashCode {
    int h = super.hashCode;
    for (final child in children ?? []) {
      h ^= child.hashCode;
    }
    return h ^ path.hashCode;
  }
}
