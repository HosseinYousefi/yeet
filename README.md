# yeet 👌


<p align="center">
<img src="https://raw.githubusercontent.com/HosseinYousefi/yeet/master/yeet.png" alt="yeet" />
</p>

---

A dank way to navigate.

[![Pub Version](https://img.shields.io/pub/v/yeet)](https://pub.dev/packages/yeet/versions/0.0.4)

---

**Still experimental!**

## How to yeet?

0. Install latest version of yeet:

```yaml
dependencies:
  flutter:
    sdk: flutter
  yeet: ^0.0.3
```

1. Define your yeets:

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

2. Turn your `MaterialApp` into `MaterialApp.router` and add the following arguments.

```dart
return MaterialApp.router(
  routeInformationParser: YeetInformationParser(),
  routerDelegate: YeeterDelegate(yeet: yeet),
);
```

3. Set new paths.

```dart
context.yeet('/your/new/path');
context.yeet('can/be/relative');
```

4. And pop.

```dart
context.yeet();
```

5. Enjoy!

6. Missing a feature? Have a suggestion? Found a bug? [Open an issue.](https://github.com/HosseinYousefi/yeet/issues) Thanks!