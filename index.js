var EventEmitter = require("events");
var util = require("util");
var slice = Array.prototype.slice;
var P = (function (p) {
	return (p == null) ? require("bluebird") : p;
})(Promise);

function EventsAsPromised () {
	EventEmitter.apply(this);
}
util.inherits(EventsAsPromised, EventEmitter);
Object.keys(EventEmitter.prototype).forEach(function (key) {
	if (key != "emit") {
		EventsAsPromised.prototype[key] = EventEmitter.prototype[key];
	}
});

console.dir(EventsAsPromised.prototype);
EventsAsPromised.prototype.emit = function (event) {
	var that = this;
	var args = slice.call(arguments, 1);
	return this.listeners(event).reduce(function (prev, listener) {
		return prev.then(function () {
			try {
				return P.resolve(listener.apply(that, args));
			}
			catch (err) {
				return P.reject(err)
			}
		});
	}, P.resolve(null));
}

EventsAsPromised.EventEmitter = EventsAsPromised;

module.exports = EventsAsPromised;
