---
date: 2026-10-24 17:00
source: claude-code
topic: landsat-processor-v119-kalibrasi-atmosfer
status: berlanjut
---

## Tujuan
Membangun pemindai folder multi-temporal (MODIS + Landsat) dan modul kalibrasi transmitansi atmosfer (tau) band 10 Landsat dari MODIS, dengan luaran Excel lengkap berisi persamaan tau.

## Keputusan dan alasannya
- Unit kalibrasi adalah scene (parameter k0, H, T_up_eff per scene), karena ST_ATRAN hampir hanya fungsi elevasi di dalam satu scene dan parameternya berbeda antar scene (tau0 0,33 basah; 0,55 sampai 0,63 kering).
- Model tau(z) = exp(-k0 exp(-z/H)), karena fit eksponensial ganda ini menjelaskan profil elevasi lebih baik daripada garis lurus pada scene basah (R2 0,996 lawan 0,995) dan memberi k0 yang bermakna fisik.
- tau, L_up, L_down dipakai sebagai satu paket konsisten (L_up dari (1-tau) B(T_up), L_down dari rasio DRAD/URAD), karena memadukan tau sendiri dengan L_up/L_down USGS memberi galat LST sekitar 2 K per 0,01 tau.
- Pasangan Landsat-MODIS dibobot cos(VZA) x exp(-selisih/36 jam) x kecukupan sel IR valid dan granule berawan dibuang, karena scene 10 Apr 2025 hanya punya 2 sel IR valid (W 6,5 cm dari awan).
- Closure dilaporkan dengan median dan sd robust (MAD), karena 0,08% piksel (emisivitas rendah, suhu tinggi) memberi selisih sampai 4 K dan merusak sd biasa.
- n < 4 tidak diinferensi, n < 8 indikatif; T_up memakai T_eff kontinum + bias (kemiringan 1) bila n < 4.
- Zip multi-granule dienumerasi semua anggotanya di jalur baru; core.modis.resolve_input (hanya anggota pertama) tidak diubah.

## Yang ditolak atau gagal
- Pembobotan T_eff linear ditolak sebagai skema utama: bias terhadap T_up_eff Landsat 2,2 sampai 2,9 K, kontinum 0,2 sampai 1,0 K (n kecil).
- Regresi k0 ~ W dari 2 scene bukan temuan: arah hubungannya berlawanan dengan fisika (Jul 2024 W 2,14 cm k0 0,46; Sep 2026 W 1,70 cm k0 0,59). Laporan memberi PERINGATAN otomatis.
- Memuat array float64 penuh (OOM di mesin 8 GB): dipakai pembacaan terdesimasi stride 3.

## Hasil nyata
- core/atmo_scan.py, core/atmo_calib.py, core/atmo_calib_report.py, gui/atmo_calib_page.py, tools/atmo_calibrate.py, tests/test_atmo_calib.py (13 uji), terjemahan en/zh (21 kunci baru), README v119.
- Excel contoh dari 3 scene (Jul 2024 L8, Apr 2025 L8, Sep 2026 L9): rumus Kalkulator dihitung ulang di LibreOffice tanpa galat dan cocok dengan Python.
- Closure median: +0,119 K (L8 2024), +0,121 K (L8 2025), +0,151 K (L9 2026).

## Belum terverifikasi
- Definisi ST_DRAD (DRAD/URAD 0,42 sampai 0,46) terhadap LSDS-1619; penyebab selisih closure +0,12 sampai +0,15 K.
- Apakah W IR atau W NIR lebih tepat; di nadir keduanya sama (2,22 dan 2,21 cm), di tepi swath IR lebih besar.
- Pembobotan pasangan adalah keputusan desain, belum dioptimalkan.
- Band termal MOD021KM (31, 32) baru terindeks, belum dipakai. Terjemahan Mandarin belum ditinjau penutur asli.

## Langkah berikutnya
1. Pengguna menambah scene Landsat L2 1 sampai 3 tahun (minimal 8 scene berpasangan) dan granule MODIS dekat nadir pada hari yang sama atau berdekatan.
2. Jalankan tools/atmo_calibrate.py pada folder lengkap, tinjau R2 dan RMSE leave-one-out, pilih prediktor W.
3. Verifikasi ST_DRAD; sambungkan paket (tau, L_up, L_down) ke menu LST; validasi dengan LST lapangan bila tersedia.
