# yeet 👌


<p align="center">
<img src="https://raw.githubusercontent.com/HosseinYousefi/yeet/master/yeet.png" alt="yeet" />
</p>

---

A dank way to navigate.

---

I'm still working on the architecture so nothing works yet, but here's what it should look like.

Example:

```dart
Yeeter(
  children: [
    Yeeter(
      path: '/login',
      view: (_, __) => LoginView(),
    ),
    Yeeter(
      children: [
        Yeeter(
          path: '/',
          view: (_, __) => HomeView(),
        ),
        Yeeter(
          path: '/profile',
          view: (_, __) => ProfileView(),
          children: [
            Yeeter(
              path: 'posts', // going /profile/posts
              view: (_, __) => PostsView(),
            ),
          ],
        ),
      ],
    ),
    Yeeter(
      path: r'/user/:id(\d+)',
      view: (pathParams, queryParams) =>
          UserView(id: int.parse(pathParams['id'])),
    ),
    Yeeter(
      path: '/404',
      view: (_, __) => NotFoundView(),
    ),
    Yeeter(
      path: r':_(.*)',
      redirectTo: '/404',
    ),
  ],
);
```

You can push and pop programmatically just like `cd`.

```dart
Yeet.of(context).yeet('..'); // pops
Yeet.of(context).yeet('/user/17'); // pushes /user/17
Yeet.of(context).yeet('../16'); // goes to /user/16
```
