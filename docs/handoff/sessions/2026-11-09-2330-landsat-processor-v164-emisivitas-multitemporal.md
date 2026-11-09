---
date: 2026-11-09 23:30
source: claude-code
topic: landsat-processor-v164-emisivitas-multitemporal
status: berlanjut
---

## Tujuan
Emisivitas multi-temporal bertahap (cek folder dan band, pilih metode, Mean dan Delta sekaligus), tahap kedua setelah BT v163.

## Keputusan dan alasannya
- EmissivityJob dan compute_index_to_file dipakai ulang; identik dengan menu lama (diuji). Vegetation Index tidak punya batch sehingga NDVI dihitung per scene di dalam batch.
- Satu deret = satu keluarga band dan satu sumber NDVI; scene lain dilewati, tidak dicampur (prinsip uniform v152).
- Skala Pv: per scene bawaan (setara menu lama) dengan peringatan jika ekstrem berbeda > 0,10; bersama dan manual tersedia. Alasan: ekstrem satu piksel menggeser Pv antar tanggal.
- NDVI Threshold hanya Landsat 8/9; Valor-Caselles untuk sensor lain; Mean/Delta tidak dibuat untuk Valor-Caselles.
- Tombol "Cek folder" meniru pratinjau cloud v161 (tidak menulis).

## Yang ditolak atau gagal
- DOS dari fixture noisy tidak menghasilkan keluarga _dos1 (SHV tak ditemukan); uji memakai salinan berkurang 0,08.
- REGRESI DITEMUKAN (v158 sampai v163): _scrollable tidak membungkus halaman yang memuat QScrollArea, jadi tab "Satu scene" di host Radiometrik, Cloud, Region, LST, Emissivity kehilangan gulir. Diperbaiki di v164 lewat gui/host_util.scroll_wrap; pengguna perlu diberi tahu bahwa zip v158-v163 punya cacat ini.

## Hasil nyata
- core/emissivity_batch.py, emissivity_batch_report.py, gui/emissivity_batch_page.py, emissivity_host.py, host_util.py, tests/test_emissivity_batch.py (12 uji), i18n 23 kunci (total 3680), README v164. 114 uji terkait lulus (test_emissivity disesuaikan).

## Berikutnya
Uji semua tab multi-temporal pada data Level 1 nyata; regresi spasial; WUP menunggu artikel; investigasi crash test_twi/test_modis_lst.
