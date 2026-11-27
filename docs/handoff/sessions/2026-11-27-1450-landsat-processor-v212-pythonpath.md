---
date: 2026-11-27 14:50
source: claude-code
topic: landsat-processor-v212-pythonpath
status: berlanjut
---

## Tujuan
main.py dobel-klik gagal (numpy.exceptions hilang) walau Python 3.11 sama dengan jalankan.bat yang berhasil.

## Keputusan dan alasannya
- Dugaan v210/v211 (salah pilih Python) gugur: jendela galat menunjukkan Python311 yang sama.
- PYTHONPATH pengguna menunjuk folder Python ERDAS IMAGINE 2015. v212 membuang folder PYTHONPATH dari sys.path di awal main.py (LP_KEEP_PYTHONPATH=1 mematikan) dan mengosongkannya di jalankan.bat.
- Jendela galat memuat versi dan lokasi numpy, PYTHONPATH, sys.path.

## Yang ditolak atau gagal
- Klaim penyebab pasti ditolak: `python -c "import numpy"` memuat numpy 2.4.6 dari site-packages di komputer pengguna, jadi PYTHONPATH belum terbukti menyebab galat. Penyebab selisih dobel-klik dan jalankan.bat masih terbuka.

## Hasil nyata
- landsat_processor_v212.zip; tests/test_main_bootstrap.py 11 lulus. Suite penuh belum dijalankan (kontainer tanpa rasterio/PySide6).

## Belum terverifikasi
- Belum dicoba di Windows pengguna.

## Langkah berikutnya
1. Pengguna mencoba dobel-klik main.py; bila gagal, kirim error_log.txt (kini memuat lokasi numpy dan sys.path).
