---
title: Projects
slug: code
template: false
---

## Projects of Potential Interest

#### [Camera Thing](https://github.com/dashkb/thing/tree/camera)

This needs a better name, clearly.  Currently just a prototype, when
finished this will be a realtime handsfree communication tool for [jamming](http://en.wikipedia.org/wiki/Jam_session).
It's a Rails API with the realtime component in Node.JS, with Redis pub-sub
thrown in for good measure.  In case your jam band has thousands of people and
is distributed throughout the world.  There will be a post.

#### [Round](https://github.com/dashkb/round)

A Rails music player with mobile frontend.  Deployed at an art festival
in the woods, with the frontend on a standing iPad kiosk and the backend running
on a hidden laptop connected to the sound system.  Festivalgoers used the kiosk
to browse our collection and queue their favorite songs for their enjoyment
while visiting.

This probably only runs on Macs, which is a bummer.  (It uses CoreAudio).
It will import your iTunes library or just any plain ol' directory full of music.
My favorite thing about it: *real* gapless playback.

#### [fetool](https://github.com/dashkb/fetool)

Front-end tool; the code that builds this website for me. A little Node.js library
that compiles my Coffeescript, Less, and Haml.  I built it for this website,
but it's useful anytime I need to build a static site, which is common enough.
Read [my post](/i-made-a-thing-that-makes-websites.html) about it.

#### [Dzl](https://github.com/dashkb/dzl)

An old Racktivesupport framework, which was special at the time because it
validates API parameters as part of request routing.  It has a pretty flexible
DSL for declaring APIs.  These days, there are better tools for this.
