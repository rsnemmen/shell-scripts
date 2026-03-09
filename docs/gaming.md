# Gaming

**Dependencies:** `chdman`, `steamcmd`, Python 3

| Script | Description |
|--------|-------------|
| `add_other_disks.sh` | Append missing disc files/playlists to a game list |
| `create_chd.sh` | Batch convert ISO/CUE disk images to CHD format |
| `create_m3u.py` | Create M3U playlists for multi-disk ROMs (Python) |
| `move_them.sh` | Flatten nested directory structure |
| `rename.sh` | Strip leading numbering from filenames |
| `steam_downloader.sh` | Download Steam games via SteamCMD |

---

## Usage

### create_chd.sh

```sh
sh gaming/create_chd.sh <extension>
# examples:
sh gaming/create_chd.sh cue
sh gaming/create_chd.sh iso
```

Batch converts all disk images with the given extension to CHD format using `chdman`. CHD is a compressed disk image format used by MAME and RetroArch.

### create_m3u.py

```sh
python gaming/create_m3u.py [extension]
# examples:
python gaming/create_m3u.py        # defaults to .cue
python gaming/create_m3u.py .chd
```

Creates M3U playlist files for multi-disc ROM sets. Groups disc files by game title and writes one `.m3u` per game.

### steam_downloader.sh

```sh
sh gaming/steam_downloader.sh <install_dir> <app_id> <username>
# example:
sh gaming/steam_downloader.sh ~/games 570 mysteamuser
```

Downloads a Steam game via `steamcmd` using the given App ID and Steam username. Creates the install directory if it doesn't exist.

### add_other_disks.sh

```sh
sh gaming/add_other_disks.sh <listfile>
```

Scans a game list file for multi-disc entries and appends any missing disc files (`.chd`) and `.m3u` playlists without creating duplicates.

### move_them.sh

```sh
sh gaming/move_them.sh
```

Moves all files from subdirectories into the current directory, then removes the now-empty subdirectories. Useful for flattening ROM collections.

### rename.sh

```sh
sh gaming/rename.sh
```

Strips leading numeric prefixes (e.g., `1. Game Name` → `Game Name`) from all files in the current directory. Displays progress with color output.
