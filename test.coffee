assert = require "assert"
describe "Events", ->
	EventEmitter = require __dirname

	it "Handles promise-returning listeners", ->
		events = new EventEmitter()
		reason = new Error "Some error"
		listener_1 = no
		listener_2 = no
		events.on "test", -> listener_1 = yes
		events.on "test", -> Promise.resolve listener_2 = yes
		events.on "test", -> Promise.reject reason
		events.on "test", -> error = null
		error = null
		try
			p = events.emit "test"
		catch err
			console.error err.stack

		p?.catch (err) -> error = err
		.then ->
			assert error is reason
			assert listener_1 is yes
			assert listener_2 is yes

	it "Can be inheritted", ->
		class Test extends EventEmitter

		events = new Test()

		reason = new Error "Some error"
		listener_1 = no
		listener_2 = no
		events.on "test", -> listener_1 = yes
		events.on "test", -> Promise.resolve listener_2 = yes
		events.on "test", -> Promise.reject reason
		events.on "test", -> error = null
		error = null
		events.emit "test"
		.catch (err) -> error = err
		.then ->
			assert error is reason
			assert listener_1 is yes
			assert listener_2 is yes

	it "Can be mixed in with merge-descriptors", ->
		# This is how express mixins events on app
		mixin = require "merge-descriptors"
		events = {}
		mixin events, EventEmitter::, no

		reason = new Error "Some error"
		listener_1 = no
		listener_2 = no
		events.on "test", -> listener_1 = yes
		events.on "test", -> Promise.resolve listener_2 = yes
		events.on "test", -> Promise.reject reason
		events.on "test", -> error = null
		error = null
		events.emit "test"
		.catch (err) -> error = err
		.then ->
			assert error is reason
			assert listener_1 is yes
			assert listener_2 is yes
