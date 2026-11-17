---
date: 2026-11-09 18:05
source: claude-code
topic: landsat-processor-v205-paket-bukti
status: berlanjut
---

# Landsat Processor v205

## Yang dikerjakan
- Permintaan: tabel regresi transmitansi yang jelas, tabel lain, dan plot LST dan LSE sebagai bukti untuk artikel jurnal internasional (LST terapan dipakai pada TEI).
- Baru `core/atmo_evidence.py`, dipanggil dari worker tab 2 dan tab 3: `<nama>_bukti.xlsx` (sheet Tabel_Transmitansi, Regresi_k0, Regresi_L, Statistik_LST_LSE, Rho11, Grafik, Peta; grafik asli Excel) dan peta PNG di `bukti/`.
- Regresi L pada rentang suhu tetap cocok dengan Tabel 1 Rozenstein 2014; kubik Jin 2015 cocok dengan Tabel 4 dalam SEE.
- Raster Level 2 kini menulis `_emisivitas.tif`; `lst_mcm` menyimpan RMSE regresi band 10 dan 11.
- Tes: 1173 lulus, 4 dilewati (suite penuh).

## Ditolak atau tidak dilakukan
- Tabel Jin Tabel 4 tidak disalin utuh; dipakai kubik Tabel 5 (rumus) agar tidak menyalin tabel penulis lain.
- Tidak mengubah perhitungan LST; modul bukti hanya membaca hasil.

## Terbuka
- Tab 4 (ERA5-RTM) dan tab 5 (SST) belum punya paket bukti serupa (peta, tabel W dengan tau).
- Regresi L rentang tetap hanya K2 nominal Landsat 8.
- Verifikasi tanda A0 Qin terhadap makalah Qin 2001b; verifikasi persamaan MCM terhadap makalah rujukan.
