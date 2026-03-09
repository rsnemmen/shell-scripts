# File Utilities

**Dependencies:** `7z`, `jupyter`/`nbconvert`, `pv` (optional for progress bar)

| Script | Description |
|--------|-------------|
| `7z_unpack.sh` | Unpack all .7z archives in current directory |
| `batch-rename.sh` | Remove a string from filenames (case-insensitive) |
| `espacos-underscores.sh` | Replace spaces with underscores for a given extension |
| `jupyter2md.sh` | Recursively convert .ipynb notebooks to Markdown |
| `md5-batch.sh` | Generate MD5 checksums for all files; optional progress bar |
| `rm-invalid-filenames.sh` | Remove files with non-alphanumeric names; supports `--dry-run` |

---

## Usage

### batch-rename.sh

```sh
sh file-utilities/batch-rename.sh "<string_to_remove>"
# example:
sh file-utilities/batch-rename.sh "copy of "
```

Removes the specified string (case-insensitive) from all filenames in the current directory.

### md5-batch.sh

```sh
sh file-utilities/md5-batch.sh [-o output_file]
```

Generates MD5 checksums for all regular files in the current directory. If `pv` is installed, shows a progress bar.

Flags:

- `-o FILE` — write checksums to a file instead of stdout
- `-h` — show usage

### jupyter2md.sh

```sh
sh file-utilities/jupyter2md.sh
```

Recursively finds all `.ipynb` Jupyter notebooks in the current directory tree and converts them to Markdown using `jupyter nbconvert`. No images are extracted.

### rm-invalid-filenames.sh

```sh
sh file-utilities/rm-invalid-filenames.sh [--dry-run]
```

Recursively removes files and directories whose names contain only non-alphanumeric characters. Use `--dry-run` to preview what would be deleted without actually removing anything.

### 7z_unpack.sh

```sh
sh file-utilities/7z_unpack.sh
```

Extracts all `.7z` archives in the current directory using `7z`.

### espacos-underscores.sh

```sh
sh file-utilities/espacos-underscores.sh
```

Batch replaces spaces with underscores in filenames for files matching a configured extension in the current directory.
