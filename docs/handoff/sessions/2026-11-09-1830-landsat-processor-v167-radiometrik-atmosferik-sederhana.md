---
date: 2026-11-09 18:30
source: claude-code
topic: landsat-processor-v167-radiometrik-atmosferik-sederhana
status: berlanjut
---

## Tujuan
Pengguna mencoba Koreksi Radiometrik multi-temporal dan minta: masukan satu kolom (folder data mentah USGS .tar tanpa ekstraksi), band optik/termal/pankromatik dikenali otomatis, hasil per kode citra; Koreksi Atmosferik lanjutan langsung dari folder hasil reflektansi + MTL; kotak SHV dan "hitung ulang" tidak dimengerti.

## Keputusan dan alasannya
- .tar sudah didukung sejak v158 (diuji dengan tar sintetis); yang diubah adalah UI: satu kolom masukan, sisanya di kelompok lanjutan tertutup.
- Pengelompokan band lewat MTL (band_kind) dan Cek folder tanpa ekstraksi; GUI memilih kelompok, API groups=None tetap setara menu satu scene.
- `_cache` kini dihapus per scene (sebelumnya band hasil ekstraksi menumpuk, bisa menggandakan ruang disk).
- Bawaan noclip dinyalakan di halaman batch karena DOS butuh reflektansi tidak terpotong; DOS memperingatkan bila masukan terpotong (SHV menjadi 0 diam-diam).
- Reflectance dan radiance tetap satu folder per scene (akhiran berbeda); memisah ke subfolder mode tidak dilakukan karena mengubah jalur bagi menu hilir; ditawarkan ke pengguna.
- Kotak SHV bersih-awan adalah tambahan tanpa padanan di menu satu scene; dijelaskan, tetap opsional dan mati bawaannya.

## Yang belum
- Belum diuji dengan tar USGS asli penuh. Subfolder per mode belum dibuat. Bug `_find_emis` (LST tab 2) dan crash test_twi/test_modis_lst masih terbuka.

## Hasil nyata
- core/radiometric_batch.py (band_kind, plan_radiometric_batch, groups, keep_cache), core/atmospheric_batch.py (peringatan terpotong, bersih cache), gui/radiometric_batch_page.py, gui/atmospheric_batch_page.py, gui/host_util.collapsible, tests/test_radiometric_ui_v167.py (8 uji), i18n, README v167. 134 uji terkait lulus.
