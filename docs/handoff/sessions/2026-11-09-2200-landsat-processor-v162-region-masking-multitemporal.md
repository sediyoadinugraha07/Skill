---
date: 2026-11-09 22:00
source: claude-code
topic: landsat-processor-v162-region-masking-multitemporal
status: berlanjut
---

## Tujuan
Region masking multi-temporal dengan shapefile batas administrasi sebagai masukan, pola sama dengan v158 sampai v161.

## Keputusan dan alasannya
- apply_region_mask_to_band dipakai ulang; hasil identik dengan menu satu scene (diuji). Nama luaran _clipped.
- Shapefile multi-fitur: pemilihan unit lewat field dan nilai atribut, fitur terpilih di-union. Alasan: batas administrasi nyata biasanya berisi banyak unit.
- CRS manual (EPSG) bila .prj hilang; tanpa itu ditolak, tidak ditebak.
- Persen piksel valid di wilayah dilaporkan (setara bebas awan setelah cloud masking); ambang minimum diputuskan dari band pertama scene.
- Scene tidak beririsan dilewati; grid berbeda antar tanggal diberi peringatan, tidak disamakan (reproyeksi di menu Sistem Koordinat).
- region_mask.tif + .geoms.json ditulis agar kompatibel dengan menu lama. Menu dibungkus RegionHostPage, kelas lama tidak diubah. Nama berkas baru dicek terhadap zip v161.

## Yang ditolak atau gagal
- Keluaran per unit administrasi terpisah belum dibuat (union saja); all_touched tidak dipakai (sama dengan menu lama).
- Modul Cloud/Atmosferik yang memakai shapefile wilayah (region_shp) tidak membaca CRS manual; bila .prj hilang akan gagal dengan pesan CRS. Perlu ditindaklanjuti bila pengguna butuh.

## Hasil nyata
- core/region_batch.py, region_batch_report.py, gui/region_batch_page.py, region_host.py, tests/test_region_batch.py (10 uji), i18n 18 kunci (total 3649), README v162. 65 uji terkait lulus.

## Berikutnya
Multi-temporal emisivitas (keputusan: per scene dari NDVI atau satu peta tetap); regresi spasial; WUP menunggu artikel; uji pada data nyata.
