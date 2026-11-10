---
date: 2026-11-09 16:50
source: claude-code
topic: landsat-processor-v180-sst-no-pyproj
status: berlanjut
---

# Landsat Processor v180

## Konteks
16:27: tab 4 kalibrasi atmosfer (validasi SST) gagal di semua 19 scene dengan "No module named 'pyproj'".

## Keputusan
- `sst_validation` memakai `atmo_lst.to_lonlat` (rasterio.warp), pola yang sama dengan perbaikan v136.
- Pemindaian seluruh `core/` menemukan tiga impor pyproj lain (geostat, sprawl, canopy_ndvi); diganti sekalian karena gejala dan penyebabnya identik.
- Uji penjaga: pemindai teks yang melarang `import pyproj` di `core/` agar tidak terulang.

## Ditolak
- Menambahkan pyproj ke requirements: mesin pengguna tidak punya, rasterio sudah cukup.

## Status
Uji SST 15 lulus, geostat/interpolasi/sprawl/canopy 51 lulus. Belum dicoba pada data SST nyata pengguna (hasil hanya terbukti tanpa kegagalan impor).
