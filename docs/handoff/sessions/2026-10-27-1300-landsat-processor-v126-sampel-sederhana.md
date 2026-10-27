---
date: 2026-10-27 13:00
source: claude-code
topic: landsat-processor-v126-sampel-sederhana
status: berlanjut
---

## Tujuan
Menyederhanakan bagian "3. Sampel" menu Pengambilan Plot: pengguna cukup memberi jumlah titik, sisanya otomatis. Latih/validasi/uji adalah urusan Forecasting.

## Keputusan dan alasannya
- Metode ditentukan dari masukan: ada layer strata maka berstrata, selain itu acak sederhana.
- Alokasi "auto": separuh sama rata, separuh proporsional (kelas langka tidak kosong); murni proporsional dinilai berisiko untuk ML.
- Raster strata kontinu otomatis 5 kuantil (dulu galat). Seed 42, pusat sel, tanpa jarak minimum.
- Kontrol subset, persen latih/validasi, statistik populasi dihapus dari UI; mesin tetap menerima parameternya.

## Yang ditolak atau gagal
- Menyembunyikan kontrol di panel lanjutan ditolak: permintaan pengguna eksplisit lebih praktis.
- Jarak minimum otomatis ditolak: menurunkan jumlah titik tanpa diminta.

## Hasil nyata
- core/sampling.py (auto_params, allocate auto, bins otomatis), gui/sampling_page.py, tes (590 lulus), i18n, README v126.

## Belum terverifikasi
- GUI di Windows nyata. Berikutnya: pengguna akan meninjau menu Forecasting.
