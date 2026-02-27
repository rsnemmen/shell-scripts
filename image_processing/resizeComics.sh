while [ "$#" -gt "0" ]
do
    TARGET=`basename "$1" .cbz`

    # uncompress file
	unzip "$1"

	# resize all images in parallel
	find . -name '*.jpg' | parallel 'mogrify -quality 70% -resize 70% {}'

	# compress new resized comic
	zip -r "${TARGET}-resized.cbz" *jpg *png

	# remove original images
	rm -f *jpg *png

    shift
done    
