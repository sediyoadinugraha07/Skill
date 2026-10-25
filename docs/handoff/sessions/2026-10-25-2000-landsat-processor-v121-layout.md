---
date: 2026-10-25 20:00
source: claude-code
topic: landsat-processor-v121-layout-peta-jurnal
status: berlanjut
---

## Tujuan
Menu Layout mandiri untuk menyusun peta hasil (1 atau banyak raster) menjadi gambar artikel jurnal bereputasi.

## Keputusan dan alasannya
- Gambar dibuat pada ukuran fisik mm dengan matplotlib Figure tanpa pyplot, karena ukuran huruf pt harus sama dengan ukuran cetak dan agar tanpa Qt bisa diuji.
- Graticule lewat rasterio.warp, bukan cartopy atau pyproj, karena cartopy tidak terpasang dan rasterio sudah dipakai.
- Preset hanya untuk angka yang terbaca dari panduan (Elsevier lebar 90/140/190 mm; dpi T&F dan MDPI); lebar kolom T&F dan MDPI tidak dibuat preset pasti karena tidak ditemukan.
- Label perairan ditandai pengguna dengan klik di pratinjau dan disimpan sebagai lon/lat, karena tidak ada basis data nama laut.
- Keluaran TPI kini menulis tag CLASS_NAMES, CLASS_NAMES_EN, LAYER_LABEL, UNITS agar legenda otomatis.
- Legenda kelas dikelompokkan per panel bila set kelas berbeda (percobaan pertama mencampur dua peta, ditolak karena menyesatkan).

## Perbaikan lanjutan v121 (permintaan pengguna 19:29)
- Legenda otomatis melabeli ujung min dan maks (batas dibulatkan ke angka rapi, bisa dimatikan); manual: selang, daftar, rentang, genap/ganjil.
- Skala batang ditulis ulang dalam mm; diuji terhadap panjang cetak (toleransi 3%) untuk CRS geografis dan UTM; panjang tak wajar diganti otomatis dengan peringatan. Penyebab batang hilang: isian meter.
- 9 model panah utara; ukuran font dan jarak huruf label perairan; penempatan nama khusus (hanya nama terpilih, posisi klik, nama bebas).
- UTM negatif: raster Landsat L2 Bali berada di EPSG:32650 (zona utara), northing asli -843.885 sampai -1.075.515 m; bukan salah tafsir. Label +10.000.000 m secara bawaan, data tidak diubah.
- Ditolak: kotak putih di belakang panah utara (menutup data); diganti halo pada huruf N.

## Yang ditolak atau gagal
- Shapefile Bali_desa punya koordinat Z: LineCollection gagal, diperbaiki dengan memotong ke XY.
- Ukuran piksel Agg dibulatkan ke bawah: size_px kini dibaca dari canvas.

## Hasil nyata
- core/layout_geo.py, core/layout.py, gui/layout_page.py, tests/test_layout.py (19 uji), 491 uji lulus, i18n en/zh 2962 kunci, audit zh 0 sisa.
- landsat_processor_v121.zip, contoh out/layout_bali_contoh.png (190 mm, 300 dpi).

## Belum terverifikasi
- Lebar kolom T&F dan MDPI; apakah jurnal target menerima RGB tanpa profil ICC.
- Peringatan dari pemeriksaan dan judul kolom tabel belum diterjemahkan.
- Panah utara tidak ikut berputar untuk raster yang diputar; inset dan klik label belum diuji di GUI nyata Windows.
- Font Arial tidak ada di lingkungan uji (dipakai Liberation Sans).

## Langkah berikutnya
1. Pengguna menguji menu Layout pada hasil nyata (LST temporal) dan memberi masukan tata letak.
2. Kalibrasi atmosfer data 1 tahun; ST_DRAD; sambungkan tau ke menu LST.
