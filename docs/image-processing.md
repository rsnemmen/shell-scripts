# Image Processing

**Dependencies:** `imagemagick`, `parallel`, `scrot` (Linux, for screenshots)

| Script | Description |
|--------|-------------|
| `resizeComics.sh` | Resize CBZ comic files (70% size, quality 70) in parallel |
| `screenshots.sh` | Capture periodic GNOME screenshots to Dropbox |

---

## Usage

### resizeComics.sh

```sh
sh image_processing/resizeComics.sh file1.cbz file2.cbz ...
```

Batch processes CBZ comic archive files: extracts images, resizes them to 70% of original dimensions at quality 70 using ImageMagick, then recompresses into CBZ. Processing is parallelized with GNU `parallel`.

### screenshots.sh

```sh
sh image_processing/screenshots.sh
```

Captures a screenshot every 4 hours on Linux (using `scrot`) and saves it to `~/Dropbox/Screenshots/ubuntu/`. Useful for keeping a visual log during long-running tasks. Runs indefinitely until interrupted.
