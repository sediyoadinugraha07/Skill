---
date: 2026-11-09 16:00
source: claude-code
topic: landsat-processor-v156-interpolasi-spasial
status: berlanjut
---

## Tujuan
Tab Interpolasi Spasial: membandingkan metode interpolasi titik ke grid secara jujur lalu menulis raster metode terpilih.

## Keputusan dan alasannya
- Permintaan pengguna "v156 mengenai spasial interpolasi" menggantikan rencana lama v156 = regresi spasial (GWR/MGWR); GWR/MGWR bergeser ke v157.
- Peringkat metode memakai validasi blok spasial, bukan acak: pada titik bergerombol RMSE acak terlalu optimistis.
- Perbandingan pada himpunan titik yang diprediksi semua metode (TIN gagal di luar cangkang cembung).
- Kriging memakai kode v155; variogram dicocokkan sekali (sedikit optimistis, dicatat).
- Masukan raster diizinkan tetapi diberi peringatan: itu reproduksi raster, bukan interpolasi pengamatan.
- Tanpa kovariat di tab ini (regresi-kriging atau GWR ditunda).

## Yang ditolak atau gagal
- Natural neighbor ditolak: tidak ada di scipy, implementasi sendiri tidak sebanding.
- Pangkat IDW optimum cenderung menempel ke batas 5 pada data bergerombol dan bertren; diberi peringatan, bukan dipaksa.

## Hasil nyata
- core/interpolation.py, core/interpolation_report.py, gui/interpolation_page.py, tests/test_interpolation.py (9 uji), i18n 21 kunci, README v156, daftar tab diperbarui.

## Belum terverifikasi
- Data stasiun nyata (mis. suhu atau curah hujan Bali) dan pembandingan dengan SIG lain.

## Langkah berikutnya
1. Diskusi multi-temporal untuk beberapa menu (permintaan pengguna berikutnya).
2. Regresi spasial GWR/MGWR (v157); WUP menunggu artikel.
