import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:yeet/src/yeet_page.dart';

import 'yeet.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

/// Put this as your routerDelegate in [MaterialApp.router].
class YeeterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier {
  final Yeet _yeet;
  List<Page> _pages;

  YeeterDelegate({
    required Yeet yeet,
    String initialPath = '/',
  })  : _yeet = yeet,
        _pages = [] {
    setNewRoutePath(RouteInformation(location: initialPath));
  }

  List<Page>? _dfs(
    Yeet node,
    String path,
    int matchedTill,
    Map<String, String> params,
    Map<String, String> query,
  ) {
    final pages = <Page>[];

    if (node.regExp != null) {
      // Handling relative and non-relative paths correctly
      final isRootPath = node.path!.startsWith('/');
      if (isRootPath) matchedTill = 0;
      final match = node.regExp!.matchAsPrefix(path.substring(matchedTill));

      if (match != null) {
        params.addAll(extract(node.parameters, match));
        if (node.builder != null) {
          final key = ValueKey(path.substring(0, matchedTill + match.end));
          final child = node.builder!(params, query);
          if (node.transitionsBuilder == null) {
            if (Platform.isIOS || Platform.isMacOS) {
              pages.add(CupertinoPage(
                  key: key,
                  child: child,
                  fullscreenDialog: node.fullscreenDialog,
                  maintainState: node.maintainState));
            } else {
              pages.add(MaterialPage(
                  key: key,
                  child: child,
                  fullscreenDialog: node.fullscreenDialog,
                  maintainState: node.maintainState));
            }
          } else {
            pages.add(YeetPage(
              key: key,
              barrierColor: node.barrierColor,
              barrierDismissible: node.barrierDismissible,
              barrierLabel: node.barrierLabel,
              fullscreenDialog: node.fullscreenDialog,
              maintainState: node.maintainState,
              opaque: node.opaque,
              reverseTransitionDuration: node.reverseTransitionDuration,
              transitionDuration: node.transitionDuration,
              transitionsBuilder: node.transitionsBuilder!,
              child: child,
            ));
          }
        }
        if (matchedTill + match.end == path.length) {
          // The matching is final.
          return pages;
        }
        if (path[matchedTill + match.end] == '/') {
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
            _dfs(node.children![childIndex], path, matchedTill, params, query);
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
    return Navigator(
      key: _navigatorKey,
      pages: _pages,
      observers: [HeroController()],
      onPopPage: (route, result) => false,
    );
  }

  /// Navigates to another path. If no arguments are given, it pops the top page.
  void yeet([String? path]) {
    if (path == null) {
      if (_pages.length == 1) {
        return;
      }
      yeet((_pages[_pages.length - 2].key as ValueKey).value);
      return;
    }
    final uri = Uri.parse(path);
    if (path.startsWith('/')) {
      _pages = _dfs(
        _yeet,
        uri.path,
        0,
        {},
        uri.queryParameters,
      )!;
      notifyListeners();
    } else {
      yeet(currentConfiguration!.location! + '/' + path);
    }
  }

  @override
  Future<bool> popRoute() async {
    if (_pages.length == 1) {
      return false;
    }
    await setNewRoutePath(RouteInformation(
        location: (_pages[_pages.length - 2].key as ValueKey).value));
    return true;
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) {
    return Future.sync(() {
      yeet(configuration.location!);
    });
  }

  @override
  RouteInformation? get currentConfiguration =>
      RouteInformation(location: (_pages.last.key as ValueKey).value);
}
