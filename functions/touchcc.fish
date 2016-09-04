function touchcc
    for file in $argv
        touch $file.cc $file.h
    end
end
