---
date: 2026-11-09 17:07
source: claude-code
topic: landsat-processor-v193-tei-l1-multitemporal
status: berlanjut
---

# Landsat Processor v193: perbaikan TEI multi-temporal

## Masalah
Pengguna: TEI multi-temporal gagal dengan "Tidak ada pasangan LST dan ET yang kunci scene-nya sama" (LST multi-temporal hasil Level 1, ET metode Bandara).

## Diagnosis
KEY_RE di core/tei.py butuh 4 huruf tingkat produk; pipeline_l1 menamai LST LC08_116066_YYYYMMDD_<metode>_LST_K.tif. Mode folder biasa (compute_tei_auto) juga tidak memakai katalog LST. Nama berkas asli pengguna belum dilihat; ini kesimpulan dari kode.

## Perubahan
- KEY_RE menerima dengan/tanpa tingkat produk.
- compute_tei_auto untuk folder mendelegasikan ke compute_tei_multitemporal bila katalog mengenali LST; fallback generik dengan galat diagnostik.
- index_et: saring ET24/ETact24, buang ET24_pot, rekursif.
- Label GUI diperbarui (+1 kunci i18n). 1089 uji lulus.

## Ditolak
- Menebak kunci dari nama tanpa pola: berisiko memasangkan scene salah.

## Belum beres
- Perlu konfirmasi dengan nama berkas aktual pengguna.
