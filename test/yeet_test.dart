import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yeet/src/yeet_transition.dart';
import 'package:yeet/yeet.dart';

void main() {
  final yeet = Yeet(
    children: [
      Yeet(
        path: '/dialog',
        builder: (context) => ElevatedButton(
          onPressed: () => context.yeet(),
          child: Text('Close Dialog'),
        ),
      ),
      Yeet(
        path: '/',
        builder: (context) => Column(
          children: [
            Text('/'),
            ElevatedButton(
              onPressed: () {
                context.push('/dialog');
              },
              child: Text('Show Dialog'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/dialog');
              },
              child: Text('Yeet Dialog on Top'),
            ),
            ElevatedButton(
              onPressed: () {
                context.yeet('/a');
              },
              child: Text('Complete path'),
            ),
            ElevatedButton(
              onPressed: () {
                context.yeet('b');
              },
              child: Text('Relative path'),
            ),
            ElevatedButton(
              onPressed: () {
                context.yeet('/c');
              },
              child: Text('Relative path in yeet tree'),
            ),
            ElevatedButton(
              onPressed: () {
                context.yeet('/d/hello/f');
              },
              child: Text('Path param'),
            ),
            ElevatedButton(
              onPressed: () {
                context.yeet('/d/hello/f/g?a=3&b=5');
              },
              child: Text('Query param'),
            ),
          ],
        ),
        children: [
          Yeet(
            path: '/a',
            builder: (_) => Text('a'),
          ),
          Yeet(
            path: '/b',
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  Text('b'),
                  ElevatedButton(
                    onPressed: () => context.yeet('/b/h'),
                    child: Text('h'),
                  ),
                ],
              ),
            ),
            children: [
              Yeet(
                path: 'h',
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text('H')),
                  body: Text('h'),
                ),
              )
            ],
          ),
          Yeet(
            path: 'c',
            builder: (_) => Text('c'),
          ),
          Yeet(
            path: 'd/:any/f',
            builder: (context) => Text(context.params['any']!),
            children: [
              Yeet(
                // Building with no animation
                transition: YeetTransition.custom(
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) => child,
                ),
                path: 'g',
                builder: (context) => Column(
                  children: [
                    Text(
                        '${context.queryParams['a']!} ${context.queryParams['b']!}'),
                    ElevatedButton(
                      onPressed: context.yeet,
                      child: Text('back'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.yeet('../../../../c'),
                      child: Text('relative c'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  testWidgets('initial path is /', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));

    final finder = find.text('/');

    expect(finder, findsOneWidget);
  });

  testWidgets('yeeting to /a works', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Complete path'));
    await tester.pumpAndSettle();

    final finder = find.text('a');

    expect(finder, findsOneWidget);
  });

  testWidgets('relative yeeting to b works', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Relative path'));
    await tester.pumpAndSettle();

    final finder = find.text('b');

    expect(finder, findsOneWidget);
  });

  testWidgets('yeeting to a relative path on yeet tree', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester
        .tap(find.widgetWithText(ElevatedButton, 'Relative path in yeet tree'));
    await tester.pumpAndSettle();

    final finder = find.text('c');

    expect(finder, findsOneWidget);
  });

  testWidgets('yeet with path parameter', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Path param'));
    await tester.pumpAndSettle();

    final finder = find.text('hello');

    expect(finder, findsOneWidget);
  });

  testWidgets('yeet (pop)', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Query param'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'back'));
    await tester.pumpAndSettle();

    final finder = find.text('hello');

    expect(finder, findsOneWidget);
  });

  testWidgets('query parameters', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Query param'));
    await tester.pumpAndSettle();

    final finder = find.text('3 5');

    expect(finder, findsOneWidget);
  });

  testWidgets('yeet using ..', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Query param'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'relative c'));
    await tester.pumpAndSettle();

    final finder = find.text('c');

    expect(finder, findsOneWidget);
  });

  testWidgets('app bar back button works', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Relative path'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'h'));
    await tester.pumpAndSettle();

    expect(find.text('h'), findsOneWidget);
    final backButton = find.byType(BackButton);
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(find.text('b'), findsOneWidget);
  });

  testWidgets('push', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Close Dialog'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Close Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('/'), findsOneWidget);
  });

  testWidgets('yeetOnTop', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Yeet Dialog on Top'));
    await tester.pumpAndSettle();

    expect(find.text('Close Dialog'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Close Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('/'), findsOneWidget);
  });
}
