import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yeet/yeet.dart';

void main() {
  final yeet = Yeet(
    children: [
      Yeet(
        path: '/',
        builder: (_, __) => Builder(
          builder: (context) {
            return Column(
              children: [
                Text('/'),
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
            );
          },
        ),
        children: [
          Yeet(
            path: '/a',
            builder: (_, __) => Text('a'),
          ),
          Yeet(
            path: '/b',
            builder: (_, __) => Text('b'),
          ),
          Yeet(
            path: 'c',
            builder: (_, __) => Text('c'),
          ),
          Yeet(
            path: 'd/:any/f',
            builder: (params, __) => Text(params['any']!),
            children: [
              Yeet(
                path: 'g',
                builder: (_, qParams) => Builder(
                  builder: (context) => Column(
                    children: [
                      Text('${qParams['a']!} ${qParams['b']!}'),
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
}
