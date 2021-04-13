import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'yeet_transition.freezed.dart';

@freezed
abstract class YeetTransition with _$YeetTransition {
  /// Switches between [YeetTransition.cupertino] and [YeetTransition.material] depending
  /// on the operating system (cupertino is used for macOS and iOS only).
  const factory YeetTransition.adaptive() = _Adaptive;

  /// Material design default page transition
  const factory YeetTransition.material() = _Material;

  /// Cupertino default page transition used in iOS and macOS
  const factory YeetTransition.cupertino() = _Cupertino;

  /// Custom page transition
  const factory YeetTransition.custom({
    required RouteTransitionsBuilder transitionsBuilder,
    @Default(true) bool opaque,
    @Default(false) bool barrierDismissible,
    @Default(const Duration(milliseconds: 300))
        Duration reverseTransitionDuration,
    @Default(const Duration(milliseconds: 300)) Duration transitionDuration,
    Color? barrierColor,
    String? barrierLabel,
  }) = _Custom;
}
