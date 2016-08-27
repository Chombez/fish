function sorry --description 'Replace the first word in the last command with a new one'
    set -l lastCommand $history[1]
    set -l args (echo $lastCommand |  sed -r "s/^(\w+)//")
    eval $argv $args
end
