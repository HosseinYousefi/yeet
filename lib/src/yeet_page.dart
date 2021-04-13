import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yeet/src/yeet_transition.dart';

class YeetPage extends Page<dynamic> {
  final bool maintainState;
  final bool fullscreenDialog;
  final bool opaque;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final RouteTransitionsBuilder transitionsBuilder;
  final Widget child;

  YeetPage({
    LocalKey? key,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.transitionDuration = const Duration(milliseconds: 300),
    required this.transitionsBuilder,
    required this.child,
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      opaque: opaque,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
      pageBuilder: (context, animation, secondaryAnimation) => child,
    );
  }
}
