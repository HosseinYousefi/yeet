import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yeet/yeet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final yeet = Yeet(
      children: [
        Yeet(
          path: '/',
          builder: (_) => HomeView(),
        ),
        Yeet(
          path: r'/user/:id(\d+)',
          builder: (params) => UserView(int.parse(params['id']!)),
          children: [
            Yeet(
              path: 'posts',
              builder: (params) => PostsView(int.parse(params['id']!)),
            )
          ],
        ),
        Yeet(
          path: ':_(.*)',
          builder: (_) => NotFoundView(),
        ),
      ],
    );
    return MaterialApp.router(
      routeInformationParser: YeetInformationParser(),
      routerDelegate: YeeterDelegate(yeet: yeet),
    );
  }
}

class NotFoundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}

class UserView extends StatelessWidget {
  final int id;

  UserView(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User #$id')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Router.of(context).routerDelegate.setNewRoutePath(
                    RouteInformation(location: '/user/$id/posts'));
              },
              child: Text('Posts'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Router.of(context)
                    .routerDelegate
                    .setNewRoutePath(RouteInformation(location: '/'));
              },
              child: Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class PostsView extends StatelessWidget {
  final int id;

  PostsView(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts of user #$id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Router.of(context).routerDelegate.popRoute();
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomeView')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Router.of(context).routerDelegate.setNewRoutePath(
                RouteInformation(location: '/user/${Random().nextInt(10)}'));
          },
          child: Text('Random User'),
        ),
      ),
    );
  }
}
