---
date: 2026-10-28 11:00
source: claude-code
topic: landsat-processor-v129-batas-shp-nol-bocor
status: berlanjut
---

## Tujuan
Tanggapi hasil SOC 0-5 cm pengguna: tambah shapefile batas pada interpolasi Forecasting bagian 4, jelaskan nilai sangat kecil atau minus, dan tangani titik bernilai 0 yang ikut terambil.

## Keputusan dan alasannya
- Nol ditangani di dua tempat: Sampel (core/zero_nodata.py, raster kontinu berisi bidang 0 tanpa NoData dianggap tanpa data) dan Forecasting (baris target 0 dibuang bila lonjakan dan bergugus menurut 3 tetangga X,Y), karena tabel lama atau raster lain tetap bisa membawa nol.
- Opsi "Nilai 0 pada data" (otomatis, selalu buang, nol sah) agar heuristik bisa ditimpa.
- Fitur bocor dibuang otomatis lewat nama sekeluarga (>= 2 token sama dengan target) atau |r| >= 0,9995; ambang awal 0,995 membuang prediktor sah di tes lama, jadi dinaikkan. Peringatan bila CV R2 > 0,9999.
- Batas shapefile: direproyeksi ke CRS peta, grid mengikuti poligon, piksel di luar sebaran titik dilaporkan sebagai ekstrapolasi. Nilai peta dipotong ke rentang titik secara bawaan (kriging dan TPS bisa overshoot).

## Yang ditolak atau gagal
- Keterhubungan nol lewat tetangga piksel pada tabel titik jarang ditolak: titik sampel jarang, hasilnya selalu rendah. Diganti kNN pada X,Y.
- Menutup interpolasi dengan cembung titik saat ada batas ditolak: pengguna ingin peta sesuai wilayah kajian.

## Hasil nyata
- Landsat_processor_v129.zip; 612 tes lolos (131 detik). Contoh: SOC_Sampel asli + Admin karang.shp: 1157 dari 9791 baris (11,8%) target 0 dibuang, 4 kolom SOC saudara dibuang sebagai bocor, CV R2 Random Forest 0,59 (sebelumnya R2 = 1,0 palsu), 926 piksel ekstrapolasi, 75.701 piksel dalam batas.
- Penyebab minus: -1,4e-6 adalah derau angka dari model sempurna (kebocoran), 3,9% piksel < 1 dari titik-titik nol.

## Belum terverifikasi
- Raster SOC asli tidak tersedia; deteksi nol di Sampel hanya diuji sintetis.
- Heuristik nol bisa keliru pada nol sah bergugus. GUI belum diuji di Windows asli.

## Langkah berikutnya
1. Pengguna mencoba Sampel pada raster SOC asli dan memeriksa catatan raster.
2. Pertimbangkan prediksi per piksel dari citra bila ekstrapolasi besar.
