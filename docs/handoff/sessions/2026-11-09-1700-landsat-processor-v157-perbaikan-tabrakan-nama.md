---
date: 2026-11-09 17:00
source: claude-code
topic: landsat-processor-v157-perbaikan-tabrakan-nama
status: selesai
---

## Tujuan
Memperbaiki v156 yang menimpa fitur lama "Interpolasi Citra (Resolusi)".

## Keputusan dan alasannya
- v156 menulis core/interpolation.py, core/interpolation_report.py, gui/interpolation_page.py, tests/test_interpolation.py yang sudah ada; menu lama rusak. Keempat berkas lama dipulihkan dari v155 apa adanya.
- Kode tab Interpolasi Spasial dipindah ke spatial_interp*, kelas SpatialInterpPage; perilaku tidak berubah.
- Rilis sebagai v157 (nomor baru, zip v156 tidak ditimpa) sesuai aturan jejak versi. v156 ditandai RUSAK di README.
- Aturan baru: sebelum menulis berkas baru, cek namanya terhadap daftar zip versi sebelumnya.

## Hasil nyata
- Pemeriksaan v148 sampai v155: tidak ada tabrakan nama lain.
- Seluruh uji dijalankan per berkas. Lulus semua kecuali: test_twi, test_modis_lst (crash native, identik di v155 sehingga bukan akibat perubahan ini), dan test_atmo_lst (daftar tab basi sejak v151, sudah diperbaiki).

## Belum terverifikasi
- test_twi dan test_modis_lst crash native di lingkungan ini; penyebab belum diselidiki.

## Langkah berikutnya
1. Multi-temporal koreksi radiometrik Level 1 (v158).
