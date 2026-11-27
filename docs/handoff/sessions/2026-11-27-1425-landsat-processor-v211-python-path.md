---
date: 2026-11-27 14:25
source: claude-code
topic: landsat-processor-v211-python-path
status: berlanjut
---

## Tujuan
Dobel-klik main.py harus berjalan lagi. jalankan.bat (v210) berhasil, main.py tidak.

## Keputusan dan alasannya
- Dugaan sebab: pemeriksaan v210 hanya menguji PySide6, numpy, rasterio, sehingga Python lain yang punya ketiganya lolos dan gagal di pustaka berikutnya (belum terbukti di komputer pengguna).
- python_path.txt kini menentukan Python: bila ada, berbeda (realpath) dan lolos uji impor (PySide6, numpy, scipy, rasterio), main.py menjalankan ulang dengannya; bila gagal jatuh ke pencarian lama. LP_NO_PIN=1 mematikan.

## Yang ditolak atau gagal
- Memasang paket otomatis ditolak (mengubah lingkungan tanpa izin). Mengabaikan python_path.txt demi pemeriksaan pustaka ditolak: tidak deterministik.

## Hasil nyata
- landsat_processor_v211.zip; tests/test_main_bootstrap.py 9 lulus (termasuk relaunch nyata di Linux).

## Belum terverifikasi
- Belum dicoba di Windows pengguna. Suite penuh belum dijalankan ulang (kontainer tanpa rasterio/PySide6); perubahan hanya di main.py, test baru, README, nomor versi.
- Galat numpy.exceptions pengguna (numpy lama/rusak di Python 3.11) ditangani dengan perintah pip, bukan kode.

## Langkah berikutnya
1. Pengguna mencoba dobel-klik main.py dengan v211.
