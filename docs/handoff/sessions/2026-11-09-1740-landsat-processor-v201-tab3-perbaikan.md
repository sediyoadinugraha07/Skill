---
date: 2026-11-09 17:40
source: claude-code
topic: landsat-processor-v201-tab3-perbaikan
status: berlanjut
---

# Landsat Processor v201: perbaikan tab 3

Koreksi pengguna atas v200 (2026-11-16 17:12): W rata-rata tetap dipakai sebagai cadangan; tab 3 butuh emisivitas, metode, CRS sendiri; Level 2 tidak perlu; multitemporal.

## Dibuat
- W dirata-rata di wilayah kajian (core/wv_apply.aoi_mean); granul tak menutup AOI atau tertutup awan = tak punya W hari itu. Aturan: same_mean (bawaan) atau nearest_mean dengan batas hari.
- Tab 3 punya kontrol sendiri (prefix n_), Level 1 masukan utama, Level 2 opsional; run_lst jalan tanpa scene L2; worker melewati laporan L2 bila tidak ada.
- Tes 15 di test_wv_apply.py, suite penuh 1157 lolos, 4 dilewati.

## Keputusan dan yang ditolak
- Rata-rata W tetap ada (keputusan pengguna); tidak dibuat mode skip.
- Level 2 tidak dihapus: satu-satunya cek terhadap ST_B10.

## Belum
- Menu Multitemporal masih merata-ratakan seluruh raster W (bukan AOI); belum diubah.
- Produk turunan menu multitemporal (rangkuman deret waktu) belum diperiksa kesetaraannya dengan tab 3.
- Skala W (fit) dari data yang sama; hanya data sintetis; perlu uji data nyata terhadap ST_B10 dan SST.
