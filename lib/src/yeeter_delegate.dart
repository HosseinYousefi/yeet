import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:yeet/src/yeet_page.dart';

import 'extended_page.dart';
import 'yeet.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
final _heroController = HeroController();
List<ExtendedPage> _pages = [];

/// Put this as your routerDelegate in [MaterialApp.router].

class YeeterDelegate extends RouterDelegate<String> with ChangeNotifier {
  final Yeet _yeet;

  Map<String, String> _queryParams = {};
  Map<String, String> _params = {};

  Map<String, String> get params => Map.unmodifiable(_params);
  Map<String, String> get queryParams => Map.unmodifiable(_queryParams);

  final List<NavigatorObserver> observers;

  YeeterDelegate({
    required Yeet yeet,
    this.observers = const [],
  }) : _yeet = yeet {
    this.yeet(currentConfiguration);
  }

  static Widget _makeChild(Yeet node) {
    return Builder(builder: node.builder!);
  }

  static ExtendedPage _makePage(String path, Yeet node,
      [bool uniqueKey = false]) {
    final child = _makeChild(node);
    return ExtendedPage(
      page: node.transition.when(
        adaptive: () => (UniversalPlatform.isIOS || UniversalPlatform.isMacOS)
            ? CupertinoPage(
                name: path,
                key: uniqueKey ? UniqueKey() : ValueKey(path),
                child: child,
                fullscreenDialog: node.fullscreenDialog,
                maintainState: node.maintainState,
              )
            : MaterialPage(
                name: path,
                key: uniqueKey ? UniqueKey() : ValueKey(path),
                child: child,
                fullscreenDialog: node.fullscreenDialog,
                maintainState: node.maintainState,
              ),
        material: () => MaterialPage(
          name: path,
          key: uniqueKey ? UniqueKey() : ValueKey(path),
          child: child,
          fullscreenDialog: node.fullscreenDialog,
          maintainState: node.maintainState,
        ),
        cupertino: () => CupertinoPage(
          name: path,
          key: uniqueKey ? UniqueKey() : ValueKey(path),
          child: child,
          fullscreenDialog: node.fullscreenDialog,
          maintainState: node.maintainState,
        ),
        custom: (
          transitionsBuilder,
          opaque,
          barrierDismissible,
          reverseTransitionDuration,
          transitionDuration,
          barrierColor,
          barrierLabel,
        ) =>
            YeetPage(
          name: path,
          key: uniqueKey ? UniqueKey() : ValueKey(path),
          transitionsBuilder: transitionsBuilder,
          fullscreenDialog: node.fullscreenDialog,
          maintainState: node.maintainState,
          opaque: opaque,
          barrierDismissible: barrierDismissible,
          reverseTransitionDuration: reverseTransitionDuration,
          transitionDuration: transitionDuration,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          child: child,
        ),
      ),
      path: path,
    );
  }

  List<ExtendedPage>? _dfs(
    Yeet node,
    String path,
    int matchedTill, [
    bool uniqueKey = false,
  ]) {
    final pages = <ExtendedPage>[];
    if (node.regExp != null) {
      // Handling relative and non-relative paths correctly
      final isRootPath = node.path!.startsWith('/');
      if (isRootPath) matchedTill = 0;
      final match = node.regExp!.matchAsPrefix(path.substring(matchedTill));
      if (match != null) {
        final isFinal = matchedTill + match.end == path.length;
        _params.addAll(extract(node.parameters, match));
        if (node.builder != null) {
          final queryPath = Uri(queryParameters: _queryParams).query;
          final pagePath = path.substring(0, matchedTill + match.end) +
              (isFinal && queryPath.isNotEmpty ? '?$queryPath' : '');
          pages.add(_makePage(pagePath, node, uniqueKey));
        }
        if (isFinal) {
          // The matching is final.
          return pages;
        }
        if (path[matchedTill + match.end - 1] == '/') {
          matchedTill += match.end;
        } else if (path[matchedTill + match.end] == '/') {
          matchedTill += match.end + 1;
        } else {
          matchedTill = 0;
        }
      }
    }
    if (node.children != null) {
      for (int childIndex = 0;
          childIndex < node.children!.length;
          ++childIndex) {
        final childList =
            _dfs(node.children![childIndex], path, matchedTill, uniqueKey);
        if (childList != null) {
          // We found a match, we can return.
          pages.addAll(childList);
          return pages;
        }
      }
    }
    // No match found in this subtree.
    return null;
  }

  @override
  Widget build(Object context) {
    if (_pages.isNotEmpty) {
      return Navigator(
        key: _navigatorKey,
        pages: _pages.map((e) => e.page).toList(),
        observers: [_heroController, ...observers],
        onPopPage: (route, result) {
          yeet();
          return false;
        },
      );
    }
    return Container();
  }

  /// Navigates to another path. If no arguments are given, it pops the top page.
  void yeet([String? path]) {
    _params = {};
    _queryParams = {};
    if (path == null) {
      if (_pages.length == 1) {
        return;
      }
      _pages.removeLast();
      notifyListeners();
      return;
    }
    final uri = Uri.parse(path);
    _queryParams = uri.queryParameters;
    if (path.startsWith('/')) {
      _pages = _dfs(
        _yeet,
        uri.path,
        0,
      )!;
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      yeet(location + (location != '/' ? '/' : '') + path);
    }
  }

  void yeetOnTop(String path) {
    final uri = Uri.parse(path);
    _queryParams = {..._queryParams, ...uri.queryParameters};
    if (path.startsWith('/')) {
      final newPages = _dfs(
        _yeet,
        uri.path,
        0,
      )!;
      _pages = [
        ..._pages,
        ...newPages.where(
            (element) => _pages.where((e) => e.path == element.path).isEmpty),
      ];
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      yeetOnTop(location + (location != '/' ? '/' : '') + path);
    }
  }

  void push(String path) {
    final uri = Uri.parse(path);
    _queryParams = {..._queryParams, ...uri.queryParameters};
    if (path.startsWith('/')) {
      final newPages = _dfs(
        _yeet,
        uri.path,
        0,
        true,
      )!;
      _pages = [
        ..._pages,
        newPages.last,
      ];
      notifyListeners();
    } else {
      final location = Uri.parse(currentConfiguration).path;
      push(location + (location != '/' ? '/' : '') + path);
    }
  }

  void changePath(String path) {
    _pages[_pages.length - 1] = _pages.last.copyWith(path: path);
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async {
    return Future.sync(() {
      if (_pages.length == 1) {
        return false;
      }
      yeet(_pages[_pages.length - 2].path);
      return true;
    });
  }

  @override
  Future<void> setNewRoutePath(String path) {
    return Future.sync(() {
      yeet(path);
    });
  }

  @override
  String get currentConfiguration => _pages.isNotEmpty ? _pages.last.path : '/';
}
