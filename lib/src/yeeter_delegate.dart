import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import 'yeet.dart';

class YeeterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier {
  final Yeet _yeet;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  YeeterDelegate({
    required Yeet yeet,
    String initialPath = '/',
  }) : _yeet = yeet {
    setNewRoutePath(RouteInformation(location: initialPath));
  }

  List<Page>? _dfs(
      Yeet node, String path, int matchedTill, Map<String, String> params) {
    final pages = <Page>[];
    if (node.regExp != null) {
      final isRootPath = node.path!.startsWith('/');
      if (isRootPath) matchedTill = 0;
      final match = node.regExp!.matchAsPrefix(path.substring(matchedTill));
      if (match != null) {
        params.addAll(extract(node.parameters, match));
        if (node.builder != null) {
          pages.add(MaterialPage(
            key: ValueKey(path.substring(0, matchedTill + match.end)),
            child: node.builder!(params),
          ));
        }
        if (matchedTill + match.end == path.length) {
          // The matching is final.
          return pages;
        }
        matchedTill += match.end + 1;
      }
    }
    if (node.children != null) {
      for (int childIndex = 0;
          childIndex < node.children!.length;
          ++childIndex) {
        final childList =
            _dfs(node.children![childIndex], path, matchedTill, params);
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

  List<Page> _pages = [];

  @override
  Widget build(Object context) {
    return Navigator(
      key: _navigatorKey,
      pages: _pages,
      observers: [HeroController()],
      onPopPage: (route, result) => false,
    );
  }

  void yeet([String? path]) {
    if (path == null) {
      if (_pages.length == 1) {
        return;
      }
      setNewRoutePath(RouteInformation(
          location: (_pages[_pages.length - 2].key as ValueKey).value));
      return;
    }
    if (path.startsWith('/')) {
      _pages = _dfs(
        _yeet,
        Uri.decodeComponent(path),
        0,
        {},
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
