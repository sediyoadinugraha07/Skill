---
date: 2026-11-09 23:00
source: claude-code
topic: landsat-processor-v163-brightness-temperature-multitemporal
status: berlanjut
---

## Tujuan
BT multi-temporal untuk menu LST (tahap pertama dari dua: BT v163, emisivitas v164 menyusul), setelah analisis kedua menu.

## Keputusan dan alasannya
- radiance_to_brightness_temperature dipakai ulang; identik dengan rantai menu lama (diuji). LSTJob tidak dipakai langsung (satu MTL per eksekusi).
- Dua sumber (Level 1 mentah, hasil radiance v158). Pemasangan per ID scene.
- Hanya Landsat 8/9; scene lain dilewati dan dilaporkan. Landsat 5 TM band 6 ditunda (di luar cakupan menu LST).
- Penanda dingin memakai skala minimum 1 K karena MAD nol pada deret seragam membuat z tak bermakna; ambang heuristik, bukan uji kebenaran.
- Menu dibungkus LSTHostPage; LSTPage tidak diubah. Nama berkas baru dicek terhadap zip v162.

## Yang ditolak atau gagal
- BT tidak disebut LST; koreksi emisivitas dan atmosfer tetap di menu SCM/MCM.
- Verifikasi catatan USGS soal band 11 belum dilakukan (ditulis "perlu verifikasi").

## Hasil nyata
- core/bt_batch.py, bt_batch_report.py, gui/bt_batch_page.py, lst_host.py, tests/test_bt_batch.py (9 uji), i18n 8 kunci (total 3657), README v163. 122 uji terkait lulus.

## Berikutnya
v164 emisivitas multi-temporal: pindai folder dan cek band (band merah/NIR menurut satelit), pilih metode, skala min/max Pv (per scene bawaan, bersama, manual), mean dan delta sekaligus.
