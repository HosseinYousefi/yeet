import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:yeet/src/yeet_page.dart';

import 'yeet.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
final _heroController = HeroController();
List<Page> _pages = [];

/// Put this as your routerDelegate in [MaterialApp.router].

class YeeterDelegate extends RouterDelegate<String> with ChangeNotifier {
  final Yeet _yeet;

  YeeterDelegate({
    required Yeet yeet,
  }) : _yeet = yeet {
    this.yeet(currentConfiguration);
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
        final isFinal = matchedTill + match.end == path.length;
        params.addAll(extract(node.parameters, match));
        if (node.builder != null) {
          final queryPath = Uri(queryParameters: query).query;
          final key = ValueKey(path.substring(0, matchedTill + match.end) +
              (isFinal && queryPath.isNotEmpty ? '?$queryPath' : ''));
          final child = node.builder!(params, query);
          if (node.transitionsBuilder == null) {
            if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
              pages.add(CupertinoPage(
                key: key,
                child: child,
                fullscreenDialog: node.fullscreenDialog,
                maintainState: node.maintainState,
              ));
            } else {
              pages.add(MaterialPage(
                key: key,
                child: child,
                fullscreenDialog: node.fullscreenDialog,
                maintainState: node.maintainState,
              ));
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
    if (_pages.isNotEmpty) {
      return Navigator(
        key: _navigatorKey,
        pages: _pages,
        observers: [_heroController],
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
      final location = Uri.parse(currentConfiguration).path;
      yeet(location + (location != '/' ? '/' : '') + path);
    }
  }

  @override
  Future<bool> popRoute() async {
    return Future.sync(() {
      if (_pages.length == 1) {
        return false;
      }
      yeet((_pages[_pages.length - 2].key as ValueKey).value);
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
  String get currentConfiguration =>
      _pages.isNotEmpty ? (_pages.last.key as ValueKey).value : '/';
}
