import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import 'yeet.dart';

class YeeterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier {
  final Yeet yeet;
  RouteInformation routeInformation = RouteInformation(location: '/');

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  YeeterDelegate({
    required this.yeet,
  });

  List<Page>? _dfs(
      Yeet node, String path, int matchedTill, Map<String, String> params) {
    print('currently at ${node.path}');
    print(path);
    print(matchedTill);
    final pages = <Page>[];
    if (node.regExp != null) {
      final isRootPath = node.path!.startsWith('/');
      // If it's a relative path we continue from matchedTill.
      final startingFrom = isRootPath ? 0 : matchedTill;
      final match = node.regExp!.matchAsPrefix(path, startingFrom);
      if (match != null) {
        params.addAll(extract(node.parameters, match));
        if (node.builder != null) {
          pages.add(MaterialPage(
            key: ValueKey(path.substring(startingFrom, match.end)),
            child: node.builder!(params),
          ));
        }
        if (match.end == node.path!.length) {
          // The matching is final.
          return pages;
        }
        matchedTill = match.end;
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

  @override
  Widget build(Object context) {
    return Navigator(
      key: _navigatorKey,
      pages: _dfs(
        yeet,
        Uri.decodeComponent(routeInformation.location!),
        1,
        {},
      )!,
      observers: [HeroController()],
    );
  }

  @override
  Future<bool> popRoute() {
    throw UnimplementedError();
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) async {
    routeInformation = configuration;
    notifyListeners();
  }

  @override
  RouteInformation? get currentConfiguration => routeInformation;
}
