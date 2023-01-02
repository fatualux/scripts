git filter-branch --commit-filter '
    if [ "$GIT_COMMITTER_EMAIL" = "<emodendro@gmail.com>" ];
    then
        GIT_COMMITTER_NAME="fatualux";
        GIT_AUTHOR_NAME="fatualux";
        GIT_COMMITTER_EMAIL="fatualux@users.noreply.github.com";
        GIT_AUTHOR_EMAIL="fatualux@users.noreply.github.com";
        git commit-tree "$@";
    else
         git commit-tree "$@";
    fi' HEAD
