for file in *.ogg
do
  ogg123 -d wav -f - "$file" | \
  lame -h -m s -b 160 - "$(basename "$file" .ogg).mp3"
done
