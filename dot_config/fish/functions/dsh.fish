function dsh --description 'Shell into a container, picking it with fzf if unnamed'
    set -l name $argv[1]
    if test -z "$name"
        set name (docker ps --format '{{.Names}}' | fzf --height 40% --prompt 'container> ')
        test -z "$name"; and return 1
    end
    # Not every image has bash. Try it, fall back to sh rather than failing with
    # "executable file not found", which reads like the container is broken.
    docker exec -it $name bash 2>/dev/null; or docker exec -it $name sh
end
