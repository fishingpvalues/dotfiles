function extract --description 'Unpack any archive without remembering the flags'
    # ouch handles every format worth having; this is the fallback for boxes
    # that do not have it.
    if command -q ouch
        ouch decompress $argv
        return
    end
    for f in $argv
        switch $f
            case '*.tar.gz' '*.tgz';   tar xzf $f
            case '*.tar.bz2' '*.tbz2'; tar xjf $f
            case '*.tar.xz' '*.txz';   tar xJf $f
            case '*.tar.zst';          tar --zstd -xf $f
            case '*.tar';              tar xf $f
            case '*.zip';              unzip $f
            case '*.7z';               7z x $f
            case '*.gz';               gunzip $f
            case '*';                  echo "extract: no rule for $f" >&2
        end
    end
end
