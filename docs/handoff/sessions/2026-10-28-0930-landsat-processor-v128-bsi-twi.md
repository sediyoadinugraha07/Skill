---
date: 2026-10-28 09:30
source: claude-code
topic: landsat-processor-v128-bsi-twi
status: berlanjut
---

## Tujuan
Tambah indeks BSI di menu Vegetation Index dan analisis TWI (dari DEM, dengan langkah hidrologi dan Excel) di Advanced Analysis.

## Keputusan dan alasannya
- BSI Rikimaru dkk. 2002 (Landsat 8/9: B6,B4,B5,B2; Landsat 7: B5,B3,B4,B1); rumus dan sitasi dicek lewat eoreader dan AGRIS.
- TWI: Priority-Flood+epsilon, D8 atau FD8 (p=1,1), gradien menurun maksimum (Qin 2009) atau Horn, tan beta minimum 0,001, ln(a/tan beta). Akumulasi vektor (Kahn) agar 1,7 juta sel selesai ~10 detik.
- Versi 128 (127 sudah terkirim). Kode v127 hilang dari wadah sesi setelah wadah diganti; pengguna mengunggah ulang zip v127.

## Yang ditolak atau gagal
- Memasang BSI/TWI tanpa kode sumber ditolak; dibuat modul mandiri dahulu, lalu dipasang setelah zip v127 diunggah.
- Menghilangkan sel datar seperti TauDEM ditolak; dipakai batas bawah.

## Hasil nyata
- core/twi.py, core/twi_report.py, gui/twi_page.py, compute_bsi di core/vegetation_index.py, tests/test_twi.py (10), i18n, README v128. Suite 603 lulus (butuh fiona, shapely, pyhdf, netCDF4, xgboost, lightgbm di lingkungan baru).

## Belum terverifikasi
- Windows asli; BSI pada citra Landsat nyata; sitasi Beven-Kirkby, O'Callaghan-Mark, Quinn, Freeman, Horn dari ingatan.
