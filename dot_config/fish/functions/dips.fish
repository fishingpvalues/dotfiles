function dips --description 'Every container with its networks and IPs'
    docker ps -q | xargs -r docker inspect --format \
        '{{.Name}}{{range $k,$v := .NetworkSettings.Networks}} {{$k}}={{$v.IPAddress}}{{end}}' \
        | sed 's|^/||' | sort | column -t
end
