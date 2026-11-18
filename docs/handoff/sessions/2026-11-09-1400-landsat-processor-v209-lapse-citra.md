---
date: 2026-11-09 14:00
source: claude-code
topic: landsat-processor-v209-lapse-citra
status: berlanjut
---

## Konteks
Pengguna melaporkan ET24 = 0 di pegunungan bervegetasi lebat (multitemporal Mao + Bandara dua titik) dan cLST/TEI tertinggi di pegunungan padahal LST asli lebih rendah.

## Keputusan
- Sebab: lapse tetap 0,006 (ET) dan 0,0065 (TEI) jauh di atas lapse teramati -0,0035 K/m (r -0,74). Ts_DEM/cLST naik terhadap ketinggian, piksel gunung melewati jangkar kering di dataran, H > Rn-G, Lambda dipotong 0, ET24 = 0.
- Perbaikan: estimate_scene_lapse (core/et_h_common.py) dan opsi lapse_mode "tetap"|"citra" di compute_bandara_h, run_et_l1_batch, compute_tei; peringatan bila lapse tetap > teramati + 0,002. GUI ET bawaan "Dari citra"; bawaan TEI tetap nilai naskah.
- Ditolak: mengubah bawaan inti ke "citra" diam-diam (hasil lama berubah tanpa sepengetahuan pengguna); memotong dT secara paksa.

## Belum
- Rantai Rn/G/rah data pengguna belum dijalankan ulang (hanya LST, cLST, ET24 diunggah). NDVI maks 2,07 belum diselidiki. Mao 2005 dan offset MCM per scene masih terbuka.
