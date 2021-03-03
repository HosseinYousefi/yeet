import 'package:flutter/widgets.dart';

import 'yeet.dart';

extension YeetContext on BuildContext {
  /// Navigates to another path. If no arguments are given, it pops the top page.
  void yeet([String? path]) {
    Yeet.of(this).yeet(path);
  }
}
