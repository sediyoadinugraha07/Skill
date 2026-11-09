---
date: 2026-11-09 20:48
source: claude-code
topic: landsat-processor-v176-modis-uapair-emisivitas-multitemporal
status: berlanjut
---

## Ringkasan
v176: tab "Multi-temporal (semua granul)" untuk MODIS Uap Air (W) dan MODIS Emisivitas; kedua menu menjadi host bertab bersama menu lama.

## Keputusan
- Satu modul `core/modis_wv_emis_batch.py`, memakai ulang helper v175 (`group_granules`, `_key`, resume `_proses.json`). Fungsi hitung sama dengan menu satu berkas (`estimate_water_vapor`, `MODISEmissivityJob`).
- Uap Air: tiga folder dipasangkan menurut (platform, tanggal, waktu) dari nama berkas; band dari `_B0n_ref`/`_B0n_rad`; satu keluarga akhiran yang lengkap per granul; sampel regresi otomatis; komponen W17/18/19 ikut ditulis seperti menu satu berkas.
- Emisivitas: masukan NDVI per granul; Pv bawaan 0.2/0.5 atau manual; Sobrino (r1 opsional), Tang (b1..b7 wajib), Valor-Caselles; Mean/Delta untuk metode NDVI Threshold saja (VC satu raster).
- Tang memakai ambang tetap 0.2/0.5, batas manual diabaikan dan dicatat.
- Urutan combo metode: Sobrino, Tang, Valor-Caselles (bawaan Sobrino, seperti Landsat bawaan NDVI Threshold).
- test_modis_emissivity::test_gui disesuaikan: menu kini mendaftarkan host, bukan halaman tunggal.

## Ditolak
- Menyatukan folder W/reflektansi/radiance menjadi satu isian (peran band bertabrakan dan produk Level 2 vs L1B tidak sejajar).
- Membuat Delta untuk Valor-Caselles (selalu 0).

## Batas dan belum diverifikasi
- Hanya data sintetis; belum diuji pada granul MODIS nyata dan ratusan granul.
- Reflektansi TOA pada Sobrino/Tang; W dikalibrasi pada MOD05.
- Terbuka: konfirmasi v174 (BT), `_find_emis` di core/atmo_lst.py, crash native test_twi/test_modis_lst.
