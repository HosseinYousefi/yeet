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
          builder: (context) => UserView(int.parse(context.params['id']!)),
          transition: YeetTransition.custom(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          children: [
            Yeet(
              path: 'posts',
              builder: (context) => PostsView(int.parse(context.params['id']!)),
            )
          ],
        ),
        Yeet(
          path: '/dialog',
          builder: (_) => DialogView(),
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

class DialogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dialog')),
      body: Center(
        child: Text('Dialog!'),
      ),
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
              onPressed: () => context.yeet('posts'),
              child: Text('Posts'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.yeet('/'),
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
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => context.yeet(),
              child: Text('Back'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => context.yeetOnTop('/dialog'),
              child: Text('Show Dialog'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => context.changePath('/something'),
              child: Text('Change path'),
            ),
          ),
        ],
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
          onPressed: () => context.yeet('user/${Random().nextInt(10)}'),
          child: Text('Random User'),
        ),
      ),
    );
  }
}
