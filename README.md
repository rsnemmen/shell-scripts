Miscellaneous shell scripts
==========

Assorted shell scripts for performing different tasks, ranging from cleaning a directory of LaTeX documents to converting audio/video formats, managing game ROMs, and processing PDFs. Accumulated over many years, 60+ scripts spanning 10 categories.

## Usage

```sh
sh script.sh <arguments>
# or if executable:
./script.sh <arguments>
```

---

## Text & Document Processing (`text/`)

**Dependencies:** `pandoc`, `texcount`, `pdflatex`/`xelatex`, `sed`, `iconv`

| Script | Description |
|--------|-------------|
| `clean.sh` | Remove LaTeX build artifacts (`*.aux`, `*.log`, `*.bbl`, etc.) |
| `countwords.sh` | Count words in LaTeX files using texcount |
| `cpbib.sh` | Copy .bib file stripping hyperlinks for ApJ templates |
| `md_latex_delimiters.sh` | Convert `\(...\)` → `$...$` and `\[...\]` → `$$...$$` |
| `md2tex.sh` | Convert Markdown to LaTeX and render with pdflatex |
| `mdlatex2pdf.sh` | Convert Markdown with LaTeX math to PDF (most featureful) |
| `mdtex.sh` | Markdown → PDF via pandoc with custom geometry (xelatex) |
| `utf8.sh` | Batch convert files from ISO-8859-1 to UTF-8 |

---

## PDF & PostScript (`PDF-PS/`)

**Dependencies:** `pdftk`, `ghostscript` (`gs`), `impose`, `psselect`, `sam2p`

| Script | Description |
|--------|-------------|
| `pdf_1page.sh` / `pdf_2pages.sh` | Batch extract first 1 or 2 pages from PDFs |
| `pdf2eps.sh` | Batch convert PDFs to EPS (for academic papers) |
| `pdfshrink.sh` | Compress grayscale scanned PDFs via ghostscript |
| `impose-pdf.sh` | Convert PDF to 2-up layout for non-duplex printing |
| `par_impar_impose.sh` | Separate odd/even pages for non-duplex printers |
| `sam2p-batch.sh` | Batch convert images (jpg, png) to EPS |

---

## Music (`music/`)

**Dependencies:** `lame`, `sox`, `mpg123`, `ffmpeg`

| Script | Description |
|--------|-------------|
| `wav2mp3.sh` | WAV → MP3 (VBR) |
| `mp3wav.sh` | MP3 → WAV |
| `ogg2mp3.sh` | OGG → MP3 (160 kbps) |
| `reencode_mp3s.sh` | Re-encode MP3s to 56 kbps |
| `reencode-hevc.sh` | MKV/HEVC → H.264 MP4 (Raspberry Pi compatible) |

---

## Movies (`movies/`)

**Dependencies:** `ffmpeg`, `mencoder`, `yt-dlp`

| Script | Description |
|--------|-------------|
| `get_transcript.sh` | Download YouTube title, description, and subtitles via yt-dlp |
| `mencoder.sh` | Create movie from sequential PNG files |
| `dvd-rip/rip.sh` | Rip DVD to file with 2-pass encoding |
| `dvd-rip/extrair_legendas.sh` | Extract DVD subtitles in VobSub format |

---

## File Utilities (`file-utilities/`)

**Dependencies:** `7z`, `jupyter`/`nbconvert`, `pv` (optional)

| Script | Description |
|--------|-------------|
| `batch-rename.sh` | Remove a string from filenames (case-insensitive) |
| `espacos-underscores.sh` | Replace spaces with underscores for a given extension |
| `md5-batch.sh` | Generate MD5 checksums for all files; optional progress bar |
| `jupyter2md.sh` | Recursively convert .ipynb notebooks to Markdown |
| `rm-invalid-filenames.sh` | Remove files with non-alphanumeric names; supports `--dry-run` |
| `7z_unpack.sh` | Unpack all .7z archives in current directory |

---

## Gaming (`gaming/`)

**Dependencies:** `chdman`, `steamcmd`

| Script | Description |
|--------|-------------|
| `create_chd.sh` | Batch convert ISO/CUE disk images to CHD format |
| `steam_downloader.sh` | Download Steam games via SteamCMD |
| `move_them.sh` | Flatten nested directory structure |
| `rename.sh` | Strip leading numbering from filenames |
| `add_other_disks.sh` | Append missing disc files/playlists to a game list |
| `create_m3u.py` | Create M3U playlists for multi-disk ROMs (Python) |

---

## Image Processing (`image_processing/`)

**Dependencies:** `imagemagick`, `parallel`

| Script | Description |
|--------|-------------|
| `resizeComics.sh` | Resize CBZ comic files (70% size, quality 70) in parallel |
| `screenshots.sh` | Capture periodic GNOME screenshots to Dropbox |

---

## Transferring (`transferring/`)

**Dependencies:** `rsync`, `wget`

| Script | Description |
|--------|-------------|
| `csync.sh` | Sync current directory to remote server via rsync/SSH |
| `gdrive-download.sh` | Download file from Google Drive by FILE_ID |
| `dropbox.sh` | Start Dropbox daemon and monitor status |

---

## Mounting (`mount-images/`)

**Dependencies:** `sshfs`, `fusermount`, `mkisofs`, `cdrecord`

| Script | Description |
|--------|-------------|
| `mount_ssh.sh` / `umount_ssh.sh` | Mount/unmount remote directories via SSHFS |
| `dd.sh` | Copy DVD contents to ISO file |
| `imagem.sh` | Create ISO image from directory |
| `cdr.sh` / `cdrw.sh` | Burn data to CD-R / erase and burn CD-RW |

---

## System (`system/`)

| Script | Description |
|--------|-------------|
| `swap_used_macos.sh` | Display current swap memory usage on macOS |

---

# License

Copyright (c) 2024, [Rodrigo Nemmen](http://rodrigonemmen.com).
[All rights reserved](http://opensource.org/licenses/BSD-2-Clause).

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Visit the author's web page](https://rodrigonemmen.com/) and/or follow him on X ([@nemmen](https://twitter.com/nemmen)).
