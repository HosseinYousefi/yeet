## 0.3.1
* Back/Close button works.

## 0.3.0
* **Breaking changes**
  * Custom transitions are now available using `Yeet.custom`.
  * Using `Yeet` is adaptive by default.
* Fixed `the issue with using relative paths when in root.

## 0.2.0
* **Breaking changes**
  * Removed `initialPath`.
* Fixed the problem with flutter web.`

## 0.1.1
* Now you can use custom transitions between pages.
* By default the transition is Cupertino on macOS/iOS and Material on android.

## 0.1.0

* **Breaking changes**
  * `builder` now gets two parameters: `params` like before and the added `query`, which is the query parameters of the path.
* Added support for paths like `../path/` with `.` and `..`.

## 0.0.4

* Fixed a bug in matching path patterns.
* Added more documentations.
* Now you can disable case sensitivity in path matching.

## 0.0.3

* Added BuildContext extension, now you can yeet by `context.yeet('/your/path');`.

## 0.0.2

* Yeet works now, check out the example.


## 0.0.1

* Yeet design prototype, not functional yet.
