import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'extended_page.freezed.dart';

@freezed
abstract class ExtendedPage with _$ExtendedPage {
  const factory ExtendedPage({
    required Page page,
    required String path,
  }) = _ExtendedPage;
}
