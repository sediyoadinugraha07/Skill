---
date: 2026-11-08 17:50
source: claude-code
topic: landsat-processor-v149-mtl-json-k1k2
status: berlanjut
---

## Tujuan
Menganalisis galat tab 3 (ERA5) yang dilaporkan pengguna: TypeError ufunc 'divide' di bt_to_radiance, dan menilai status SST.

## Keputusan dan alasannya
- Penyebab yang direproduksi: nilai MTL.json berupa string, jadi K1/K2 teks. Diperbaiki di parser JSON, pemilihan MTL (txt diutamakan), dan konversi float; scene tanpa K2 dilewati.
- Belum terbukti bahwa folder pengguna memakai MTL.json; itu penjelasan yang cocok dengan pesan galat dan bisa direproduksi, tetapi data asli belum diperiksa.
- Tab uji SST BELUM dibangun. Yang ada hanya skrip analisis satu kali di scratchpad (sea2.py) pada tiga granule GHRSST MODIS L2P SSTskin (12 Jul 2024, 10 Apr 2025, 12 Sep 2026) berpasangan dengan Landsat L2.

## Hasil nyata
- v149: core/mtl_parser.py, core/atmo_scan.py, core/atmo_rtm_bench.py, 3 uji baru, README, landsat_processor_v149.zip.
- Hasil SST skrip (bias RTM REPTRAN terhadap SST kulit): -1,17 K, -0,41 K, -1,40 K; ST_B10 USGS: -0,51, +2,52, +0,72 K. Hanya tiga tanggal, satu tanggal dengan 44 piksel.

## Belum terverifikasi
- Penyebab galat pada data asli pengguna.
- Perbedaan waktu lintasan SST dan Landsat (55 menit, 3 menit, 125 menit), emisivitas air di ST_EMIS, dan galat SST sendiri belum dikuantifikasi.

## Langkah berikutnya
- Pengguna menjalankan ulang tab 3 dengan v149 dan melaporkan hasil atau galat baru.
- Tab SST dibangun bila pengguna setuju, nomor versi berikutnya (v150).
