---
date: 2026-11-09 11:30
source: claude-code
topic: landsat-processor-v179-et-l1-wind-topo
status: berlanjut
---

# Landsat Processor v179

## Konteks
Permintaan 10:19: sesuaikan ET multi-temporal (Bandara): TOA reflectance per folder citra, DEM, Level 1 untuk waktu rekam, tinggi vegetasi satu nilai, tabel kecepatan angin per citra dengan zx, lapse rate default bisa diubah, kotak koreksi topografi, RL24 Chemin atau RL turun-naik, dT/H otomatis, luaran per citra lengkap (raster dan Excel), hapus kolom tanggal.

## Keputusan
- Memodifikasi tab Level 1 yang ada, bukan modul baru; `_chain` diberi `opts` agar jalur Level 2 tetap sama.
- Tabel angin di GUI (QTableWidget) diisi oleh Cek folder; hasil dikirim sebagai dict per tanggal ke `wind_table`.
- Tinggi vegetasi satu nilai dipakai sebagai h_st (penurun angin stasiun); hv z0m dibuat opsional terpisah karena perannya fisis berbeda (ambigu dalam permintaan).
- Dengan topografi, albedo_topo dipakai G, rah, Rn24 dan iluminasi relatif diteruskan ke K24 (meniru menu satu scene).
- Struktur folder `scene/<ID>` + `ET24/` dipertahankan agar TEI multi-temporal dan hasil lama tidak rusak.
- Level 1 dari arsip: MTL diekstrak saat pemindaian, QA_PIXEL saat scene diproses lalu dihapus; sig resume mengabaikan mtime berkas cache.

## Ditolak
- Lintang dari MTL terpisah: lintang pusat citra dari georeferensi sudah setara.
- Mempertahankan pilihan cara dT di GUI: diminta otomatis.

## Status
6 uji baru dan 28 uji ET lulus (sintetis). Belum diuji scene nyata atau divalidasi lapangan.
