function pot --description 'ssh to a potatostack host by short name'
    # Tailscale first, LAN as the fallback: the tailnet name works from anywhere
    # but is dead whenever Tailscale is off on this laptop, and then the LAN
    # address is the only one that answers.
    set -l host $argv[1]
    set -l rest $argv[2..]
    switch $host
        case potatostack pot p; set host 192.168.178.200
        case minipotato mini m;  set host 192.168.178.40
        case '*'
            echo "pot: unknown host '$host' (potatostack|minipotato)" >&2
            return 1
    end
    ssh daniel@$host $rest
end
