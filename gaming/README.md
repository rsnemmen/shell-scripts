# Organizing and converting ROM collections

## Moving and renaming

`move_them.sh`: I had a ROM set where every PS1 game was in a layers of subdirectories. I just wanted to move all of those files to the current directory, removing the subdirectories afterwards. This script accomplishes that.

`rename.sh`: I had a ROM set where each game's filename followed the convention `10. <gamename>.*`. I just wanted to get rid of the leading number. This script does that, renaming all files in the current directory.

`add_other_disks.sh`: When using fuzzycp to create lists of ROM files for copying like this

    fuzzycp dreamcast.txt -o files.txt

there is an issue affecting multi-disk games: fuzzycp list only one of the disks in files.txt. This script checks each file listed in files.txt, checks whether it is a multi-disk game, and includes in files.txt the missing disks as well as the m3u file. This script was created with o3.

## Organizing

`create_m3u.py`: goes through files in the current directory consisting of multi-disk PS1 games. For each game, creates a `.m3u` text file listing all `.cue` files in order. Apparently this makes emulation easier for multi-disk games.


## Conversion

`create_chd.sh`: converts all iso or cue/bin or gdi/bin games in the current directory to the compressed chd format.