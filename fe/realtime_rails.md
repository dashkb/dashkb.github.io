---
title: Realtime Rails with Redis and Node
template: article
tags: [code, rails, node]
---

So you want to add some realtime features to your Rails app.  Chat, perhaps, or
maybe you're making a fun game.  Whatever you're building, you heard somewhere
that you should use [Node.js](http://nodejs.org/) to do it.  I'm not saying you
heard right, but I will show you how and leave the philosophizing to the
philosophizers.

#### Install a Brain

We'll use [Redis](http://redis.io) as our backend realtime-things-coordinator (technical
term).  You'll need a service object like this in your Rails application:

```ruby
class Events
  def self.publish(channel, message)
    REDIS.publish channel, message.to_json
  end
end
```

Though it's little more than a wrapper around
[`Redis#publish`](http://rdoc.info/github/redis/redis-rb/Redis#publish-instance_method),
(if you aren't familiar with Redis' publish/subscribe API, [go get
familiarized](http://redis.io/topics/pubsub)) taking this early opportunity to
abstract away our Redis usage might save us loads of future-work and costs
little.  .  We can pass any object that responds to `#to_json` as the message.
Let's see what this might look like from a controller action.

```ruby
class ThingController < ApplicationController
  def update
    Events.publish 'thing', {
      user_id: current_user.id,
      contents: params[:thing][:contents]
    }

    respond_ok
  end
end
```

`respond_ok` is [not a stock
part](https://github.com/dashkb/thing/blob/camera/app/controllers/application_controller.rb#L59),
but you can borrow mine if you want to.  It's up to you to set yourself up some
Redis.  [Here](https://github.com/dashkb/thing/blob/master/Procfile)'s
[how](https://github.com/dashkb/thing/blob/master/config/initializers/redis.rb)
I do it.  Also, note we now have *two data sources*, one
of which we plan to *share with at least one other service*.  This means our
Rails-centric universe is no more; the Rails service's role is now something like
"model API server" instead of "everything".

If you know me you've heard me make this argument before:
just because we have a shiny new thing doesn't mean we should
toss Rails in the trash. It's still giving us a REST API and wrapping our
SQL database more or less "for free", and solves other problems
(schema migrations, model validation, asset compilation, to name a few)
that have ~~shitty~~ immature solutions in the Node world.  However, none
of the cool parts from here on out will be in rails.

#### Training Reflexes
##### or: comitting to a bad analogy

With Rails publishing events to Redis, it's time to set up something
on the other end.  Let's create a CoffeeScript file (perhaps in a `realtime/`
directory at the top level of our Rails project) to handle realtime connections
from clients.

```coffeescript
http   = require 'http'
url    = require 'url'
Redis  = require 'redis'
Primus = require 'primus'

# Start the http server
process.env.PORT ||= '8081'
server = http.createServer (req, res) ->
  # 404 every page by default, we only serve websockets
  response.statusCode = 404
  response.end()
.listen process.env.PORT

# Start redis
console.log "Connecting to redis at #{process.env.REDIS_URL}"
url   = url.parse process.env.REDIS_URL
redis = Redis.createClient url.port, url.hostname

redis.on 'error', (e) ->
  console.log "REDIS ERROR: #{e}"
  console.log e.stack

redis.on 'message', (channel, message) ->
  # Remember our message is always JSON
  message = JSON.parse message
  doStuffWith channel, message

redis.subscribe 'thing'

# Start websockets
primus = new Primus server
primus.on 'connection', (spark) ->
  console.log "New connection..."

console.log "Realtime service listening on port #{process.env.PORT}"
```

So, you'll need to `npm install --save redis primus ws` (in your `realtime/`
directory) to get the Redis module installed, and
[Primus](https://github.com/primus/primus)-- a library that wraps a
whole bunch of WebSocket-ish libraries so you can write your code without
caring if you're using WebSockets or BrowserChannel or Socket.IO or whatever.
Read the Primus docs; there's a little [manual
work](https://github.com/primus/primus#client-library) to get the client
library out of it.

I won't explain the boilerplate Node HTTP server code.  The Redis bit
should be clear; we're connecting to Redis and subscribing
to the `thing` channel, which is where our controller is publishing its
events.  In the Redis `message` callback, we have access to the channel
(we could subscribe to multiple channels and they'd all be handled
by the same function) and the JSON we wrote from the controller, which
we parse immediately.  It is worth noting that once the Redis client
is put into subscriber mode (which happens on the first `subscribe` call)
it can no longer be used to publish messages or perform regular Redis
operations.  The solution is to initialize another client for that stuff.

On the frontend, we need to connect.  Something like

```coffeescript
socket = Primus.connect 'http://localhost:5300'
socket.on 'open',  => console.log "Connected"
socket.on 'close', => console.log "Disconnected"
socket.on 'error', (err) => console.log "Socket error: #{err}"
socket.on 'data', (data) => console.log "Got data", data
```

will get you started.

#### Build Muscle Memory

Running our app now requires starting three services (not counting our SQL
database) which is too much to manage manually.  I linked it above, but now
it's mandatory: check out how I set up my
[Procfile](https://github.com/dashkb/thing/blob/camera/Procfile) and define
the appropriate evironment variables in `.env`.  If that made no sense, go read
about [Foreman](https://github.com/ddollar/foreman).

#### Build Self-Confidence

Once you've got your sockets connecting, we'll need a way to find out
who we're talking to.  This took me a while to figure out.
The Rails cookie, which contains the user's session, must be decrypted.
Back to our realtime node service:

```ruby
_ = require 'lodash'

cookieParser = require('node-rails-cookies')
  base: process.env.SECRET_KEY_BASE
  salt: 'encrypted cookie'
  signed_salt: 'signed encrypted cookie'
  iterations: 1000
  keylen: 64

getSessionCookie = (cookies) ->
  cookies = _.reduce (cookies.split ';'), (cookies, cookie) ->
    _.tap cookies, ->
      [key, value] = cookie.split '='
      cookies[key.trim()] = decodeURIComponent value.trim()
  , {}

  if cookie = cookies[process.env.SESSION_KEY]
    JSON.parse cookieParser cookie, 'aes-256-cbc'
  else
    {}

primus.on 'connection', (spark) ->
  fail = ->
    spark.write error: 'authorization failed'
    spark.end()

  try
    session = decodeSession spark.headers.cookie
  catch
    fail()
    return

  if session?.session_id
    # We're good to go
    createClientObjectOrSomethingWith session, spark
  else
    fail()
```

We'll need to add `node-rails-cookies` and `lodash` to `package.json` and `npm
install` (or `npm install --save` them) in our `realtime/` directory.  Also,
make sure that all of the environment variables are defined in your `.env`
file, and Rails is set to use them instead of hardcoded values.  Take a look at
the [Dotenv](https://github.com/bkeepers/dotenv) gem if you haven't seen it.
Note I have hardcoded the default Rails values for the cookie salts; I should
have used environment variables for these too.  But I'm lazy.

And that's pretty much it.  Where you go from here is up to you.  Check out
my [camera thing](https://github.com/dashkb/thing/tree/camera) for a meatier
example of what we've been talking about, with perhaps a few more things you
might find useful (like managing users).  Thanks for reading!
