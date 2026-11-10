---
date: 2026-11-09 18:01
source: claude-code
topic: landsat-processor-v181-metadata-modis
status: berlanjut
---

## Konteks
Pengguna meminta eksekusi bertahap ET MODIS (pesan 17:57). ET Landsat dan ET MODIS dipisah. Metadata MODIS ada di data mentah HDF, jadi aplikasi membangkitkan metadata sendiri sebagai tahap 1.

## Yang dibuat (v181)
- core/modis_meta.py: read_granule_meta, mtl_text, run_meta_batch, run_meta_single. Berkas `<ID>_MTL_MODIS.txt` berkunci MTL Landsat plus PROVENANCE_* dan WARNING_*; Excel ringkasan.
- gui/modis_meta_page.py + MODISMetaHostPage, menu MODIS > "Metadata MODIS".
- tests/test_modis_meta.py (8 uji), i18n ex181 (total 3879 kunci), README v181.

## Keputusan dan alasan
- Cadangan berurutan dan tercatat per nilai, tidak ada tebakan diam-diam. Rentang waktu > 30 menit ditolak (produk berkisi harian tidak punya satu waktu rekam).
- Format keluaran dibuat kompatibel MTL agar scene_info_from_mtl, read_mtl, compute_rn24 tidak perlu diubah.
- Tanpa koreksi topografi untuk MODIS (cakupan luas), sesuai pengguna.

## Ditolak
- Menebak waktu dari tengah hari atau dari pusat raster tanpa pencatatan.
- Memodifikasi kode ET Landsat untuk MODIS.

## Belum diverifikasi
Nama atribut CoreMetadata pada berkas nyata (koleksi 061?), satuan Earth-Sun Distance, MOD03 terpisah. Perlu satu granul nyata (MOD021KM/MYD021KM, plus MOD03 bila ada).

## Berikutnya
v182 ET MODIS Bandara satu granul (membaca hanya metadata ini), v183 multi-temporal, lalu Waters.
