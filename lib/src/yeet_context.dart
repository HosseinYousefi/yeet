import 'package:flutter/widgets.dart';

import '../yeet.dart';

class YeetContext {
  final Map<String, String> params;
  final Map<String, String> queryParams;
  final YeeterDelegate delegate;
  final Widget? child;
  final int? selectedIndex;

  YeetContext({
    required this.params,
    required this.queryParams,
    required this.delegate,
    required this.child,
    required this.selectedIndex,
  });

  void yeet([String? path]) {
    delegate.yeet(path);
  }

  void yeetOnTop(String path) {
    delegate.yeetOnTop(path);
  }

  void push(String path) {
    delegate.push(path);
  }

  void changePath(String path) {
    delegate.changePath(path);
  }
}
