---
date: 2026-11-09 20:00
source: claude-code
topic: landsat-processor-v169-vegetation-index-multitemporal
status: berlanjut
---

## Tujuan
Tab multi-temporal untuk Vegetation Index: masukan satu folder band hasil region mask, band dikenali dari nama berkas, pilih jenis citra dan index.

## Keputusan dan alasannya
- Peran band dari nomor band pada nama (_B<n>) menurut satelit di ID scene; memakai SENSOR_BAND_HINTS yang sudah ada. Nama berkas tidak boleh diubah (syarat dari pengguna).
- Keluarga band = akhiran nama setelah _B<n>; satu deret satu keluarga (prinsip uniform v152). DN mentah (tanpa akhiran), radiance, dan turunan ditolak.
- NDVI dinamai <sid>_NDVI.tif agar Emisivitas (scan ndvi_source=file) membacanya tanpa ubahan; diuji.
- 12 index; VCI dikeluarkan: butuh deret multi-tahun musim sama dan statistik per piksel, bukan satu folder campur tanggal.
- Menu Vegetation Index dibungkus host bertab (scroll_wrap) agar tab satu scene tetap bergulir.

## Yang ditolak atau gagal
- Tidak ada kegagalan. Excel sengaja sederhana (tanpa Cek_rumus).

## Hasil nyata
- core/vegetation_batch.py, gui/vegetation_batch_page.py, gui/vegetation_host.py, tests/test_vegetation_batch.py (4 uji), main_window dialihkan ke host, i18n 9 kunci (total 3768), README v169.

## Berikutnya
v170 Emisivitas disederhanakan (masukan folder NDVI, skala Pv di masukan, hapus cek hitung ulang). Uji pada data nyata.
