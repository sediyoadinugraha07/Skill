---
date: 2026-10-25 21:00
source: claude-code
topic: landsat-processor-v123-forecasting
status: berlanjut
---

## Tujuan
Menu Prediksi > Forecasting berbasis tabel Excel dengan machine learning: pilih split latih/uji, keluaran Excel (X, Y, prediksi), heatmap korelasi, matriks konfusi, interpolasi, analisis lain.

## Keputusan dan alasannya
- Model terbaik dipilih dari validasi silang out-of-fold, bukan data uji, agar uji jujur. Ada uji otomatis yang membuktikannya.
- Pembanding dasar wajib (rerata, mayoritas, naif) karena model tanpa baseline tidak bisa dinilai (Makridakis 2018).
- Deret waktu: uji = periode terakhir, prakiraan rekursif, dan uji rekursif pada periode uji, karena kinerja satu langkah dengan lag aktual terlalu optimistis.
- Matriks konfusi untuk regresi lewat pembagian kelas (kuantil/lebar sama/sendiri) dari batas data latih.
- Interpolasi memakai fungsi menu Interpolasi (IDW, kriging, TIN, TPS), hanya di selubung titik.
- Excel memuat rumus yang mengaudit metrik; diverifikasi dengan LibreOffice.
- Versi 123 karena 122 sudah terkirim.

## Yang ditolak atau gagal
- Prediksi per piksel dari citra ditolak sementara (diminta fokus data dulu).
- Deep learning (torch) tidak dipasang; MLP sklearn dipakai. XGBoost/LightGBM hanya bila terpasang.
- Bug: pandas 3 memakai dtype str sehingga koma desimal tidak terdeteksi; diperbaiki.

## Hasil nyata
- core/forecast.py, forecast_report.py, forecast_plots.py, forecast_raster.py, gui/forecast_page.py, tests/test_forecast.py (41 uji), i18n +113 kunci, README v123. Suite penuh 575 lulus.
- Demo data Bali (sampel v122, target ST_B10, blok spasial): R2 uji 0,35 sampai 0,47; prediktor lereng dan bentuklahan lemah, ini temuan jujur bukan kesalahan.

## Belum terverifikasi
- GUI di Windows asli, dan waktu hitung pada tabel di atas 100 ribu baris.
- Rujukan Meyer 2019 (jurnal, volume), halaman Breiman/Friedman/Bergmeir, volume Gupta dan Hyndman perlu dicek.

## Langkah berikutnya
1. Umpan balik pengguna (perbaikan jadi v124).
2. Prediksi berbasis citra (prediktor raster ke peta per piksel), lag eksogen, model DL bila diminta.
