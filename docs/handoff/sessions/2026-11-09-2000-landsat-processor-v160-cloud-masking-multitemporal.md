---
date: 2026-11-09 20:00
source: claude-code
topic: landsat-processor-v160-cloud-masking-multitemporal
status: berlanjut
---

## Tujuan
Cloud masking multi-temporal untuk Landsat Level 1 (satu folder, banyak scene), pola sama dengan v158 dan v159.

## Keputusan dan alasannya
- build_cloud_mask dan aturan penerapan nodata dipakai ulang; hasil identik bit-demi-bit dengan menu satu scene (diuji untuk band DN dan reflektansi float).
- CloudMaskJob/apply_mask_to_folder tidak dipakai langsung: satu QA per eksekusi dan semua .TIF folder memakai satu mask. Pemasangan lewat atmo_scan (ID scene).
- Persen awan dihitung tanpa piksel fill di penyebut; dasar ambang = persen wilayah bila ada shapefile.
- Scene terlalu berawan dilewati tetapi mask tetap disimpan dan ikut statistik/peta frekuensi.
- Peta frekuensi hanya pada grid acuan (scene pertama), tanpa reproyeksi; scene lain diberi peringatan.
- BITAND di Excel memakai awalan _xlfn. agar terbaca Excel dan LibreOffice.
- Menu dibungkus CloudHostPage; kelas lama tidak diubah. Nama berkas baru dicek terhadap zip v159.

## Yang ditolak atau gagal
- Komposit bebas awan dan gap filling tidak dibuat (di luar cakupan, dicatat).
- MODIS Cloud Masking tidak disentuh.
- Uji awal: ekspektasi persen wilayah salah hitung (uji, bukan kode); BITAND tanpa _xlfn memberi #NAME?.

## Hasil nyata
- core/cloud_batch.py, cloud_batch_report.py, gui/cloud_batch_page.py, cloud_host.py, tests/test_cloud_batch.py (12 uji), i18n 15 kunci (total 3627), README v160. 43 uji terkait lulus.

## Berikutnya
Multi-temporal untuk menu wilayah dan emisivitas; uji Level 1 nyata; regresi spasial; WUP menunggu artikel.
