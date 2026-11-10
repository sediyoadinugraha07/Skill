---
date: 2026-11-09 19:25
source: claude-code
topic: landsat-processor-v183-et-modis-multitemporal
status: berlanjut
---

## Konteks
Pengguna (19:00): lanjutkan ke multi-temporal. Sampel MOD021KM belum diterima.

## Dibuat (v183)
- core/et_modis_batch.py (scan_et_modis_inputs, run_et_modis_batch), tab multi-temporal di host ETModisHostPage, tabel angin per tanggal (reuse metode ETL1BatchPage).
- et_modis.run_et_modis_bandara: parameter refl_files, final_in_folder.
- tests/test_et_modis_batch.py (7), i18n ex183, README v183.

## Keputusan
- Pasangan granul lewat kunci (platform, tanggal, waktu) dari modis_post_batch._key. Tanpa metadata = dilewati. LST ambigu = dilewati kecuali filter nama.
- Angin menurut tanggal UTC dari ID granul.

## Ditolak
- Menebak metadata; memilih LST otomatis bila ambigu.

## Belum diverifikasi
Penamaan keluaran nyata menu MODIS LST/Emisivitas (diasumsikan _LST_ dan mean_emissivity); konsistensi Terra vs Aqua; atribut HDF nyata.

## Berikutnya
Waters + MOD16 (desain dulu), atau perbaikan setelah sampel MOD021KM diterima.
