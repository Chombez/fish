function check_config_status
	set -l __starting_dir (pwd)
	set -l config_dirs ~/.vim ~/.config/fish ~/.config/git ~/.config/tmux
    for path in $config_dirs
        cd $path
        echo $path | grep -o '[^/]*$'
        git remote update > /dev/null
        echo (__terlar_git_prompt) \n
    end
    cd $__starting_dir
end
