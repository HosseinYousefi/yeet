# yeet 👌


<p align="center">
<img src="https://raw.githubusercontent.com/HosseinYousefi/yeet/master/yeet.png" alt="yeet" />
</p>

---

A dank way to navigate.

[![Pub Version](https://img.shields.io/pub/v/yeet)](https://pub.dev/packages/yeet)
[![codecov](https://codecov.io/gh/HosseinYousefi/yeet/branch/master/graph/badge.svg?token=FNZIGVDYVW)](https://codecov.io/gh/HosseinYousefi/yeet)
[![yeet](https://github.com/HosseinYousefi/yeet/actions/workflows/yeet.yaml/badge.svg)](https://github.com/HosseinYousefi/yeet/actions/workflows/yeet.yaml)

---

## How to yeet?

0. Install latest version of yeet:

```yaml
dependencies:
  flutter:
    sdk: flutter
  yeet: ^0.4.5
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
      builder: (ctx) => UserView(int.parse(ctx.params['id']!)),
      children: [
        Yeet(
          path: 'posts',
          builder: (ctx) => PostsView(int.parse(ctx.params['id']!)),
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

## Migrating from 0.3.2 to 0.4.0

1. Parameters of `builder` have changed from `(params, queryParams)` to just a single `(context)`:

**Before:**
```dart
Yeet(
  path: '/user/:id'
  builder: (params, queryParams) => UserPage(id: params[id]!, edit: queryParams['edit'] ?? false)
)
```

**After:**
```dart
Yeet(
  path: '/user/:id'
  builder: (context) => UserPage(id: context.params[id]!, edit: context.queryParams['edit'] ?? false)
)
```

Now the page doesn't have to use the path or query parameters right away, and can always access it using the `BuildContext` withing the `build` function.

2. `Yeet.custom` has been removed. Instead you can use the `transition` parameter to configure the page transition. Transition is `YeetTransition.adaptive()` by default, which means that in iOS and macOS it's using `YeetTransition.cupertino()` and in other platforms `YeetTransition.material()`.

**Before:**
```dart
Yeet.custom(
  path: '/',
  transitionsBuilder: ...,
  opaque: ...,
  //...
)
```

**After:**
```dart
Yeet(
  path: '/',
  transiton: YeetTransition.custom(
    transitionsBuilder: ...,
    opaque: ...,
    //...
  ),
)
```