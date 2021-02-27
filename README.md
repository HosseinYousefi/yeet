# yeet 👌


<p align="center">
<img src="https://raw.githubusercontent.com/HosseinYousefi/yeet/master/yeet.png" alt="yeet" />
</p>

---

A dank way to navigate.

---

**Still experimental!**

## How to yeet?

1. Define your yeet:

```dart
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
```

2. Turn your `MaterialApp` into `MaterialApp.router`.

```dart
return MaterialApp.router(
  routeInformationParser: YeetInformationParser(),
  routerDelegate: YeeterDelegate(yeet: yeet),
);
```

3. Set new paths.

```dart
Router.of(context).routerDelegate.setNewRoutePath(
    RouteInformation(location: '/your/new/path'));
```

4. And yeet back.

```dart
Router.of(context).routerDelegate.popRoute();
```

5. Enjoy!