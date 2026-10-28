---
date: 2026-10-28 11:30
source: claude-code
topic: landsat-processor-v130-nol-nodata-terdeklarasi
status: berlanjut
---

## Tujuan
Cek deteksi nol v129 pada raster SOC asli yang dikirim pengguna (SOC_stock_0-5.zip, empat lapisan).

## Keputusan dan alasannya
- Detektor nol di Sampel kini berjalan juga pada raster yang punya NoData terdeklarasi (selain 0), karena raster SOC asli mendeklarasikan -3,4e38 untuk luar wilayah tetapi memakai 0 untuk area tanpa data. v129 melewatinya (bug nyata, ditemukan hanya setelah raster asli tersedia).

## Yang ditolak atau gagal
- Asumsi v129 bahwa NoData terdeklarasi berarti 0 aman: salah. 916 dari 10.000 titik masih 0.

## Hasil nyata
- Raster asli 171x143 sel, 13.407 sel valid, 1.189 nol (8,9%), 84 gugus (terbesar 414 sel), tanpa nilai antara 0 dan 12,3. Setelah perbaikan: 0 titik nol, rangka 12.218 sel. 613 tes lolos. landsat_processor_v130.zip.

## Belum terverifikasi
- Alur penuh Sampel asli lalu Forecasting lalu peta belum dijalankan ulang pada v130 (tiap bagian diuji terpisah).
- Apakah 0 di tepi wilayah (201 dari 1.189 nol bersebelahan dengan NoData) benar tanpa data atau SOC rendah sungguhan: nilai valid terkecil 12,3 membuat nol sebagai SOC sungguhan tidak masuk akal, tetapi ini inferensi.

## Langkah berikutnya
1. Pengguna menjalankan Sampel lalu Forecasting v130 dengan raster asli dan batas Karangasem.
