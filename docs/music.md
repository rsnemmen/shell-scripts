# Music

**Dependencies:** `lame`, `sox`, `mpg123`, `ogg123`, `ffmpeg`

| Script | Description |
|--------|-------------|
| `mp3wav.sh` | MP3 → WAV (44100 Hz, stereo) |
| `ogg2mp3.sh` | OGG → MP3 (160 kbps stereo) |
| `reencode-hevc.sh` | MKV/HEVC → H.264 MP4 (Raspberry Pi compatible) |
| `reencode_mp3s.sh` | Re-encode MP3s to 56 kbps |
| `wav2mp3.sh` | WAV → MP3 (VBR) |

---

## Usage

### wav2mp3.sh

```sh
sh music/wav2mp3.sh
```

Batch converts all WAV files in the current directory to MP3 using `lame` with VBR quality settings.

### mp3wav.sh

```sh
sh music/mp3wav.sh
```

Batch converts all MP3 files in the current directory to WAV (44100 Hz, 2-channel) using `mpg123` and `sox`.

### ogg2mp3.sh

```sh
sh music/ogg2mp3.sh
```

Batch converts all OGG files in the current directory to MP3 at 160 kbps stereo using `ogg123` and `lame`.

### reencode_mp3s.sh

```sh
sh music/reencode_mp3s.sh file1.mp3 file2.mp3 ...
```

Re-encodes MP3 files to 56 kbps, 44.1 kHz using `mpg123`, `sox`, and `lame`. Useful for reducing file size of spoken-word recordings.

### reencode-hevc.sh

```sh
sh music/reencode-hevc.sh
```

Batch converts all MKV files (HEVC/H.265) in the current directory to H.264 MP4 for Raspberry Pi compatibility using `ffmpeg`.
