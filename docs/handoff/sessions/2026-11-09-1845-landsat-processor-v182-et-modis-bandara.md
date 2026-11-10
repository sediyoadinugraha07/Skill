---
date: 2026-11-09 18:45
source: claude-code
topic: landsat-processor-v182-et-modis-bandara
status: berlanjut
---

## Konteks
Pengguna (18:36): semua pengolahan MODIS berasal dari MOD021KM (LST dari band 31 dan 32, NDVI dari reflektansi), awan dan uap air memakai menu yang sudah ada, Waters nanti memakai MODIS ET (MOD16) sebagai data pendukung. Sampel MOD021KM akan diunggah. Lanjut ke tahap berikutnya.

## Dibuat (v182)
- core/et_modis.py: run_et_modis_bandara memakai _chain yang sama dengan Landsat; tanpa topografi; metadata dari *_MTL_MODIS.txt.
- gui/et_modis_page.py, menu MODIS > ET MODIS. tests/test_et_modis.py (6). i18n ex182, README v182.

## Keputusan
- Tidak mengubah kode ET Landsat. Grid kerja = grid LST. Tanpa metadata = tidak diproses.
- Ambang piksel valid 300 (tolak) dan 2000 (peringatan) karena 1 km.

## Ditolak
- Koreksi topografi untuk MODIS; menebak waktu rekam.

## Belum diverifikasi
Tabel r0 Chemin mulai 12.00 vs Terra 10.30; format atribut HDF nyata; MOD16 untuk Waters.

## Berikutnya
v183 ET MODIS multi-temporal (folder per granul), lalu Waters.
