# Movies

**Dependencies:** `ffmpeg`, `mencoder`, `yt-dlp`

| Script | Description |
|--------|-------------|
| `get_transcript.sh` | Download YouTube title, description, and subtitles via yt-dlp |
| `mencoder.sh` | Create movie from sequential PNG files |

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
