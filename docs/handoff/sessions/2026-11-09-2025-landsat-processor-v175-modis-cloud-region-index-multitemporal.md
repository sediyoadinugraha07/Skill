---
date: 2026-11-09 20:25
source: claude-code
topic: landsat-processor-v175-modis-cloud-region-index-multitemporal
status: berlanjut
---

## Ringkasan
v175: tab "Multi-temporal (semua granul)" untuk MODIS Cloud Masking, Region Masking, dan Indeks (tiga menu menjadi host bertab bersama menu lama).

## Keputusan
- Satu modul `core/modis_post_batch.py` untuk ketiganya; memakai ulang `build_mask_raster`/`apply_mask`, `clip_band`, `compute_modis_index`. `apply_mask` diberi parameter `files=` agar bisa menerima daftar berkas granul tanpa menyaring ulang menurut penanda.
- Granul dikenali dari nama berkas keluaran (`produk_A<yyyy><ddd>_<HHMM>`), pasangan MOD35 menurut platform+tanggal+waktu. CRS dan kotak mask diambil dari band granul (tanpa isian CRS) supaya mask jatuh pada grid band.
- Mask di `<hasil>/masks/<ID>/`; Region/Indeks melewati `masks`, `_cache`, dan raster ber-kata MASK.
- Granul tanpa MOD35 dilewati dan dilaporkan, bukan diteruskan tanpa mask.
- Indeks: band dari `_B0n_ref`, satu keluarga akhiran per granul; nama luaran `<ID>_<INDEKS>.tif`.
- Tiga permintaan dirilis sebagai satu versi (bukan v175 sampai v177) karena inti dan GUI berbagi modul.

## Ditolak
- Isian CRS/piksel pada tab cloud (mask akan mudah tidak sejajar dengan band).
- Meneruskan granul tanpa pasangan MOD35.

## Batas dan belum diverifikasi
- Hanya data sintetis; belum diuji pada MOD35/L1B nyata dan ratusan granul (waktu, memori).
- Pemasangan produk berkisi tanpa waktu hanya bila tepat satu MOD35 pada tanggal itu.
- Masih terbuka: konfirmasi pengguna atas v174 (BT), `_find_emis` di core/atmo_lst.py, crash native di test_twi/test_modis_lst.
