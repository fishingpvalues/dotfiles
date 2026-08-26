function mkcd --description 'mkdir -p then cd into it'
    test -n "$argv[1]"; or begin; echo "mkcd: need a directory" >&2; return 1; end
    mkdir -p -- $argv[1]; and cd -- $argv[1]
end
