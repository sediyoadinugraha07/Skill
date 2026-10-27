---
date: 2026-10-27 14:00
source: claude-code
topic: landsat-processor-v127-forecasting-sederhana
status: berlanjut
---

## Tujuan
Menu Forecasting dibuat praktis: pengguna memilih target dan model, sisanya otomatis. Grafik Excel harus dapat disunting.

## Keputusan dan alasannya
- core.forecast.auto_setup menentukan X/Y, CRS (dibaca dari lembar Ringkasan sampel), ID, waktu, grup, lag, cara membagi, tuning (<=5000 baris), tugas.
- Dihapus dari UI: kolom peran, fitur manual, blok, folds, seed, tuning, kandidat, importance, data baru, konfusi, jenis keluaran. Mesin tetap menerima parameternya.
- Blok spasial otomatis diperkecil bila titik mengumpul; persen uji hanya muncul bila "Atur sendiri".
- Lembar default dipilih otomatis (Sampel): bug nyata, lembar Ringkasan sampel dulu terbuka.
- Grafik_Excel berisi objek grafik asli (sebar, galat, histogram COUNTIFS, deret waktu, F1 kelas); PNG dipindah ke Grafik_Gambar.
- Versi 127 (126 dipakai Sampel).

## Yang ditolak atau gagal
- Panel lanjutan tersembunyi ditolak: permintaan pengguna eksplisit.
- Grafik hanya PNG ditolak: pengguna butuh sunting.
- Marker scatter tanpa isi tidak tampil di LibreOffice; diberi warna isi eksplisit.

## Hasil nyata
- 593 tes lulus. Uji nyata 600 titik Bali (ST) dengan GUI offscreen, Excel dan GeoTIFF terbentuk, grafik dirender lewat LibreOffice.

## Belum terverifikasi
- GUI di Windows, tampilan grafik di Excel asli (diuji di LibreOffice). Pengguna akan meninjau Sampel dan Forecasting bersamaan.
