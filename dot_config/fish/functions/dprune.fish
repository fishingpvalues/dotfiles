function dprune --description 'Reclaim docker disk, showing what will go first'
    docker system df
    echo
    read -l -P 'Prune images, build cache and dangling volumes? [y/N] ' ok
    switch $ok
        case y Y yes
            docker system prune -af --volumes
        case '*'
            echo aborted
    end
end
