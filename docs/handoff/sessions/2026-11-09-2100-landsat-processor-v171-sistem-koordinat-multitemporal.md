---
date: 2026-11-09 21:00
source: claude-code
topic: landsat-processor-v171-sistem-koordinat-multitemporal
status: berlanjut
---

## Tujuan
Menu Sistem Koordinat bisa membaca hasil Region Masking multi-temporal lewat satu tombol dan menulis hasil per folder scene.

## Keputusan dan alasannya
- Tidak ada tab baru: tombol di halaman yang ada, sesuai permintaan. Core baru reproject_multitemporal membungkus reproject_raster_file.
- Nama berkas hasil TIDAK diberi akhiran CRS: menu lanjutan membaca peran band dari nama (v169), dan folder hasil sudah terpisah.
- region_mask.tif dan berkas mask dilewati (geoms.json di CRS lama).
- Folder hasil di dalam folder masukan ditolak; bawaan <masukan>_koordinat.
- Peringatan grid berbeda karena pengolahan lanjutan butuh grid identik.

## Yang ditolak atau gagal
- Uji GUI awal abort native karena QThread inspeksi masih jalan saat objek dihancurkan; uji menunggu thread. Bukan cacat aplikasi, tetapi menutup halaman saat inspeksi berjalan belum dijaga.

## Hasil nyata
- core/reprojection.py (list_scene_rasters, reproject_multitemporal), gui/reprojection_page.py, tests/test_reprojection_multitemporal.py (5 uji), i18n 3 kunci, README v171.

## Berikutnya
Uji rantai nyata Cloud -> Region -> Sistem Koordinat -> Vegetation Index -> Emisivitas; _find_emis; crash test_twi dan test_modis_lst.
