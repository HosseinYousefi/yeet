import 'package:flutter/widgets.dart';

import 'yeet.dart';

extension YeetX on BuildContext {
  /// Navigates to another path. If no arguments are given, it pops the top page.
  void yeet([String? path]) {
    Yeet.of(this).yeet(path);
  }

  void yeetOnTop(String path) {
    Yeet.of(this).yeetOnTop(path);
  }

  void push(String path) {
    Yeet.of(this).push(path);
  }

  void changePath(String path) {
    Yeet.of(this).changePath(path);
  }

  Map<String, String> get params => Yeet.of(this).params;

  Map<String, String> get queryParams => Yeet.of(this).queryParams;

  String get currentPath => Yeet.of(this).currentConfiguration;
}
