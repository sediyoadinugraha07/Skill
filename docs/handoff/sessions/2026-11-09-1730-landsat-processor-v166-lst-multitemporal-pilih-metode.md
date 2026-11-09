---
date: 2026-11-09 17:30
source: claude-code
topic: landsat-processor-v166-lst-multitemporal-pilih-metode
status: berlanjut
---

## Tujuan
Pengguna: bangun LST multi-temporal dengan pilihan metode supaya aplikasi tidak bingung metode apa yang dipakai; alur dari BT (v163) dan emisivitas (v164) ke ET Level 1 (v165) dan TEI.

## Keputusan dan alasannya
- Satu metode per proses untuk seluruh deret (tren palsu bila dicampur); lima metode memakai LSTJob yang sama dengan menu lama (diuji identik untuk SCM-AC, Skokovic, JMS).
- Atmosfer (w, Ld, Lu, tau) hanya dari tabel CSV per tanggal; tanggal tanpa nilai dilewati. Alasan: menebak atmosfer diam-diam merusak sebanding antar tanggal. w tunggal untuk semua tanggal dibolehkan dengan peringatan.
- SCM: satu band terpilih (bawaan 10) ke folder LST/ karena nama luaran menu kedua band sama pada katalog (duplikat). Band 11 dihitung lewat proses terpisah bila perlu.
- Qin/Mao: seed tetap 1 dan dicatat agar bisa diulang.
- BT dihitung dari radiance bila folder BT kosong, dengan fungsi menu LST.
- Tab ditaruh di host LST (bersama BT), bukan di halaman SCM/MCM per scene yang tidak diubah.

## Yang ditolak atau belum
- Ld, Lu, w otomatis dari MODIS atau Level 2 untuk jalur ini belum ada.
- Bug `_find_emis` (LST tab 2, metode folder) masih ada: memilih `_NDVI.tif` pada folder keluaran v164. Versi tersendiri.
- Uji lama test_bt_batch disesuaikan (host kini 3 tab).

## Hasil nyata
- core/lst_batch.py, lst_batch_report.py, gui/lst_batch_page.py, host LST 3 tab, tests/test_lst_batch.py (15 uji), i18n 3721 kunci, README v166. 203 uji terkait lulus setelah penyesuaian satu uji.

## Berikutnya
Uji rantai nyata Level 1 (BT, emisivitas, LST, ET, TEI); perbaiki _find_emis; w otomatis dari MODIS; crash test_twi/test_modis_lst.
