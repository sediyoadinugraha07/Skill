---
date: 2026-11-09 18:10
source: claude-code
topic: landsat-processor-v197-tau11-fit-from-calibration
status: berlanjut
---

# Landsat Processor v197

## Permintaan
tau band 11 harus menjadi bagian dari hasil kalibrasi, tidak memakai Rozenstein, walau ada kekurangan.

## Fakta
Data kalibrasi (ST_ATRAN/URAD/DRAD, W MODIS) hanya band 10. Tidak ada pengamatan tau band 11. Modul RTM hanya memuat SRF band 10.

## Keputusan
- tau11 = tau10^rho11 per piksel; rho11 dipaskan (satu parameter, gabungan semua scene L1) agar LST band 11 konsisten dengan LST band 10 kalibrasi. Lintasan sampel tambahan hanya bila Qin/Mao dicentang.
- rho11 <= 1 atau menempel batas kisaran (0,6-4): Qin/Mao tidak dihitung dengan alasan di status metode; tidak fallback ke Rozenstein.
- Diagnostik rho11 (gabungan dan per scene, RMSE, bias) di log GUI dan LSTResult.l1_rho11.

## Ditolak / belum
- Sirkular terhadap LST band 10; bias band 11 terserap ke rho11. Diungkapkan di GUI dan README.
- RTM libRadtran dengan SRF band 11 TIRS dan pengamatan laut (SST GHRSST) belum dibuat: butuh SRF band 11 dan uvspec, tidak bisa diuji di sini.
- Fixture diubah: B11 kini fisik (rho sebenarnya 1,4).

## Uji
1118 lulus, 4 dilewati. rho 1,4 pulih 1,42 pada fixture. Scene nyata belum.
