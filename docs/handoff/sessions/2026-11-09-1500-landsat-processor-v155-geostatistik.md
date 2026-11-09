---
date: 2026-11-09 15:00
source: claude-code
topic: landsat-processor-v155-geostatistik
status: berlanjut
---

## Tujuan
Tab Geostatistik di Advanced Analysis: semivariogram, model, validasi silang, kriging biasa (lanjutan autokorelasi v150).

## Keputusan dan alasannya
- Model dipilih dari RMSE validasi silang LOO, bukan kecocokan visual: bin lag dengan sedikit pasangan membuat kecocokan visual menipu.
- Kriging isotropik; variogram arah hanya diagnosis. Ambang peringatan anisotropi dinaikkan ke rasio 2: uji pada medan isotropik memberi rasio sampai 2 akibat derau sampling (domain hanya sekitar 5 kali range).
- Raster disampel acak (maks 4000 titik) karena pasangan tumbuh kuadrat; konsekuensinya nugget kurang pasti.
- Transformasi skor normal ditolak (tidak dapat dibalik untuk kriging); hanya none dan log1p. Dengan log1p simpangan baku tidak diberikan pada skala asli.
- Rumus Excel validasi silang dicocokkan dengan Python lewat LibreOffice; menemukan dan memperbaiki kolom pengamatan yang salah (nilai asli, bukan residu tren).

## Yang ditolak atau gagal
- Kriging berbasis perpustakaan luar (PyKrige, gstat) ditolak: tidak terpasang; verifikasi memakai penyelesaian langsung.
- Variogram eksak raster lewat FFT ditunda (lebih akurat pada lag kecil, belum dibangun).

## Hasil nyata
- core/geostat.py, core/geostat_report.py, gui/geostat_page.py, tests/test_geostat.py (12 uji), i18n 24 kunci, README v155, daftar tab Advanced Analysis diperbarui.

## Belum terverifikasi
- Data nyata (LST, TEI Bali) dan pembandingan dengan gstat/GSLIB.
- Perilaku varians kriging pada medan halus (MSDR 0,08 sampai 0,3 pada uji).

## Langkah berikutnya
1. Pengguna mencoba pada raster LST nyata dan membaca MSDR dan range efektif.
2. Regresi spasial (GWR/MGWR) v156; WUP menunggu artikel.
