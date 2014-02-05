---
title: "Round: Writing Code in the (Literal) Wild"
slug: round
---

[Round](http://github.com/dashkb/round) is a democratic music player I put
together last summer.  It was installed at an art festival in the hills of
northern Georgia.  I anticipated a lot of things going wrong-- the forecast
called for rain and wind, there were bugs and stuff, and also intoxicated
people-- but ended up being sunk by something I didn't anticipate at all.  To
build tension before I drop the fail, here's what went right:

#### Democracy!

Imagine yourself in a glowing forest, stumbling happily about from campfire to
campfire, enjoying the various pretties.  Everywhere you go, someone has chosen
the music for you, and you've heard every permutation of `['filthy', 'nasty',
'bass', 'drop']`, but not what anyone around you is saying.  Imagine next you've
arrived [at our camp](/images/camp-entrance.jpg) and you find yourself
encouraged to search our (ridiculously large) music collection at the
[kiosk](/images/kiosk.jpg) and enqueue music you'd like to hear (perhaps while
challenging your friend to some [boxketball](/images/boxketball.jpg)).

I know that a proper musical experience sometimes requires more than one track
played in order, and so Round lets you queue a few tracks at a time.  This,
in my mind, is crucial (otherwise how could I listen to Phish with it? also
Abbey Road), and useless without...

#### Gapless Playback <small>A Basic Human Right</small>

It's ~~surprising~~ embarassing how few music players have this essential
feature.  Apparently, 20ms of static between tracks counts as gapless these
days.  Either that, or most people can't tell and/or don't care.  It *almost*
makes me miss my iPhone.  The stock Android player fails (it has a box you
can check that doesn't do anything), as do [VLC](http://videolan.org), and
Apollo, the player bundled with [CM11](http://cyanogenmod.com), among others
I've uninstalled and forgotten.

Faced with building a player of my own gapless was a top priority for me;
shamefully most of my group was more interested in album art.  To me,
prioritizing a visual feature before an audio feature is like prioritizing the
way your food looks and tastes ahead of its nutritional value. (<small>*sigh*</small>)
[This](/images/cover-flow.jpg) is why I don't care about cover flow.  Nobody
cared about gapless but me.  I still did it.

I took advantage of the fact that I was in complete control (well, mostly) of
the production environment and used
[CoreAudio](https://github.com/nagachika/ruby-coreaudio) for playback.  This
means that (currently) you've got to host the thing on a Mac.  Gapless is easy
if you take full responsibility for playback: all that is required is a loop
that buffers samples (from a source like some mp3 files) and writes them to the
output device.  Check it (paraphrased from the [actual
file](https://github.com/dashkb/round/blob/master/lib/player.rb#L83)):

```ruby
size   = 4096
buffer = CoreAudio.default_output_device.output_buffer size
file   = CoreAudio::AudioFile.new "/Users/kyle/Desktop/filthy-bass-drops.mp3"

while samples = file.read(size)
  buffer << samples
end
```

I wanted to show that code inline in case anyone considering building a music
player drops by-- shame on you if you skip gapless because it's too much work.

Combined with [some way to detect the end of a track](https://github.com/dashkb/round/blob/master/lib/audio_file.rb#L45)
and [some way to keep track of the playlist](https://github.com/dashkb/round/blob/master/lib/queue_service.rb)
you've got everything you need.  Note you'll want to ensure you aren't running
your player in the same process as your web application, so that 1. you don't
starve the output buffer (causing silence and timing problems for anyone dancing)
and 2. you don't starve browsers.  You'll probably want some way to control
the player, too.

#### Player API

The player does a few things besides play music.  Well, it does a few things in
support of playing music, which is all it does.  Playing music is complicated.
When left to its own devices, it plays tracks (looked up in Postgres, then
found on the disk) from the
[queue](https://github.com/dashkb/round/blob/master/lib/queue_service.rb)
(stored in Redis) in order.  When the queue is empty, the player picks a track
at random from a whitelist we manage in admin mode.

Occasionally we needed to do fascistic things (like delete accidental repeats,
or move songs around for [performance reasons](/images/fire-performance.jpg))
and so the player is available via [ZeroMQ](http://zeromq.com) socket.
Overkill, for sure.  The
[PlayerController](https://github.com/dashkb/round/blob/master/app/controllers/player_controller.rb#L6)
just
[forwards](https://github.com/dashkb/round/blob/master/lib/player_service.rb)
[requests from the
frontend](https://github.com/dashkb/round/blob/master/app/assets/javascripts/app/queue_view.js.coffee#L44)
to the player, and with some harmless metaprogramming it's all very short and
tidy.

#### RESTy API / Backbone.JS Frontend

A standard afternoon in Rails gets me a RESTish API for browsing tracks,
artists, albums, and genres, and a general search.  Supporting a Backbone
frontend, this was the easy part.  You can always count on Rails for this
stuff, even if it's not the hottest thing around anymore.

The frontend itself took a lot of time, mostly iterating on "how the hell
should a music player work?".  It turns out that we all like to organize
and search our music differently, and our preferences dictate drastically
different needs.  Example: I have lots of live shows (and thus many tracks
with the same title AND artist) so I do most of my browsing by album and prefer
a date-sorted album list with no art.  Can your music player do that? (If so,
how deeply buried is it?)

We settled on a sort of iTunes clone, and, for performance reasons (did I say
our collection was really big?) we had to cut some features at the last minute.
(By which I mean I was writing code in the rain in the forest.  Way fun.)  Fortunately
it wasn't too much work to move features around the frontend due to a modular
design and having way too many APIs lying around.  Unfortunately a lot of
cruft is milling about.  For next year, a full redesign is required of course.

#### Track Importing

It took a little bit of tuning, but Round can happily import from (multiple)
iTunes libraries, as well as index directories of tracks with [TagLib](http://taglib.github.io/).
Working on this bit brought back memories of my early days of playing with
computers-- there aren't many things that I run overnight anymore.  There's no
worse feeling than waking up and seeing that your 8-hour script crashed five
minutes after you went to bed.

#### The Fail

So I was deploying an iPad web kiosk about 15 feet from the machine running
the app.  I used OS X's [computer to computer network](http://support.apple.com/kb/PH13796)
(electricity was at a premium, as was space, bringing a WAP seemed like an obvious
mistake) and everything was working fine... until actual users started showing up.
Every so often, someone would come up to me and say "The thing is frozen again" which
became sort of the theme of the festival for me.  It wasn't frozen, the iPad had just
disconnected from the wireless, causing the interface to stop responding.  I never
got around to putting an error message on the thing, because I had to constantly
unlock the kiosk mode, reconnect to the wifi, re-lock it, and hope my potential
user hadn't wandered off.

I know from my professional life that you have to test everything in realistic,
production-like settings before you can expect success with confidence.  So let
me know if you're throwing a loud party in the woods with a bunch of intoxicated
people and would be interested in testing Round.
