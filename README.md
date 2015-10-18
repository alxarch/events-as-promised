# Events as promised

An `EventEmitter` that's full of `Promise`!

Augment `EventEmitter` to handle asynchronous listeners by using
a promise-returning `emit()` method. All listeners are executed serially,
casting the return value to a `Promise` via `Promise.resolve()`.
If a promise is rejected, or an error is thrown when executing the listener,
the iteration *stops* and the resulting promise is rejected.

## Usage

```js
var Events = require("events-as-promised");
var events = new Events();
events.on("foo", function (bar, baz) {
	console.log("First listener");
});
events.on("foo", function (bar, baz) {
	console.log("Second listener");
	return Promise.resolve();
});
events.on("foo", function (bar, baz) {
	console.log("Third listener");
	return Promise.reject(new Error("Foo error"));
});
events.on("foo", function (bar, baz) {
	console.log("Fourth listener");
});

events.emit("foo").catch(function (err) {
	console.error(err.message);
});

// Will print
// First listener
// Second listener
// Third listener
// Foo error
```

## No native `Promise`

Falls back to [`bluebird`](https://github.com/petkaantonov/bluebird)
if no native `Promise` is found.
