# Shell Scripts

Assorted shell utility scripts for file conversion, text processing, media encoding, and system tasks. Accumulated over many years — 60+ scripts spanning 10 categories.

## Usage

```sh
sh script.sh <arguments>
# or if executable:
./script.sh <arguments>
```

Most scripts support `-h` for help.

---

## Categories

| Category | Directory | Description |
|----------|-----------|-------------|
| [Text & Docs](text.md) | `text/` | Markdown↔LaTeX conversion, word counting, UTF-8 |
| [PDF & PostScript](pdf-ps.md) | `PDF-PS/` | PDF compression, imposition, format conversion |
| [Music](music.md) | `music/` | Audio format conversion (WAV, MP3, OGG) |
| [Movies](movies.md) | `movies/` | Video encoding, subtitle extraction |
| [File Utilities](file-utilities.md) | `file-utilities/` | Batch rename, MD5 hashing, Jupyter→Markdown |
| [Gaming](gaming.md) | `gaming/` | ROM management, CHD conversion, M3U playlists |
| [Image Processing](image-processing.md) | `image_processing/` | Image resizing, screenshots |
| [Transferring](transferring.md) | `transferring/` | rsync/cp-based backup and upload |
| [Mounting](mounting.md) | `mount-images/` | SSH, USB, and disk image mounting |
| [System](system.md) | `system/` | macOS system monitoring |

---

## Dependencies Summary

| Category | Tools Required |
|----------|---------------|
| Text & Docs | `pandoc`, `texcount`, `pdflatex`/`xelatex`, `sed`, `iconv` |
| PDF & PostScript | `pdftk`, `ghostscript`, `impose`, `psselect`, `sam2p` |
| Music | `lame`, `sox`, `mpg123`, `ffmpeg` |
| Movies | `ffmpeg`, `mencoder`, `yt-dlp` |
| File Utilities | `7z`, `jupyter`/`nbconvert`, `pv` (optional) |
| Gaming | `chdman`, `steamcmd`, Python 3 |
| Image Processing | `imagemagick`, `parallel` |
| Transferring | `rsync`, `wget` |
| Mounting | `sshfs`, `fusermount`, `mkisofs`, `cdrecord` |
| System | (built-in macOS tools) |
