function dmem --description 'Real container memory: anon, not page cache'
    # `docker stats` counts page cache in MemUsage, so a container reading a big
    # file looks like it is about to OOM when it is nowhere near its limit. The
    # cgroup is the source of truth; anon is what actually counts against it.
    printf '%-28s %10s %10s %10s %s\n' CONTAINER ANON FILE LIMIT OOM_KILLS
    for c in (docker ps --format '{{.Names}}')
        set -l s (docker exec $c sh -c 'cat /sys/fs/cgroup/memory.stat 2>/dev/null; echo max=$(cat /sys/fs/cgroup/memory.max 2>/dev/null); grep ^oom_kill /sys/fs/cgroup/memory.events 2>/dev/null' 2>/dev/null)
        test -z "$s"; and continue
        set -l anon (string match -r '^anon (\d+)' -- $s | tail -1)
        set -l file (string match -r '^file (\d+)' -- $s | tail -1)
        set -l max  (string match -r '^max=(\S+)' -- $s | tail -1)
        set -l oom  (string match -r '^oom_kill (\d+)' -- $s | tail -1)
        printf '%-28s %10s %10s %10s %s\n' $c \
            (numfmt --to=iec $anon 2>/dev/null) \
            (numfmt --to=iec $file 2>/dev/null) \
            (test "$max" = max; and echo none; or numfmt --to=iec $max 2>/dev/null) \
            $oom
    end
end
