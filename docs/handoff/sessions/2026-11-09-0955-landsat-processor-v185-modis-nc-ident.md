---
date: 2026-11-09 09:55
source: claude-code
topic: landsat-processor-v185-modis-nc-ident
status: berlanjut
---

## Konteks
Pengguna (09:33, 11 Nov): input MODIS L1B multi-temporal kini .nc, bukan hanya .hdf; berkas tidak dikenali atau tidak ditemukan.

## Temuan
Ekstensi .nc sudah didukung. Regex nama (L1B_RE, L2_RE, Granule, L2Product._ident) menuntut koleksi 3 digit. Nama .nc sebenarnya belum dilihat, jadi penyebab pasti belum terkonfirmasi.

## Dibuat (v185)
- core/modis_ident.py: pola longgar + cadangan dari atribut global berkas. Dipakai di modis_batch, Granule, L2Product, modis_meta.
- tests/test_modis_ident.py (11). README v185.

## Keputusan
- Berkas tanpa nama berpola dan tanpa atribut cukup tetap dilaporkan tidak dikenali (tidak ditebak).
- Produk berkisi harian tidak diberi waktu.

## Belum diverifikasi
Nama atribut NetCDF Collection 7 nyata; nama berkas .nc pengguna. Minta satu nama berkas dan daftar atribut globalnya.
