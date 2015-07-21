---
title: My Tools
template: article
tags: [code, tools]
---

<div class="full">
  ![writing this
  post](http://screens.dashkb.net/1._kyle_tmux_attach_-d_tmux_2015-07-21_16-16-20.jpg)
</div>

I get asked about my shell and editor often enough (usually "Oooh... colors")
that it's probably time to write down how it works.  If you've been
directed here, consider how fortunate you are to be able to scroll past all my
editorializing.  We're going to start at the outside and work our way in to the
more specific gizmos and doodads.  You can just [check out my dotfiles on
GitHub](https://github.com/dashkb/.files) if you want.

### Principles

**Handle Everything In The Terminal**

I haven't achieved this yet, but I can do *most* things in my shell. I figure
if [RMS does it](https://stallman.org/stallman-computing.html) I, too, (obviously)
should spend all my time in the shell.  Mostly, though, it's out of
laziness: that sweet, sweet programmer's laziness that drives extra effort
now for the sake of future ease.  The fewer "moves" it takes to do a
thing, the better.

**Edit Everything In The Editor**

I have chosen a powerful editor and worked to expand its power.  Every text
editing task can be done more efficiently in my editor.  Editing anywhere else
is unpleasant, wasteful, and totally avoidable.

**Useful Everywhere**

All of my tools should work (more or less) the same way everywhere.
Sometimes I'm at my desk with a big screen, fancy keyboard and no distractions,
but sometimes I'm crammed into an airplane seat or have a cat on my arm;
sometimes I'm on my Mac, but sometimes I'm logged into another Mac, or some
Linux machine someplace.  I prefer tools that are available and work similarly
everywhere I might need them.

**No Mouse**

When I'm working, I try to avoid the mouse.  I don't find it particularly
accurate, and it takes time to move my hand there.  Plus, sometimes it's a
trackpad and other times it's a mouse, or that little nub thing, and that can
lead to inconsistency.  Better to stick with the keyboard, which my hands are
already on anyway.

**Prefer Piecemeal**

If you told me you thought my tools felt "cobbled together" or "hacky" I
wouldn't argue; I might even take it as a compliment. There are sloppy bits,
broken bits, bits I'm not done with yet, bits I'm procrastinating, etc; but I
can say I've chosen to include everything I've included, and that makes me
proud. Also, it's fun.  (Same with food— I like to know what it's made of and
mess with the recipe a bit each time until it's just how I like it.)

### Pillars

The tools I use are, objectively, the most awesome tools.  Everyone on the
Internet agrees that these are the best tools.  They're all free.  Don't bother
typing `[any of these] vs` into Google to see what comes up.

* **[Iterm2](https://www.iterm2.com/) Terminal Emulator** -  for OS X.
  [Linux](http://gnometerminator.blogspot.com/p/introduction.html)
  and [Windows](http://babun.github.io/) users have great options too; really
  any terminal emulator should be fine since we just need it to be fast and
  support our colors.
* **[tmux](https://tmux.github.io/) Terminal Multiplexer** - Powerful control over
  your terminal sessions.  Once you grok tmux, a lot of my magic will lose its, um,
  magic.
* **[Vim](https://www.vim.org) Text Editor** - Vim is the best most powerful text
  editor ever.  You might think that forking my dotfiles and replacing Vim with
  Emacs will "just work" but I regret to inform you that using Emacs will NOT
  WORK and is actually EXTREMELY DANGEROUS to your health so you're probably
  better off NEVER LOOKING AT EMACS EVER AGAIN.
* **[Zsh](http://www.zsh.org/) Shell** - Modern shell that should make Bash
  users feel at home.  Even if you don't know what Bash is, you'll probably still
  like Zsh.  [Fish](http://fishshell.com/) is interesting, too.
* **[Homesick](https://github.com/technicalpickles/homesick) Configuration
  Management Tool** - A simple tool which manages my dotfiles.  It's a Ruby
  gem, so you can use [Homeshick](https://github.com/andsens/homeshick)
  which depends only on your shell.

### Glue

I'm not going to cover the basics of these tools.  If you don't have some
awareness of this stuff already (and you didn't click any of those links) you
might get lost.  Here follow some highlights of how I've glued all these bits
together.

**Colors**

I use the [Base16](https://github.com/chriskempson/base16) color scheme in
[Vim](https://github.com/chriskempson/base16-vim) and also [for my
shell.](https://github.com/chriskempson/base16-iterm2)  It's probably available
for your favorite tools, too.  Use any colors you like, of course, but I find
it comforting to have the same colors everywhere, so find what you like and
stick with it.

**Keys**

Every program has the perogative to come with terrible, outdated
keybindings that hurt your hands and make no sense.  This happens of course
because the program's author irresponsibly (this asshole who has devoted precious time to
building free software with the only goal of making others more productive and
happy) failed to read your mind all those years ago and account for all the
factors present in your environment right now.  Fortunately, awesome tools are
typically awesomely configurable.  Obnoxious defaults should never discourage you from
using a tool.

* Remap `capslock` to `ctrl`.  If you've used `capslock` in the last few years,
  you shouldn't be reading this post.  It's a really great spot for `ctrl`,
  and it sets up...
* Use `ctrl-a` as the tmux prefix key.
* Use `h`,`j`,`k`,`l` for navigating panes and use [Vim Tmux
  Navigator](https://github.com/christoomey/vim-tmux-navigator) to treat
  Vim splits the same as tmux panes.
* Use `space` as your Vim leader key.
* Use `jk` to exit insert mode in Vim (because `esc` is a big pinky reach)
* Whatever makes sense to you.

**Shell**

The shell is your command center.  You want a classic Caddilac, not a rusty old
Pinto. It's *definitely* worth spending the extra time (days, in my case)
getting it just right.

Your prompt is going to be printed to the console more times than any other
text. It should give you exactly the right information and not more.  For
me, this means knowing which machine I'm on, which directory I'm in, and if
it's a project directory, what branch I'm on and the state of my working copy.
[My
prompt](https://github.com/dashkb/.files/blob/master/home/.zplugin/prompt.sh)
also runs `git fetch` for me, which is sweet, and shows the runtime and exit
status of the last command.  Great prompts will use more than just text to
encode meaning.  Colors and special characters can help increase information
density.

If you aren't using a framework (like [Bash
it](https://github.com/Bash-it/bash-it), [Oh my
zsh](https://github.com/robbyrussell/oh-my-zsh) or
[Prezto](https://github.com/sorin-ionescu/prezto) — which are all awesome and
may be better for you than what I do) then you'll need some way to organize
your shell configuration.  A friend of mine made a [lightweight plugin manager
called Shy](https://github.com/aaronroyer/shy) which [does the trick for
me.](https://github.com/dashkb/.files/tree/master/home/.zplugin)

Both Bash and Zsh have a Vim-like editing mode which I use, and if you're a Vimmer
you probably should too.  Enable shared history (unless you don't like it) and
turn off the autocorrection (unless you like it) and let's move on.

**Shell Enhancers**

These tools increase the awesome.  I've further increased the amount they
increase the awesome by adding some awesome aliases of my own.

* [FZF](https://github.com/junegunn/fzf) — Fuzzy-Finder for anything.  Used in
  combination with other tools to make everyday tasks fuzzier (and therefore
  faster).  Try `ps aux | fzf` for a quick example of the power.  (I should
  probaby alias that to `fps`... [TODO first person shooter joke]).
    * `fbr`: `git checkout` with fuzzy branch name matching
    * `fh`: fuzzily search through shell history
    * `fkill`: find process to kill fuzzily
    * `ftags`: fuzzily search through [Exuberant
      Ctags](http://ctags.sourceforge.net/)
    * I also use FZF as my file finder in Vim
* [Fasd](https://github.com/clvv/fasd) — Fast access to things, like
  directories and files.  Learns which things you access the most and suggests
  them first (or jumps you right to them.)  As I'm reading over the README now,
  it strikes me that my usage of this tool is not nearly awesome enough. (I
  just use the `j` alias for jumping around directories.)

**Editor**

I'm really not going to talk about how great Vim is.  I'm also totally not
going to say anything bad about Emacs, even if I believe it's the
inspiration for the video tape from [The
Ring](http://www.imdb.com/title/tt0298130/).

I use [tons of
plugins](https://github.com/dashkb/.files/blob/master/home/.vimrc#L41). Some
advocate keeping your Vim configuration as simple as possible.  They're not
wrong, they just aren't working at the Caddilac factory.  Driving a Formula One
car is fine, but in this case it's not really even faster.  (To head off a
counterargument: when I'm working on a Raspberry Pi or something, I usually
don't even bother with the dotfiles.) So I say, provided you're on a reasonably
powerful machine, make sure your editor has everything you need.  A few
highlights from my `.vimrc`:

[Slime](https://github.com/jpalardy/vim-slime) — This is maybe my coolest
trick, and it's still one of the tools I need to be mindful to use in more
situations.  "All it does" is send text from Vim to a tmux pane, but this is
extremely powerful.  Working in a REPL?   Edit in your editor and send the text
over.  Have your SQL console open?  Edit in your editor.  Shell commands, too!

  * `<Leader> rspec` — Use current file and line information to [run the spec
    (or context) under my cursor in
    terminal.](http://screens.dashkb.net/vim-rspec_edited.mp4)
  * `<Leader> sl` ("send line") — Send current line to tmux
  * `<Leader> !!` repeat last shell command (running specs, etc)
  * `<Ctrl-C> <Ctrl-C>` send selection to tmux (I should remap this, it smells
    wrong)

[Gist.vim](https://github.com/mattn/gist-vim) — I
[create](http://screens.dashkb.net/gist-creation_edited.mp4) my
[gists](https://gist.github.com/dashkb/01b39be49cd6fe202f11) from Vim, from the
entire file or a selection.  Because it's really easy, I do it more.  Posting
gists in chat is a super effective way to share code, and I can do it in a few
seconds.

[Ctags](http://ctags.sourceforge.net/) — To give Vim some IDE goodness.  I have
a couple of tag-aware plugins and a shortcut for updating the definitions.
This is another one I need to remind myself to use.  Searching is so (awesome,
but) wasteful.

I use [Hub](https://github.com/github/hub) to open Pull Requests without
leaving my terminal.  It has other handy shortcuts for interacting with GitHub,
which I do pretty frequently.  It wraps Git, so you can level up on it over
time without being forced to ~~learn anything~~ adjust your habits.

I use the Chrome extension
[TextAid](https://chrome.google.com/webstore/detail/textaid/ppoadiihggafnhokfkpphojggcdigllp)
to edit the contents of `<textarea>`s in Vim.

**Wrap Up**

That's all for now.  If you get any benefit from this and want to repay me,
consider inventing webkit-tmux-pane.
