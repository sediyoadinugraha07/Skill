---
date: 2026-10-25 18:00
source: claude-code
topic: landsat-processor-v120-tpi
status: berlanjut
---

## Tujuan
Membangun Topographic Position Index (TPI) dari DEM di Advanced Analysis untuk identifikasi bentuklahan, dengan Excel luas dan analisis pendukung.

## Keputusan dan alasannya
- Klasifikasi 6 kelas posisi lereng dan 10 kelas bentuklahan, ambang 0,5 dan 1 SD, lereng datar 5 derajat, pembakuan global, karena itu default paket R 'landform' yang merujuk Weiss (2001) dan Jenness (2006); tabel kelas dibaca dari dokumentasinya.
- Rata-rata fokal lewat konvolusi FFT per blok, karena jendela besar (2000 m pada DEM 30 m) terlalu lambat dengan konvolusi langsung; diuji terhadap perhitungan langsung.
- Sel pusat TIDAK ikut dalam rata-rata secara default dan dijadikan parameter, karena praktik Weiss/Jenness tidak terverifikasi dari sumber yang terbaca.
- Sel dengan cakupan jendela < 50% menjadi tanpa data (efek tepi pantai dan batas DEM), dengan peringatan bila > 20% sel hilang.
- Excel memuat sheet Sensitivitas_Skala karena TPI bergantung skala (De Reu dkk. 2013, hanya rujukan yang dikonfirmasi, isi belum dibaca).
- DEM geografis diproses dengan konversi derajat ke meter per baris, tetapi reproyeksi tetap disarankan.

## Yang ditolak atau gagal
- Memakai rumus pembakuan dari ingatan (mis. skala 100 dan pembulatan ala skrip ESRI) ditolak: tidak terverifikasi.
- Pembandingan FFT awal gagal pada sel tepat di ambang cakupan 50% (galat pembulatan); diperbaiki dengan toleransi 1e-9.

## Hasil nyata
- core/tpi.py, core/tpi_report.py, gui/tpi_page.py (tab TPI), tests/test_tpi.py (12 uji), terjemahan en/zh (31 kunci), README v120.
- DEM Bali 30 m (6,2 juta sel valid, 5.528 km2): 1 menit. Dataran 31,4%, lereng terbuka 37,9%, puncak dan punggungan tinggi 4,3%, ngarai 4,1%. Peta terlihat sesuai geomorfologi (kaldera Batur dan Bratan, gunung api, lembah radial).
- Tes penuh 472 (satu tes tab lama diperbarui).

## Belum terverifikasi
- Tabel kelas dan ambang belum dicocokkan dengan poster Weiss dan ekstensi Jenness asli; isi De Reu dkk. 2013 belum dibaca.
- Validasi terhadap peta geomorfologi atau lapangan belum ada. Pemilihan skala 300 m dan 2000 m adalah nilai awal, bukan rekomendasi untuk Bali.
- Horn (1981) dikutip dari pengetahuan umum.

## Langkah berikutnya
1. Pengguna menjalankan pada DEM yang sedikit lebih luas dari wilayah kajian dan mengecek Sensitivitas_Skala.
2. Bandingkan dengan peta geomorfologi atau lahan Bali untuk memilih skala.
3. Kalibrasi atmosfer: jalankan pada data asli 1 tahun (permintaan pengguna).
