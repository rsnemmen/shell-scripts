`create_m3u.py`: goes through files in the current directory consisting of multi-disk PS1 games. For each game, creates a `.m3u` text file listing all `.cue` files in order. Apparently this makes emulation easier for multi-disk games.

`move-cue.sh`: I had a ROM set where every PS1 game was in a layers of subdirectories. I just wanted to move all of those files to the current directory, removing the subdirectories afterwards. This script accomplishes that.

`rename.sh`: I had a ROM set where each game's filename followed the convetion `10. <gamename>.*`. I just wanted to get rid of the leading number. This script does that, renaming all files in the current directory.