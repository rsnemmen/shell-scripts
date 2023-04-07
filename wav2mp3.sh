for file in *.wav
do
  lame -h --vbr-new $file "$(basename "$file" .wav).mp3"
  #lame -h -b 160 $file "$(basename "$file" .wav).mp3"
done
