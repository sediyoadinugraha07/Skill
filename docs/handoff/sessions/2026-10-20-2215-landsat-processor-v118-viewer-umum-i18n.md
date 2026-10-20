---
date: 2026-10-20 22:15
source: claude-code
topic: landsat-processor-v118-viewer-umum-i18n
status: berlanjut
---

## Tujuan
Viewer untuk semua hasil pengolahan (nilai piksel di pointer), statistik citra, grafik korelasi dua raster dan profil garis, centang resolusi raster acuan pada Interpolasi, serta pilihan bahasa Indonesia, English, 中文.

## Keputusan dan alasannya
- Viewer memakai Layer dengan nilai ASLI piksel (bukan hasil resampling layar) karena yang ditanya pengguna adalah nilai piksel sebenarnya.
- Statistik exact (Welford) untuk min, maks, rerata, SD; median dan persentil taksiran histogram, diberi label, karena raster besar tidak muat di memori.
- Korelasi: Y diresample bilinear ke grid X lewat WarpedVRT dengan nodata NaN; di luar jejak citra dianggap nodata.
- i18n lewat katalog JSON kunci teks Indonesia dan monkeypatch penyetel teks Qt, supaya ganti bahasa langsung tanpa menulis ulang puluhan halaman GUI.
- Cakupan terjemahan hanya antarmuka (2.791 kunci), agar jujur soal batas.

## Yang ditolak atau gagal
- Pustaka i18n bawaan Qt (.ts/.qm) ditolak karena butuh ekstraksi dan kompilasi tersendiri di seluruh 68 berkas.
- Laporan Excel, tag GeoTIFF, dan galat core tidak diterjemahkan (di luar cakupan).
- Tes test_modis_region gagal di pytest (FileExistsError) karena setup dijalankan dua kali; diperbaiki dengan satu jalur lewat _first().

## Hasil nyata
- Berkas: gui/viewer.py, gui/viewer_tools.py, core/raster_stats.py, core/i18n.py, gui/i18n_qt.py, i18n/en.json, i18n/zh.json, tests/test_i18n.py, tools/*i18n*.py, README bagian v118.
- Audit tampilan zh: 0 teks Indonesia dari 842 teks unik. Suite penuh: 444 lolos + 3 gagal setup (kini diperbaiki, file itu 5 lolos).

## Belum terverifikasi
- Terjemahan Mandarin belum ditinjau penutur asli.
- Tampilan visual semua halaman 中文 di Windows belum dilihat mata manusia.
- Ekstraksi mungkin masih melewatkan sebagian teks dinamis.
- Verifikasi lama tertunda: Baig 2014, Lobser-Cohen 2007, Wan-Dozier, MOD11A2 Qin, rumus Joseph.

## Langkah berikutnya
1. Pengguna menguji di Windows dan menandai teks yang masih Indonesia atau terjemahan janggal.
2. Tinjauan penutur asli untuk zh.json.
3. Forecasting kontinu (Tahap 1) jadi bahan diskusi.
