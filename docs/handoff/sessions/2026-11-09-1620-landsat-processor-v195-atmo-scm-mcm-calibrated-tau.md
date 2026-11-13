---
date: 2026-11-09 16:20
source: claude-code
topic: landsat-processor-v195-atmo-scm-mcm-calibrated-tau
status: berlanjut
---

# Landsat Processor v195

## Permintaan
Metode SCM dan MCM tidak muncul di hasil tab 2. Hasil harus dua kelompok (band 10 Level 2, Level 1) yang memakai model transmitansi kalibrasi tanpa profil Rozenstein, folder terpisah, dan W otomatis: berpasangan, selain itu rerata.

## Temuan
- Penyebab pasti di data pengguna belum terbukti. Tau Rozenstein hanya ditolak pada W ekstrem (>9 band 10, >6,5 band 11); MCM butuh B11/B4/B5 Level 1; kegagalan metode hanya masuk catatan di ujung log.

## Keputusan
- scm_jms baru (JMS dengan tau, Lup, Ldown per piksel dari kalibrasi). roz_jms tetap di API, dilepas dari GUI.
- MCM Qin/Mao: tau10 kalibrasi, tau11 = tau10^R (R dari Rozenstein, pendekatan). Skokovic hanya W.
- Status metode per jalur di log GUI, sheet Status_metode, LSTResult.method_status.
- W: pasangan bila ada, selain itu rerata. Kontrol sumber W, manual, ERA5, hari terdekat dihapus dari GUI.

## Ditolak / dibiarkan
- Varian pembanding atmosfer Rozenstein pada analisis dibiarkan (bukan penerapan LST).
- Hari terdekat tidak lagi ditawarkan; API w_fill tetap menyediakannya.

## Uji
1109 lulus, 4 dilewati. 7 uji baru; i18n 4218 kunci. Data nyata belum diperiksa.
