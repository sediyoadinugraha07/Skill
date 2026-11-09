---
date: 2026-11-09 22:30
source: claude-code
topic: landsat-processor-v173-modis-multitemporal-l1b-l2
status: berlanjut
---

## Tujuan
Tombol multi-temporal pada MODIS L1B dan MODIS Level 2; hasil per folder granul sebagai dasar menu MODIS multi-temporal berikutnya.

## Keputusan dan alasannya
- Satu modul core/modis_batch.py untuk dua jenis: loop di atas process_modis/process_l2 yang tidak diubah (nilai identik, diuji).
- Granul dikenali dari nama berkas standar; zip dicocokkan juga lewat nama berkas di dalamnya.
- L1B dan L2 dikerjakan sekaligus (satu perubahan), jadi hanya satu versi (v173); tugas v174 digabung.
- Pilihan band/lapisan diambil dari granul pertama; granul lain yang tak punya band itu gagal tercatat, bukan diam-diam dilewati.
- Kotak wilayah: skip granul tak beririsan memakai kotak batas lintang/bujur (konservatif).
- process_l2 diperluas menerima daftar berkas agar tile satu tanggal tergabung dalam satu folder.

## Yang ditolak atau gagal
- Tidak mencampur beberapa produk dalam satu batch; produk terbanyak dipakai dan sisanya dilaporkan.
- Tidak memakai filter tanggal (sesuai preferensi menyederhanakan).

## Hasil nyata
- core/modis_batch.py, gui/modis_multi.py, gui/modis_page.py, gui/modis_l2_page.py, core/modis_l2.py (daftar berkas), tests/test_modis_batch.py (6 uji), i18n 4 kunci, README v173. Hanya granul sintetis.

## Berikutnya
Uji dengan granul MOD021KM nyata (waktu, memori); menu MODIS lanjutan multi-temporal (Cloud, Region, Indeks, Uap Air, Emisivitas, LST); _find_emis.
