---
date: 2026-11-09 21:05
source: claude-code
topic: landsat-processor-v177-lst-multi-folder
status: berlanjut
---

# Landsat Processor v177: LST multi-temporal dari folder hasil

## Konteks
Permintaan 20:35: tab LST multi-temporal ringkas, pilih metode, folder masukan menurut metode (Level 2 untuk Ld/Lu, BT, emisivitas, uap air MODIS, radiance, Level 1), luaran per folder citra.

## Keputusan
- Modul baru `core/lst_multi.py` + `gui/lst_multi_page.py`; tab baru di `LSTHostPage`. Tab CSV lama (`lst_batch`) dibiarkan agar nama dan perilaku lama tidak berubah.
- Memanggil fungsi `LSTJob` yang sama dengan menu satu scene; luaran identik (diuji).
- w = rata-rata `_WV_W.tif` MODIS pada tanggal akuisisi Landsat yang sama; Ld/Lu = rata-rata ST_DRAD/ST_URAD (konversi atau mentah x 0,001).
- JMS ditambah folder radiance dan uap air MODIS karena rumusnya memerlukan radiance dan tau (dari w); ini tidak disebut pengguna.
- Mao = masukan Qin; hanya rumus (asli/Nugraha) dan nama luaran berbeda.

## Ditolak
- Menggabungkan ke `lst_batch.py`: tabel CSV dan folder berbeda filosofi, risiko merusak uji lama.
- Toleransi hari untuk W: ditunda, tanggal sama saja agar tidak menebak atmosfer.

## Status
8 uji sintetis baru lulus (test_lst_multi), uji lst_batch/bt_batch disesuaikan jumlah tab. Belum diuji data nyata. Observation log task-observer tidak ada (tidak ada yang dicatat).
