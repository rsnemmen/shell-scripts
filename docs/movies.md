# Movies

**Dependencies:** `ffmpeg`, `mencoder`, `yt-dlp`

| Script | Description |
|--------|-------------|
| `get_transcript.sh` | Download YouTube title, description, and subtitles via yt-dlp |
| `mencoder.sh` | Create movie from sequential PNG files |
| `dvd-rip/rip.sh` | Rip DVD to file with 2-pass encoding |
| `dvd-rip/extrair_legendas.sh` | Extract DVD subtitles in VobSub format |

---

## Usage

### get_transcript.sh

```sh
sh movies/get_transcript.sh <youtube_url> [subtitle_lang]
```

Downloads the title, description, and transcript/subtitles for a YouTube video using `yt-dlp`. The subtitle language defaults to English if not specified.

### mencoder.sh

```sh
sh movies/mencoder.sh <fps> <output_basename>
# example:
sh movies/mencoder.sh 5 movie
```

Creates a movie from sequentially numbered PNG images in the current directory. Outputs both AVI and MOV files.

### dvd-rip/rip.sh

```sh
sh movies/dvd-rip/rip.sh
```

Rips a DVD to a file using 2-pass MPEG4 encoding with `mencoder`. Edit variables at the top of the script to configure the source device, title, and output filename.

### dvd-rip/extrair_legendas.sh

```sh
sh movies/dvd-rip/extrair_legendas.sh
```

Extracts subtitles from a DVD in VobSub format using `mencoder`. Configure device and chapter range in the script before running.
