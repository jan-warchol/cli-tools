# Introduction to LilyPond Cli-Tools
The LilyPond Cli-Tools do the life easier for you if you want to be updated with the latest in LilyPond development. The following is a short introduction for new and non-advanced users. It covers some kind of likely evolution for a LilyPond user who wants to get more involved in the program's development. If you like a more comprehensive account of the possibilities please see the help-files. 
## Requirements
OS: [?]

Programs: git

Personal: Ability to run commands from terminal. If you aren't familiar with this please see a tutorial on this.

Other: [?]

## First build 
You read about a great new improvement in the development version of LilyPond and can't wait for this to reach a stable version. Or you have some other good reason for not wanting to work (only) with the stable version. LilyPond is open-source so you have the possibility to download the code and compile it yourself to get the latest version. When doing this the Cli-Tools can be a great help.

[download of Cli-Tools assumed] 
The first thing you want to do is to download the source files. The command for this is:

	grab-lily-sources.sh

Note: If you already downloaded the source files but got stuck in the compilation process you should [??]

Next you want to compile the current version. You then use this command:

	build-lily.sh

After a while you hopefully get the message that the program was successfully built. You now have the latest version on your computer.

But it is not installed so to run it you would have to find:

	/lilypond-builds/current/out/bin/lilypond

and run that directly. 

If you like to install it you should do:

	(sudo) make install

from /lilypond-builds/current/ [??]

Warning, if you already have a previous version of Lilypond that will now be uninstalled. Maybe a preferable solution would be to have the latest stable version installed and work with development versions from respective out/bin as described. 

## Get a new version
Time flies and soon your build isn't so current anymore. You need again to download the latest changes. But you shouldn't start over the process from above. Instead you run this command:

	pull-all.sh

Your files are updated and you can again run:

	build-lily.sh

If you like the current version installed you also have to re-install.

## Get a specific branch
You read about a special branch in the development and want to try this out instead or as a complement to current version which you have. This branch can't be reached with the method described above, but there are ways to get there. What you need to find out is the commit ID, branch name or a tag name of the particular development you want to investigate or use. Lets say that what you want is called *branchX, then you use this command:

	build-lily.sh -c branchX

You can now see that /lilypond-builds/ except from current also have the directory branchX. To use both these versions in parallel you could run:

	/lilypond-builds/current/out/bin/lilypond

and

	/lilypond-builds/branchX/out/bin/lilypond 

respectively. (We recommend using the Frescobaldi editor for easy handling of multiple builds.)

But let's say you don't want to complicate things with two development versions. You like branchX and you want to follow this for a while, later perhaps you want to go back to the main branch. Then you can build it with this command instead:

	build-lily.sh -c branchX -d current

## Get into the source
You read about a novelty in the LilyPond development but it's not (yet) in the main branch, some subsidiary branch or even committed. You only got the changed files or a patch with the differences. We now need to turn our attention from the build folder to the directory called 

	/lilypond-sources

If you have the changed files. Look for them in this folder and replace them.

If you have the patch, let's say that is called *patchX. You can run the patch command to change the files:

	patch patchX
	(Usage: patch [OPTION]... [ORIGFILE [PATCHFILE]] )

You may have to be in the right directory to make this work. Hopefully you get it right.

We are now ready to build the source with the changes you just made to the source files. You could run

	build-lily.sh

and the changes will be made in the current build. But let's say you want to have them in a different build this time. You could again use the -d option:

	build-lily.sh -d patchX

## Basic Troubleshooting
If the building process at some point doesn't work out you could try to use the -s option. It means to build from scratch, i.e. delete previous build results from target directory before compiling again:

	build-lily.sh -s











