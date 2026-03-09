# PDF & PostScript

**Dependencies:** `pdftk`, `ghostscript` (`gs`), `impose`, `psselect`, `sam2p`, `eps2eps`

| Script | Description |
|--------|-------------|
| `eps2eps-batch.sh` | Batch process all EPS files with eps2eps, output to parent directory |
| `impose-batch.sh` | Batch apply impose (2-up) to files for printing |
| `impose-pdf.sh` | Convert PDF to 2-up layout for non-duplex printing |
| `par_impar_impose.sh` | Separate odd/even pages for non-duplex printers |
| `pdf_1page.sh` | Batch extract first page from PDFs |
| `pdf_2pages.sh` | Batch extract first 2 pages from PDFs |
| `pdf2eps.sh` | Batch convert PDFs to EPS (for academic papers) |
| `pdfshrink.sh` | Compress grayscale scanned PDFs via ghostscript |
| `sam2p-batch.sh` | Batch convert images (jpg, png) to EPS |

---

## Usage

### pdfshrink.sh

```sh
sh PDF-PS/pdfshrink.sh input.pdf output.pdf
```

Compresses a PDF using Ghostscript with the `ebook` quality preset. Useful for shrinking scanned grayscale documents.

### impose-pdf.sh

```sh
sh PDF-PS/impose-pdf.sh file1.pdf file2.pdf ...
```

Converts PDFs to PostScript, applies 2-up imposition, and fixes page ordering for non-duplex printing. Outputs `*.ps.imposed` files.

### impose-batch.sh

```sh
sh PDF-PS/impose-batch.sh <extension>
```

Batch version of impose — applies 2-up layout to all files matching the given extension.

### pdf_1page.sh

```sh
sh PDF-PS/pdf_1page.sh <output_dirname>
```

Extracts the first page of every PDF in the current directory and saves it to the specified output directory.

### pdf_2pages.sh

```sh
sh PDF-PS/pdf_2pages.sh
```

Extracts the first two pages of every PDF in the current directory and saves them to a `2pages/` subdirectory.

### pdf2eps.sh

```sh
sh PDF-PS/pdf2eps.sh
```

Batch converts all PDFs in the current directory to EPS format at publication quality.

### par_impar_impose.sh

```sh
sh PDF-PS/par_impar_impose.sh
```

Separates odd and even pages from PDFs for printing on non-duplex printers.

### sam2p-batch.sh

```sh
sh PDF-PS/sam2p-batch.sh <format>
# example:
sh PDF-PS/sam2p-batch.sh jpg
```

Batch converts image files of the given format (e.g., `jpg`, `png`) to EPS using `sam2p`.

### eps2eps-batch.sh

```sh
sh PDF-PS/eps2eps-batch.sh
```

Runs `eps2eps` on all EPS files in the current directory and writes output to the parent directory.
