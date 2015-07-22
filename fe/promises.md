---
title: Promises
subtitle: "Or: callbacks are annoying"
template: article
tags: [code]
---

A **promise** is an abstraction over a callback that can help
simplify your asynchronous code (and thoughts). I wrote most of this
almost a year ago, back before promises were cool, but I still explain
them pretty often, and since I'm the best teacher ever, here's a blog post.
There isn't that much to them, and I'm going to keep it simple.

Promises turn this:

```coffeescript
# Imagine getSomeData and getSomeMoreData make an
# HTTP call or something.  You should recognize
# this common pattern.

getSomeData (err, firstResponse) ->
  if err
    doSomethingAboutTheError err
  else
    # Use data from firstResponse in another request
    getSomeMoreData firstResponse, (err, secondResponse) ->
      if err
        doSomethingAboutThisOtherError err
      else
        getStillMoreData ...
```

into this:

```coffeescript
# In this example, those data fetching functions are
# implemented with promises instead of callbacks.

getSomeData().then (response) ->
  getSomeMoreData response.factor
.then (response) ->
  getStillMoreData ...
.then null, (err) ->
  handleWhateverErrorThisMightBe err
```

#### things to note

* make unlimited sequential async function calls without indenting more than once
* chaining with `then` is semantically clear
* the first error cancels the rest of the chain
    * you can think of this as 'falling through' if you want
    * one function to handle them all

#### so what exactly is a promise?

A promise is an object that meets [the Promises/A+ spec](http://promises-aplus.github.io/promises-spec/).
It's really simple:

* A **promise** is anything with a `then` method which performs according to the spec.

#### how `then` works

`then` accepts two functions, the first for the success case and the second for the failure case.

```coffeescript
somePromise.then (value) ->
  console.log "Sucesss! #{value}"
, ->
  console.log "Failure! #{error}"
```

but because chaining is so awesome, some (I) prefer to write

```coffeescript
somePromise.then (value) ->
  console.log "Success! #{value}"
.then null, (error) ->
  console.log "Error! #{value}"
```

both because I think `.then null, (error)` is way better than `,` and because:

```coffeescript
somePromise.then (value) ->
  returnAnotherPromise(value)
.then (value) ->
  returnYetAnotherPromise(value)
.then (value) ->
  finishUp(value)
.then null, (error) ->
  handleAllTheErrors()
```

would be really ugly the comma way.

Though your implementation of Promises might contain far more functionality
than what I've shown, those are bonus features.  Any object with a compatible
`then` method is a Promise.  This simplicity makes them really easy to mock
in your tests. (You test your Javascript, right?)

### Converting old crappy callback functions to new shiny promise functions

old:
```coffeescript
# Wait for the specified time, fail half the time

slowOperation = (time, done) ->
  setTimeout ->
    if val = Math.floor(Math.random() * 10) % 2 == 1
      # odd, failure
      done val
    else
      # even, success
      done null, val
  , time

slowOperation (err, val) ->
  if err
    handleError err
  else
    handleSuccess val
```

So, conventionally we decided the callback would reserve its first parameter for an error, and if that parameter was
not null it would contain information about the error.  Otherwise, we should proceed with the 'return values'
beginning with the second parameter.

Instead, we return a promise.  In the success case, we resolve the promise with the value, and in the error case,
we reject the promise with the error.

new:
```coffeescript
slowOperation = (time) ->
  promise = new Promise()
  setTimeout ->
    if val = Math.floor(Math.random() * 10) % 2 == 1
      promise.reject val
    else
      promise.resolve val
  , time

  # Don't forget to return the promise
  promise

# Make sure to always handle errors.  (Seriously, always, not just in
Javascript or asynchronous situations)  Just like with callbacks,
# unhandled promise errors can lead to tricky bugs.

slowOperation().then (val) ->
  handleSuccess val
.then null, (err) ->
  handleError err
```

I like to use this little helper:

```coffeescript
# You can steal this; I like to call it `pFun` for short
PromiseFunction = (fn) ->
  (args...) ->
    promise = new Promise
    fn.call @, promise.resolve, promise.reject, args...

# I usually rename `resolve/reject` to `done/fail`
slowOperation = PromiseFunction (resolve, reject, time) ->
  setTimeout ->
    if val = Math.floor(Math.random() * 10) % 2 == 1
      resolve val
    else
      reject val
  , time
```

so I don't have to waste an indent or remember to return the promise.

That's it.  If you're still confused, it's because this stuff is confusing..
You'll have to play with these examples yourself before it will click.  Have
fun!
