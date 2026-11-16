---
date: 2026-11-09 11:15
source: claude-code
topic: landsat-processor-v199-rho11-excel
status: berlanjut
---

# Landsat Processor v199: rho11 tercatat di Excel

## Keputusan
- Dari berkas tab 2 pengguna ditemukan rho11 hanya di log GUI, tidak di Ringkasan_Level1.xlsx. Penjelasan v198 yang menyebut sheet Catatan memuat rho11 keliru.
- Sheet baru Rho11 (asal, nilai, alasan tolak, n, RMSE, bias, per scene) dan catatan rho11 di sheet Catatan.
- Suite 1142 lulus, 4 dilewati.

## Temuan belum selesai
- Pada data pengguna, Qin/Mao asli minus kalibrasi berkisar -2,8 sampai +7,95 K, lereng 0,54-0,93; Qin dan Mao asli beda rerata hanya ~0,02 K di semua scene. Penyebab belum diselidiki, perlu angka rho11 dan RMSE dari log.
