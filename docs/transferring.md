# Transferring

**Dependencies:** `rsync`, `wget`, `scp`, `lftp`, `dropbox`

| Script | Description |
|--------|-------------|
| `backup.sh` | Backup home directory to encrypted external drive via rsync |
| `backup_cp.sh` | Backup data directories via cp to external drive |
| `csync.sh` | Sync current directory to remote server via rsync/SSH |
| `dropbox.sh` | Start Dropbox daemon and monitor status |
| `figshare_upload.sh` | Upload files from current directory to Figshare via FTPS |
| `gdrive-download.sh` | Download file from Google Drive by FILE_ID |
| `upload.sh` | Create ISO from DVD, compress, and upload to remote server |

---

## Usage

### csync.sh

```sh
sh transferring/csync.sh <user@remoteserver> <remote_path>
# example:
sh transferring/csync.sh user@myserver.com /home/user/data
```

Syncs the current directory to a remote server via rsync over SSH. Uses `--delete` to mirror the local state and shows transfer progress.

### figshare_upload.sh

```sh
sh transferring/figshare_upload.sh
```

Interactive uploader for Figshare datasets. Run from the directory containing the files to upload. Prompts for FTP credentials (username + generated password from the Figshare Integrations page), a dataset title, and confirms the file list before connecting. Uses `lftp` over FTPS to mirror the directory into a named folder under `data/` on `ftps.figshare.com`. Transfers are resumable if interrupted.

### gdrive-download.sh

```sh
sh transferring/gdrive-download.sh <FILE_ID> <output_filename>
# example:
sh transferring/gdrive-download.sh 1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs25ZWksJkvtI data.csv
```

Downloads a file from Google Drive using `wget` with the given file ID (from the sharing URL).

### dropbox.sh

```sh
sh transferring/dropbox.sh
```

Starts the Dropbox daemon and monitors its status with `watch`. Press `Ctrl-C` to stop monitoring.

### backup.sh

```sh
sh transferring/backup.sh
```

Interactive script that backs up `~/media/sda2/home` to a TrueCrypt-encrypted external drive via `rsync`.

### backup_cp.sh

```sh
sh transferring/backup_cp.sh
```

Interactive backup script that copies data directories to a TrueCrypt volume and an external hard drive using `cp`.

### upload.sh

```sh
sh transferring/upload.sh
```

Creates an ISO from a DVD, compresses it with `gzip`, computes an MD5 checksum, and uploads the result to a remote server via `scp`.
