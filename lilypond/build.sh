referencebuild=$LILYPOND_BUILD_DIR/../master/
mirrorrepo=$LILYPOND_GIT/../mirror-repo/

# $1 - operating mode
# $2 - build directory
# $3 - commit to build

die() {
    #aplay -q ~/src/sznikers.wav
    exit 1
}

# if we're not inside a repository, go to the default one.
# warning: this doesn't check whether we're in a _lilypond_ repository.
git rev-parse 2> /dev/null
if [ $? != 0 ]; then cd $LILYPOND_GIT; fi

if [ "$1" != "" ]; then options=$1; else options="n"; fi

builddir=$LILYPOND_BUILD_DIR
if [ "$2" != "" ]; then builddir=$LILYPOND_BUILD_DIR/../$2; fi

if [ "$3" != "" ]; then git checkout $3 || die; fi 
commit=$(git rev-parse HEAD)

if [ $mirrorrepo != "" ]; then
    cd $mirrorrepo
    git checkout --quiet $commit
fi
repositorydir=$(pwd)

case $options in
  ?)
    time $LILY_SCRIPTS/lily-make.sh $options $builddir $repositorydir
    ;;
  ??)
    time $LILY_SCRIPTS/lily-make.sh $options $builddir $repositorydir
    echo "----------------------------------------"
    cd $repositorydir
    git checkout master
    time $LILY_SCRIPTS/lily-make.sh $options $referencebuild $repositorydir
    ;;    
esac

git checkout master

echo "________________________________________"
echo ""
