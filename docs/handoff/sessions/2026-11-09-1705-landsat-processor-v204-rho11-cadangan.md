---
date: 2026-11-09 17:05
source: claude-code
topic: landsat-processor-v204-rho11-cadangan
status: berlanjut
---

# Landsat Processor v204

## Yang dikerjakan
- Laporan pengguna: tab 3, W Nugraha penuh tanpa skala, tanpa ERA5, rho11 kosong, MCM tidak dihasilkan.
- Penyebab: tau10 sekitar 0,92 sehingga ln(tau10) mendekati 0; pemaskan rho11 menempel di batas 4,0 dan ditolak penjaga fisik. Bukan galat rumus.
- Perbaikan di `core/atmo_lst_l1.py`: bila rho11 kosong dan tau10 median sampel > 0,90, pemaskan dilewati dan dipakai rho11 cadangan (rasio Rozenstein pada W 3 g/cm2, sekitar 1,66), dengan catatan, peringatan dan sheet Rho11 yang menandainya. Penolakan karena band 11 rusak tetap tidak diganti cadangan.
- Pemeriksaan rumus MCM: Qin dan Mao versi Nugraha identik (0,000 K), Mao original beda 0,03 sampai 0,06 K (domain linearisasi). Skrip uji ada di sesi, belum dimasukkan ke repo.
- Tes: 1170 lulus, 4 dilewati (suite penuh). Segfault malloc di akhir run adalah noise yang sudah dikenal.

## Ditolak atau tidak dilakukan
- Cadangan tidak dipakai untuk kasus band 11 rusak, supaya data buruk tidak tersamarkan.
- rho11 cadangan 1,85 (hasil uji SST pengguna) tidak ditanam di aplikasi karena spesifik data pengguna.

## Terbuka
- Verifikasi persamaan MCM terhadap teks makalah rujukan.
- Penyebab selisih MCM per scene (10 April, 8 Agustus, 4 November).
