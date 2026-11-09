---
date: 2026-11-09 19:00
source: claude-code
topic: landsat-processor-v168-cloud-region-disederhanakan
status: berlanjut
---

## Tujuan
Menyederhanakan Cloud Masking dan Region Masking multi-temporal: dua folder masukan, tanpa shapefile di Cloud, mask terpisah dari citra, hasil per scene.

## Keputusan dan alasannya
- Core sudah mendukung sebagian besar (source outputs + l1_dir, QA dari .tar via atmo_scan). Perubahan inti hanya tata letak: mask ke masks/<sid>/, peta frekuensi ke masks/. Alasan: frekuensi_masking.tif di akar hasil terbaca sebagai citra tanpa ID oleh Region.
- Region melewati folder masks dan _cache (SKIP_DIRS), bukan mengandalkan nama berkas.
- Sumber (level1/outputs) diturunkan dari kolom yang terisi, bukan combo: hasil+Level1 = outputs; hanya Level1 = DN mentah.
- Citra referensi Region hanya menentukan grid region_mask.tif; pemotongan band tetap per grid band (tidak mengubah hasil identik menu lama).
- Shapefile dihapus dari GUI Cloud, parameter region_shp dipertahankan di core.

## Yang ditolak atau gagal
- Bug awal: profil referensi tanpa 'driver' membuat build_region_mask gagal; diperbaiki dengan dict(sr.profile).
- Tidak memigrasi hasil lama (mask di folder scene).

## Hasil nyata
- core/cloud_batch.py, core/region_batch.py, gui/cloud_batch_page.py, region_batch_page.py, cloud_host.py, tests/test_cloud_region_v168.py (3 uji), i18n 17 kunci (total 3759), README v168. 63 uji terkait lulus. Zip landsat_processor_v168.zip.

## Berikutnya
Uji pada Level 1 nyata dan .tar penuh; _find_emis di core/atmo_lst.py; crash test_twi dan test_modis_lst.
