// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'extended_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ExtendedPageTearOff {
  const _$ExtendedPageTearOff();

  _ExtendedPage call({required Page<dynamic> page, required String path}) {
    return _ExtendedPage(
      page: page,
      path: path,
    );
  }
}

/// @nodoc
const $ExtendedPage = _$ExtendedPageTearOff();

/// @nodoc
mixin _$ExtendedPage {
  Page<dynamic> get page => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExtendedPageCopyWith<ExtendedPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtendedPageCopyWith<$Res> {
  factory $ExtendedPageCopyWith(
          ExtendedPage value, $Res Function(ExtendedPage) then) =
      _$ExtendedPageCopyWithImpl<$Res>;
  $Res call({Page<dynamic> page, String path});
}

/// @nodoc
class _$ExtendedPageCopyWithImpl<$Res> implements $ExtendedPageCopyWith<$Res> {
  _$ExtendedPageCopyWithImpl(this._value, this._then);

  final ExtendedPage _value;
  // ignore: unused_field
  final $Res Function(ExtendedPage) _then;

  @override
  $Res call({
    Object? page = freezed,
    Object? path = freezed,
  }) {
    return _then(_value.copyWith(
      page: page == freezed
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as Page<dynamic>,
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$ExtendedPageCopyWith<$Res>
    implements $ExtendedPageCopyWith<$Res> {
  factory _$ExtendedPageCopyWith(
          _ExtendedPage value, $Res Function(_ExtendedPage) then) =
      __$ExtendedPageCopyWithImpl<$Res>;
  @override
  $Res call({Page<dynamic> page, String path});
}

/// @nodoc
class __$ExtendedPageCopyWithImpl<$Res> extends _$ExtendedPageCopyWithImpl<$Res>
    implements _$ExtendedPageCopyWith<$Res> {
  __$ExtendedPageCopyWithImpl(
      _ExtendedPage _value, $Res Function(_ExtendedPage) _then)
      : super(_value, (v) => _then(v as _ExtendedPage));

  @override
  _ExtendedPage get _value => super._value as _ExtendedPage;

  @override
  $Res call({
    Object? page = freezed,
    Object? path = freezed,
  }) {
    return _then(_ExtendedPage(
      page: page == freezed
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as Page<dynamic>,
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
class _$_ExtendedPage implements _ExtendedPage {
  const _$_ExtendedPage({required this.page, required this.path});

  @override
  final Page<dynamic> page;
  @override
  final String path;

  @override
  String toString() {
    return 'ExtendedPage(page: $page, path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ExtendedPage &&
            (identical(other.page, page) ||
                const DeepCollectionEquality().equals(other.page, page)) &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(page) ^
      const DeepCollectionEquality().hash(path);

  @JsonKey(ignore: true)
  @override
  _$ExtendedPageCopyWith<_ExtendedPage> get copyWith =>
      __$ExtendedPageCopyWithImpl<_ExtendedPage>(this, _$identity);
}

abstract class _ExtendedPage implements ExtendedPage {
  const factory _ExtendedPage(
      {required Page<dynamic> page, required String path}) = _$_ExtendedPage;

  @override
  Page<dynamic> get page => throw _privateConstructorUsedError;
  @override
  String get path => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ExtendedPageCopyWith<_ExtendedPage> get copyWith =>
      throw _privateConstructorUsedError;
}
