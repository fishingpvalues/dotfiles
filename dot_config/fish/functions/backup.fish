function backup --description 'Timestamped copy of a file, next to the original'
    for f in $argv
        cp -a -- $f "$f.bak-"(date +%Y%m%dT%H%M%S)
        and echo "$f.bak-"(date +%Y%m%dT%H%M%S)
    end
end
