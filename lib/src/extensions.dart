import 'package:flutter/widgets.dart';

import 'yeet.dart';

extension YeetContext on BuildContext {
  void yeet([String? path]) {
    Yeet.of(this).yeet(path);
  }
}
