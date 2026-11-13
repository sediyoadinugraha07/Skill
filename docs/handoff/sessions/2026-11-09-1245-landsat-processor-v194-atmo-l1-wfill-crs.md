---
date: 2026-11-09 12:45
source: claude-code
topic: landsat-processor-v194-atmo-l1-wfill-crs
status: berlanjut
---

# Landsat Processor v194

## Permintaan
Tab 2 Kalibrasi Atmosfer: (a) scene tanpa pasangan W (awan) tetap diproses, (b) hapus pemilih profil Rozenstein (grup 4 Pengaturan), (c) pisahkan LST band 10 Level 2 dan Level 1 per folder, (d) grup sistem koordinat baru, (e) emisivitas ikut sumber band termal.

## Keputusan
- Pengisian W: hari terdekat (bawaan), rerata, atau lewati; batas hari opsional. Scene terisi tidak ikut statistik gabungan dan LOSO.
- Keluaran: LST_Level2_band10/<id>/ dan LST_Level1/<id L1>/ + Ringkasan_Level1.xlsx. MCM dipindah ke jalur Level 1.
- Emisivitas: L1 dari B4/B5 L1 (TOA, DOS opsional), L2 dari SR; ST_EMIS dipakai konsisten di keduanya. Tanpa fallback diam-diam.
- CRS: modul koordinat yang ada (core/atmo_crs.py, gui/crs_choice.py); reproyeksi pada raster hasil.

## Ditolak / dibiarkan
- Profil Rozenstein tetap bawaan mid_latitude_summer untuk metode roz (belum dibuang varian roz).
- Sheet Sampel_MCM berumus hidup tidak lagi dibuat.

## Uji
1102 lulus, 4 dilewati. Tes baru tests/test_atmo_lst_l1.py (13). Data nyata belum diperiksa. i18n 4211 kunci.
