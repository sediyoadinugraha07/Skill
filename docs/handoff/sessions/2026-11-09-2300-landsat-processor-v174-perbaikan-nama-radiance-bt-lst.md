---
date: 2026-11-09 23:00
source: claude-code
topic: landsat-processor-v174-perbaikan-nama-radiance-bt-lst
status: berlanjut
---

## Tujuan
Memperbaiki galat v173 pada BT multi-temporal: "Tidak ada scene yang dapat diproses" untuk folder hasil koordinat.

## Keputusan dan alasannya
- Akar masalah: pemindai hanya *_radiance.tif; setelah Cloud/Region/Koordinat sufiks _masked_clipped ikut. Cacat sama di lst_batch (dipakai RAD_RE bersama).
- Keluarga nama campur: pilih terbanyak + peringatan (bukan campur diam-diam).
- Pesan galat diperkaya (pola, jumlah tif, contoh nama) karena pesan lama tak bisa didiagnosis.

## Yang ditolak atau gagal
- Uji lama hanya memakai nama polos sehingga cacat lolos; ditambah uji nama berakhiran tahap. Penyebab pasti di data pengguna belum dikonfirmasi (traceback tanpa daftar dilewati konsisten dengan tidak ada kandidat).

## Hasil nyata
- core/bt_batch.py, core/lst_batch.py, tests/test_bt_batch.py, tests/test_lst_batch.py, i18n 1 kunci, README v174. 26 uji lulus.

## Berikutnya
Konfirmasi pengguna dengan data nyata; periksa konsumen multi-temporal lain yang menyaring nama ketat.
