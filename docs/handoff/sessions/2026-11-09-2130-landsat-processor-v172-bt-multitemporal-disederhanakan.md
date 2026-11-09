---
date: 2026-11-09 21:30
source: claude-code
topic: landsat-processor-v172-bt-multitemporal-disederhanakan
status: berlanjut
---

## Tujuan
BT multi-temporal: masukan folder radiance + folder Level 1; hapus pilihan band, tanggal, hitung ulang.

## Keputusan dan alasannya
- GUI memaksa source=radiance dan bands=(10,11); core utuh. Folder Level 1 diwajibkan di GUI (permintaan pengguna; MTL tidak ada di folder radiance).
- Resume tetap lewat BT_SIG; overwrite hanya di core.

## Yang ditolak atau gagal
- Tidak menghapus mode level1 di core.

## Hasil nyata
- gui/bt_batch_page.py, tests/test_bt_batch.py (GUI), i18n 6 kunci, README v172. 9 uji lulus.

## Berikutnya
v173 MODIS L1B multi-temporal, v174 MODIS Level 2 multi-temporal.
