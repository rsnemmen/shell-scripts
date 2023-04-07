for X in `ls *.mp3`
    do
    TARGET=`basename $X .mp3`
    mpg123 -s $X | sox -t raw -r 44100 -s -w -c 2 - ${TARGET}.wav
    done