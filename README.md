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
    childen: [
        Yeeter(
            path: '/login',
            view: LoginView(),
        ),
        Yeeter(
            children: [
                Yeeter(
                    path: '/',
                    view: (_) => HomeView(),
                ),
                Yeeter(
                    path: '/profile'
                    view: (_) => ProfileView(),
                    children: [
                        Yeeter(
                            path: 'posts', // going /profile/posts
                            view: (_) => PostsView(),
                        ),
                    ]
                ),
            ],
        ),
        Yeeter(
            path: r'/user/:id(\d+)',
            parsers: {
                'id': (id) => int.parse(id);
            },
            view: (params) => UserView(id: params['id']),
        ),
        Yeeter(
            path: '/404',
            view: NotFoundView(),
        ),
        Yeeter(
            path: r':_(.*)',
            redirectTo: '/404',
        ),
    ],
);
```