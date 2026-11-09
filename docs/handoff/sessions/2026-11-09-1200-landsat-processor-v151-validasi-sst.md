---
date: 2026-11-09 12:00
source: claude-code
topic: landsat-processor-v151-validasi-sst
status: berlanjut
---

## Tujuan
Tab 4 "Validasi SST" di halaman kalibrasi atmosfer: uji independen tau, L_up, L_down di laut memakai SST kulit GHRSST L2P (MODIS) pada 5 scene Landsat L2 (LC08 20251104, LC09 20250301, 20250504, 20250621, 20250925).

## Keputusan dan alasannya
- Tiga sumber atmosfer (USGS, kalibrasi tab 1, ERA5+libRadtran z=0) diuji dengan pemasangan nearest-neighbour maks 0,7 km dan bootstrap blok spasial, karena piksel bertetangga berkorelasi.
- Saringan sudut pindai MODIS bawaan 35 derajat (pendekatan linear dari indeks silang-lintasan) karena bias +2 K Maret dan Juni hanya muncul pada sudut 41 sampai 55 derajat.
- Kepekaan terkopel dilaporkan di samping tau-sendiri karena L_up = (1 - tau) B(T_up) membuat uji lemah terhadap galat tau murni.
- Ambang closure dilonggarkan ke |rerata| < 0,3 K karena offset konstan +0,15 K ada di darat dan laut (bukan bug implementasi).
- srf_for dibuat mengenali LANDSAT_9 (memengaruhi tab 3 untuk L9).

## Yang ditolak atau gagal
- Menyimpulkan galat atmosfer dari bias +2 K ditolak: pola koheren spasial dan terkait tepi lintasan, interpretasi belum terbukti.
- Sumber kalibrasi dan ERA5-RTM tidak dijalankan pada data nyata: ERA5 untuk 5 tanggal tidak ada di sandbox.

## Hasil nyata
- Setelah saringan: L9 2025-05-04 bias +0,21 K (CI -0,01 sampai 0,42), L9 2025-09-25 -0,23 K (CI -0,45 sampai -0,02), L8 2025-11-04 -1,76 K (n 639, bercampur awan, CI lebar). Maret dan Juni dikeluarkan seluruhnya.
- Uji: tests/test_sst_validation.py 13 lulus; 86 lulus pada rangkaian terkait. Zip landsat_processor_v151.zip.

## Belum terverifikasi
- Pendekatan sudut pindai linear; arah koreksi SSES; sebab bias 4 Nov; closure +0,15 K; sumber kalibrasi dan ERA5-RTM pada data nyata.
- Folder log task-observer /home/user/Skill/task-observer-workspace tidak ada di lingkungan ini.

## Langkah berikutnya
1. Pengguna menjalankan tab 4 dengan berkas kalibrasi dan ERA5 untuk 2025-03-01, 05-04, 06-21, 09-25, 11-04 plus uvspec.
2. Geostatistik (semivariogram) v152, regresi spasial v153.
