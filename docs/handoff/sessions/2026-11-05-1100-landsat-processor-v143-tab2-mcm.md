---
date: 2026-11-05 11:00
source: claude-code
topic: landsat-processor-v143-tab2-mcm
status: berlanjut
---

## Tujuan
Tab 2: tambah metode LST multi-kanal (MCM) karena pengguna bertanya mengapa hanya SCM yang ada.

## Keputusan dan alasannya
- MCM butuh band 10 dan 11; Level 2 hanya band 10. Maka MCM memakai folder Level 1 pengguna, dipasangkan dengan scene Level 2 lewat (satelit, path/row, tanggal).
- Emisivitas MCM dari NDVI Threshold (band 10 dan 11) karena ST_EMIS tidak punya band 11; tau band 10/11 dari Rozenstein.
- Empat metode: Skokovic, Qin, Mao (Pers. 33-41), Mao asli (Pers. 24-25), memakai ulang core.lst.
- BT10 Level 1 dibandingkan dengan BT dari ST_TRAD; peringatan bila selisih lebih dari 0,5 K.

## Yang ditolak atau gagal
- Memakai ST_EMIS untuk band 10 pada MCM ditolak agar pasangan emisivitas konsisten.

## Hasil nyata
- Berkas: core/atmo_lst_methods.py, core/atmo_lst.py, core/atmo_lst_report.py, gui/atmo_calib_page.py, tests, README v143, landsat_processor_v143.zip.
- Uji: 43 lolos, 4 dilewati. Laporan Excel Sampel_MCM dan Cek_Rumus lolos di LibreOffice.

## Belum terverifikasi
- Hanya data sintetis; belum data Bali.
- Stray light band 11 dan akurasi MCM terhadap referensi perlu verifikasi.
- Tes uvspec v142 dan jalur WSL di Windows menunggu hasil pengguna.

## Langkah berikutnya
- Pengguna menjalankan Tes uvspec v142, tab 3, lalu tab 2 dengan MCM pada data Bali.
- Fitur uji laut SST menunggu paket data pengguna.
