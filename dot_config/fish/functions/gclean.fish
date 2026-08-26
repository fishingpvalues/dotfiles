function gclean --description 'Delete local branches whose remote is gone'
    git fetch --prune
    # ": gone]" is what git marks a branch whose upstream was deleted, which is
    # exactly the set that is safe to drop after a squash-merge.
    set -l gone (git branch -vv | string match -r '^\s+(\S+)\s+\S+ \[[^]]*: gone\]' -g)
    if test -z "$gone"
        echo "nothing to clean"
        return
    end
    printf '%s\n' $gone
    read -l -P 'Delete these? [y/N] ' ok
    switch $ok
        case y Y yes; printf '%s\n' $gone | xargs -r git branch -D
        case '*'; echo aborted
    end
end
