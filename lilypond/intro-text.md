Introduction to LilyPond building scripts
=========================================

You'd like to keep up with latest LilyPond developments, but
compiling LilyPond from source files sounds intimidating?
Read on! There are scripts that can make this process very easy.

This is an introduction for new and non-advanced users. It covers
some kind of likely evolution of a LilyPond user who wants to
get more involved in the program's development. If you like a
more comprehensive account of the possibilities please see the
help-files.

Keep in mind that the scripts themselves are under development,
and their behavior may change.


Requirements
------------

**Operating system**:
Ubuntu-based GNU/Linux (it's easy to make the scripts work on Debian, too).
If you're using Windows or Mac you may consider installing Linux
in a [_virtual machine_](http://en.wikipedia.org/wiki/Virtual_machine),
as demonstrated in LilyPond's [Contributor's Guide]
(http://www.lilypond.org/doc/v2.17/Documentation/contributor/lilydev).

**Programs**: Everything should install itself, you just need bash
shell to run the scripts (should be installed in your operating system).

**Personal**: Ability to run commands from terminal. If you aren't
familiar with this please see a tutorial on this.


First build
-----------

You read about a great new improvement in LilyPond that is
currently in development, but it wasn't included in any release
yet?  Or maybe you often use more than one LilyPond version at
the same time?  Since LilyPond is open-source you have the
possibility to download the code and compile it yourself to get
whatever versions you want.  When doing this the scripts
described here can be of great help.

### Downloading sources

The first thing you want to do is to download LilyPond source files,
required libraries and other stuff.
To do this, download `grab-lily-sources.sh` script from [here]
(http://github.com/janek-warchol/cli-tools/blob/master/lilypond/grab-lily-sources.sh)
and run it.
It will ask you in which directory LilyPond stuff should be placed.
All paths in this tutorial are relative to this directory.
Don't forget to restart the terminal after it finishes!

### Compiling

Now, let's compile the latest LilyPond version. All you have to do
is to run `build-lilypond` command that was installed in previous step.
(This command simply runs `janek-scripts/lilypond/build-lily.sh` script.)

After a while you hopefully get the message that the program was
successfully built. You now have the latest version on your
computer, in the directory `lilypond-build/current`.

### Using new LilyPond

However, if you run `lilypond` command on the command line (or compile
a score using Frescobaldi), old LilyPond will appear.  This is because
the newly compiled LilyPond didn't replace the previous version.
You have to run the binary directly - it can be found here:

    lilypond-builds/current/out/bin/lilypond

To make this easier, you can use the `lily` bash function which is
installed by `grab-lily-sources.sh`.  Running

    lily buildname somefile

will compile `somefile` using LilyPond from `lilypond-builds/buildname`.
In this case, you want to use `lily current somefile`.

You can also tell Frescobaldi about this new version, so that you
will be able to choose between multiple versions when compiling a score.
Add new version using `Edit->Preferences->LilyPond Preferences`.

### Installing

If you'd like to install this new version, first go to the directory
containing the build (in our case `lilypond-builds/current`) and run

    (sudo) make install

However, this is not recommended, as it will uninstall any previously
installed Lilypond version.  Running new versions using `lily` function
or with Frescobaldi should be enough for your needs.


Updating your LilyPond
----------------------

Time flies and soon your build isn't so recent anymore. You need
to download the latest changes, but you don't have to repeat the
whole process - just run this:

    update-lilypond-sources

Your source files will be updated and you can again run:

    build-lilypond

If you like the current version installed you also have to
re-install.


Build a specific branch
-----------------------

You read about a new feature, bugfix or other change that is currently
under development, but it hadn't been approved and added to the official
sources yet (it hadn't been "merged to `master`").  You'd like to try it.

To do this, you need to know the name of the branch to which this change
was uploaded (you may have to ask the author of the change to push his
changes to a branch on the official source code repository). The name
is usually `origin/dev/something`.

When you know the branch name, run `update-lilypond-sources` to make
sure that the branch is available in your copy of the sources. Then run

    build-lilypond -c branchname

You can now see that `lilypond-builds/` except from `current` also
contains the directory `branchname`. To use both these versions in
parallel you could run:

    lily current input-file

and

    lily branchname input-file

respectively (we recommend using the Frescobaldi editor for easy
handling of multiple builds).

But let's say you don't want to complicate things with two
development versions. You like branchX and you want to follow
this for a while, later perhaps you want to go back to the main
branch. Then you can build it with this command instead:

    build-lily.sh -c branchname -d current

This way `branchname` version will be compiled in place of previous
build.


Modify source files yourself
----------------------------

You read about a novelty in the LilyPond development but it's not
yet in any branch. You only got the changed files or a patch with
the differences. We now need to turn our attention from the build
folder to the directory called

    lilypond-sources

If you have the changed files, look for them in this folder and
replace them (we don't recommend working this way; pathes are better).

If you have a patch file generated using git (ask the author of
the change for a "git-formatted patch"), open terminal, go to the
`lilypond-sources` directory and run

    git am patchfile

We are now ready to build the source with the changes you just
made to the source files. You could run

    build-lilypond

and the changes would be compiled in the `current` build. But it
may be a good idea to place them in a different build directory.
You can again use the `-d` option:

    build-lilypond -d patchX


Basic Troubleshooting
---------------------

If the building process at some point doesn't work out you could
try to use the `-s` option. It means to build from scratch, i.e.
delete previous build results from target directory before
compiling again:

    build-lilypond -s


Asking for help
---------------

Feel free to contact me if you have trouble using the scripts.
To ensure that I'll be able to help you, please send me the full
command you ran (including any options you used) and the output
from the script.  If you append `-w &> ~/lily-build.log` to the
command you ran, you should get a logfile in your `HOME` directory
with the output of the script.  So, for example, if you were running

    build-lilypond someoptions

and it didn't work, you can either copy its output from terminal,
or try running

    build-lilypond someoptions -w &> ~/lily-build.log

and then send me the `lily-build.log` file from your `HOME` folder
with a description of the problem.
