---
title: I Made a Thing that Makes Websites
subtitle: "Or: I have a website"
---

These days, it's not enough to just be talented.  Skills alone can't pay the
bills, and I want every line on my bills to match `/^Beachfront/`.  Being
really, really ridiculously talented **might** be enough, but to accumulate
the street cred I'll need to ensure success my psychic says I should start
blogging.  And anyone who knows me will tell you how highly I regard psychics.

I'm proud to say that the first thing I considered was *what do I write about?*.
Unfortunately the second thing I considered was *what software will render these
instant classics I'll be writing from larval Markdown into something pretty and
readable?*.  I started addressing these issues four days ago, and I've just now
resolved the second and am beginning to address the first.  By talking about the
second one.

#### Picking tools is paralyzing
Seriously-- [my first stop](http://staticsitegenerators.net/) lists 216 tools
that all basically do the same thing, except differently.  It was easy to
eliminate two thirds of them (don't know this language, that project looks dead,
not interested in PHP thx, etc) and then go through the most popular and most
recently updated ones.  Each makes a few compromises, or shows a preference (you
have to have a file called `exactly.this` or you have to put your styles in the
`styles` directory).

Just like in real life, nobody was going about this extremely simple task the
exact way I wanted to.  I didn't want writing in my blog to feel like staying in
a hotel.  I wanted it to have all the comforts of home, or, at the very least, I
wanted to be allowed to remodel whenever I felt like it.  Any developers reading
know exactly where this is going...

#### I'll just build a thing
The wheel has still not been perfected.  Actually, wheels suck so badly we have
to wrap them in tires just to make driving possible.  Then we need to put shock
absorbers between them and ourselves if we want to enjoy the ride.  Airplanes,
boats, rocket ships, and cheetahs don't even use wheels.  So, I guess my point
here is that I never understood the nasty tone everyone puts on when they say
*you're reinventing the wheel*.

I cleaned the lenses of my wheel-inventing goggles and started to think about
which tools to use to build myself a blogging tool.  This wasn't difficult for
me to justify to myself— hadn't I been wanting something to quickly bundle up
frontends for my side projects?  Hadn't I been messing around with, and been
super impressed by, [Browserify](http://browserify.org/), and in general pretty
pumped about pure Javascript frontend thingies?  I decided to jump in with both
feet: make a thing out of [Yeoman](http://yeoman.io/), [Grunt](http://gruntjs.com/),
and [Bower](http://bower.io/), use Browserify and [Less](http://www.lesscss.org/)
and have it all magically work together without me ever having to think about it.

So, I was, like, **this close** to typing `yeoman new grunt browserify blog
project with less and stuff` when I read [this
post](http://blog.ponyfoo.com/2014/01/09/gulp-grunt-whatever) about
[Gulp](http://gulpjs.com/).  I'm a slave to the *right tool for the right job*
mandate and I didn't want to make a poor choice for such a high-stakes
endeavor.  Gulp and Grunt are both cool tools, and both have packages that let
you use [one](https://npmjs.org/package/gulp-grunt)'s tasks from the
[other](https://npmjs.org/package/grunt-gulp).  I think it comes down a matter
of which syntax you prefer (and whether or not you understand pipes in Node).So
after playing with Grunt for all of zero seconds (Gruntfiles are long and
frightening) and probably reading a few more blog posts singing Gulp's praises,
I decided to have a sip.  Of Gulp.

Here is what I needed my tool to be able to do:

* Convert a bunch of markdown files into HTML files
  * With syntax highlighting, of course.
  * It would be cool if I could throw some [front
    matter](http://jekyllrb.com/docs/frontmatter/) on my pages to configure how
    they'll be rendered, or add categories or tags, who knows?
* Bundle up a bunch of Coffee/Javascript, Less/CSS, fonts, images.
* Deploy itself to GitHub Pages

[Here](https://github.com/dashkb/gulp-site) is how far I got using Gulp.  When I
had to accomplish something that fit nicely into Gulp's piping philosophy, [it
was
easy-peasy](https://github.com/dashkb/gulp-site/blob/master/gulpfile.coffee#L76).
(Hey Gulp-- Here's a bunch of files, I want to do the same thing to every file in the group
and eventually concatenate them together and write them someplace, or
write each resulting file individually someplace else and preserve the original
structure.  Oh, and I've got some plugins already that do everything I want.)

But my [most complicated
task](https://github.com/dashkb/gulp-site/blob/master/gulpfile.coffee#L35) was where
I choked.  (It went down the wrong pipe?)  I say “most complicated” but really
it's not all that complicated: 1. extract front matter and build a big hash of
page metadata, 2. render the markdown to HTML, 3. wrap the whole thing in a
layout and render a navbar, then 4. write it to the build directory with the
proper extension.  I thought my solution was really ugly and totally didn't feel
like fixing it.

To stick to Gulp's *way* (piping) and also the Node *way* (small functional
units) I had to do this a bunch of times:

```coffeescript
gulp.src(someGlob)
  ...
  .pipe(mapStream (file, cb) ->
    text = file.contents.toString 'utf8'
    # Do some stuff, modify `text`
    file.contents = new Buffer text
    # or rename the file, whatever
    cb null, file
  )
  ...
```

It seemed silly to constantly be converting Buffers back and forth to Strings
and do all this piping (not to mention the enormous list of dependencies
I had accumulated) when all I really wanted to do iterate through my pages a few times.

#### Building it from scratch-er
When you consider all the Gulp plugins I'm not using anymore, ~350
SLOC isn't bad.  Yes, it's longer than my Gulpfile, but I wrote it much
faster than the Gulp version and I'll enjoy maintaining it more because
I wrote it.

Of course, I'd be kidding myself to claim I wrote this from scratch; the CLI is
built with [commander.js](https://github.com/visionmedia/commander.js), I'm
relying heavily on [RSVP.js](https://github.com/tildeio/rsvp.js) for flow
control, and of course Browserify, Less, [Marked](https://github.com/chjj/marked),
and many other excellent libraries.  I like to think I prefer this because the
tools I chose all solve a specific problem and don't force anything on me.

I'm happy with [what I've got](https://github.com/dashkb/dashkb.github.io), and I'm looking forward to continuing to improve
it.  Also, writing.

#### #TODO

* **Comments.**  Perhaps one day I'll post something discussion-worthy, and when
  that day comes I'll be ready.
* **Revisions.** I hate all my old recordings and I'm sure the same will be
  true with writings; for transparency's sake when I update a post I want links
  to the page's history.  (This is all [backed by Git](https://github.com/dashkb/dashkb.github.io), of course.)
* ~~**A Footer.**~~ To protect my masterpieces with explicit copyright.
* **The Build Script** needs some work:
    * Be like `make` and only build things that have changed
    * Be smarter about options, defaults, and passing them from command to subcommand
* **Write some tests.** I'd hate to ruin everything on a deploy without realizing it right as I make #1 on HN.
* **_Every_ social media plugin.** I'm totally serious about doing this.
