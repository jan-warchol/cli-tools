# from http://stackoverflow.com/questions/7654822/remove-refs-original-heads-master-from-git-repo-after-filter-branch-tree-filte

git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d