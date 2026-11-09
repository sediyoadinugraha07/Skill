---
date: 2026-11-09 20:30
source: claude-code
topic: landsat-processor-v170-emisivitas-disederhanakan
status: berlanjut
---

## Tujuan
Emisivitas multi-temporal: masukan folder NDVI multi-temporal, NDVImin/max otomatis atau manual di masukan, hapus cek hitung ulang.

## Keputusan dan alasannya
- GUI memaksa ndvi_source="file"; core tetap mendukung jalur band (uji lama utuh).
- Tiga mode skala di masukan: per scene (bawaan, setara menu lama), bersama, manual. "Bersama" dipertahankan walau pengguna menyebut otomatis atau manual saja, karena per scene membuat Pv antar tanggal tidak sebanding.
- "Kolom Pv" ditafsirkan sebagai pilihan skala Pv di kelompok metode; dipindah ke masukan.
- Kotak hitung ulang dihapus dari GUI; resume tetap lewat tanda tangan EMIS_SIG.

## Yang ditolak atau gagal
- Tidak menghapus parameter overwrite di core (dipakai uji dan pemanggil lain).

## Hasil nyata
- gui/emissivity_batch_page.py, tests/test_emissivity_batch.py disesuaikan, rantai veg->emisivitas diuji, i18n (total lihat keys.json), README v170.

## Berikutnya
Uji dengan data nyata berurutan Cloud -> Region -> Veg -> Emisivitas; _find_emis; crash test_twi dan test_modis_lst.
