# System

macOS system monitoring utilities.

| Script | Description |
|--------|-------------|
| `swap_used_macos.sh` | Display current swap memory usage on macOS |

---

## Usage

### swap_used_macos.sh

```sh
sh system/swap_used_macos.sh
```

Reports the current swap memory usage on macOS by parsing `sysctl` output. Useful for checking memory pressure on systems without a GUI monitor.
