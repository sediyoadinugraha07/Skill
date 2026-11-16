---
date: 2026-11-09 18:15
source: claude-code
topic: landsat-processor-v202-era5-sumber-w
status: berlanjut
---

# Landsat Processor v202: ERA5 sebagai sumber W di tab 3

Permintaan pengguna (2026-11-16 17:51): ERA5 jadi pilihan, dikombinasikan dengan W yang ada atau semua ERA5, untuk semua perhitungan LST.

## Analisis dasar (data pengguna 9d2d317f-ERA_5.zip, titik sekitar Karangasem, 02:20 UTC)
- ERA5 TCWV vs W tab 1 (MOD07 IR): n 10, r 0,95, c = 1,21 sampai 1,22, RMSE LOO 0,41 vs 1,22 cm (konstan). Tahan terhadap lokasi titik (r 0,94 sampai 0,96).
- ERA5 vs W NIR tab 1: n 8, r 0,76. ERA5 vs W Nugraha: n 6, r 0,47, CV W Nugraha 3,9% vs 14,9%.

## Dibuat
- core/wv_apply.py: era5_tcwv_table, era5_value, fit_era5_scale, build_w_source (sumber nug_era5, era5_all, nug_mean), override_w memprioritaskan Nugraha, ERA5, hari terdekat, rata-rata.
- GUI tab 3: sumber W, berkas ERA5, mode dan nilai faktor; worker memakai build_w_source.
- Tes 23 di test_wv_apply.py (ERA5 sintetis), suite penuh 1165 lolos, 4 dilewati; dijalankan juga pada ERA5 dan kalibrasi nyata (c = 1,224).

## Keputusan
- Bawaan: Nugraha bila ada, ERA5 untuk sisanya, rata-rata terakhir. Alasan: pengguna ingin menguji W Nugraha.
- "Semua perhitungan LST" ditafsirkan sebagai semua perhitungan di tab 3. Tab 2 dan menu Multitemporal tidak diubah (tab 2 harus tetap).

## Belum
- Dampak ke LST (K) belum diukur; faktor dipaskan dari data sama (n 10); ERA5 titik pusat AOI sel 0,25 derajat; MOD07 tidak independen dari model atmosfer; Nov dan Des 2025 di luar rentang scene tab 1.
- Menu Multitemporal masih merata-ratakan seluruh raster W.
