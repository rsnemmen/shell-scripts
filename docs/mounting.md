# Mounting

**Dependencies:** `sshfs`, `fusermount`, `mkisofs`, `cdrecord`, `dd`, `mount`

| Script | Description |
|--------|-------------|
| `cdr.sh` | Burn data ISO to CD-R |
| `cdrw.sh` | Erase and burn ISO to CD-RW |
| `dd.sh` | Copy DVD contents to ISO file |
| `imagem.sh` | Create ISO image from directory |
| `mount_ssh.sh` | Mount remote directories via SSHFS |
| `mount_usb.sh` | Mount USB flash drive |
| `umount_ssh.sh` | Unmount remote SSHFS mount points |

---

## Usage

### mount_ssh.sh

```sh
sh mount-images/mount_ssh.sh
```

Mounts remote server directories (home, downloads, iso) via SSHFS with keepalive. Edit the server address and mount points in the script before use.

### umount_ssh.sh

```sh
sh mount-images/umount_ssh.sh
```

Unmounts the SSHFS mount points configured in `mount_ssh.sh` using `fusermount`.

### dd.sh

```sh
sh mount-images/dd.sh <output_filename>
# example:
sh mount-images/dd.sh movie.iso
```

Reads a DVD from the default device and creates a disk image file using `dd`.

### imagem.sh

```sh
sh mount-images/imagem.sh <output.iso> <source_directory>
# example:
sh mount-images/imagem.sh archive.iso ./myfiles
```

Creates an ISO image from a directory using `mkisofs`.

### cdr.sh

```sh
sh mount-images/cdr.sh <image_file>
# example:
sh mount-images/cdr.sh archive.iso
```

Burns an ISO image to a blank CD-R at speed 20 using `cdrecord`.

### cdrw.sh

```sh
sh mount-images/cdrw.sh <image_file>
# example:
sh mount-images/cdrw.sh archive.iso
```

Erases a CD-RW and burns the specified ISO image at speed 20 using `cdrecord`.

### mount_usb.sh

```sh
sh mount-images/mount_usb.sh
```

Mounts a USB flash drive (`/dev/sdb1`) to `/mnt/removable` with FAT filesystem options. Edit the device path in the script if needed.
