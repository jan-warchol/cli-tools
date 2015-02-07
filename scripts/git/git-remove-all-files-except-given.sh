git rm --quiet --cached $(git ls-tree -r --name-only --full-tree $GIT_COMMIT | grep -v ^$1$ )
