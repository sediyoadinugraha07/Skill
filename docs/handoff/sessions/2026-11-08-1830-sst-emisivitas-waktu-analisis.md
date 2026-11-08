---
date: 2026-11-08 18:30
source: claude-code
topic: sst-emisivitas-waktu-analisis
status: berlanjut
---

## Tujuan
Menilai delapan granule GHRSST MODIS Terra SSTskin tambahan, membandingkan emisivitas 0,99 dengan ST_EMIS, dan menjawab apakah toleransi waktu bisa dalam hari. Tidak ada perubahan aplikasi (tanpa nomor versi baru).

## Keputusan dan alasannya
- Tab SST belum dibangun; menunggu pengguna menyetujui rancangan (v150) dan mengunggah Landsat tanggal yang cocok.
- Emisivitas: ST_EMIS di laut sama dengan 0,988 (p5 sampai p95 0,988 sampai 0,9904). Mengganti ke 0,99 hanya menggeser bias sekitar -0,08 K; sensitivitas sekitar 0,4 K per 0,01. Klaim sebelumnya (0,7 sampai 0,8 K per 0,01) keliru dan sudah dikoreksi ke pengguna. Emisivitas tidak menjelaskan bias -1,1 sampai -1,5 K.
- Tidak boleh memilih emisivitas dengan meminimalkan bias terhadap SST (itu menyetel ke target uji); ε di bawah 0,985 tidak realistis untuk air laut (dugaan, perlu verifikasi).
- Toleransi waktu: pakai hari kalender yang sama dengan selisih menit dicatat dan batas bawaan sekitar 3 jam; jangan perluas ke plus minus satu hari untuk uji bias absolut karena perubahan SST harian bercampur dengan galat algoritma (penalaran, belum diukur).

## Hasil nyata
- Dari delapan granule, lima punya lintasan Landsat 8/9 path 116 row 66 pada tanggal yang sama: L9 1 Mar, 4 Mei, 21 Jun, 25 Sep 2025; L8 4 Nov 2025. Selisih waktu SST terhadap Landsat di footprint: -16, -37, -9, -57, -56 menit. 19 Des 2019 dan 30 Des 2001 jatuh pada slot Landsat 7 atau 5 (tanpa TIRS 8/9), 19 Mei 2025 adalah lintasan malam (14:04 UTC).
- Jumlah piksel SST kualitas 4 ke atas di footprint: 10683, 29979, 1429, 34154, 2690 (dua tanggal tipis).
- Landsat citra untuk tanggal-tanggal itu TIDAK ada pada unggahan; hanya tiga scene lama (12 Jul 2024, 10 Apr 2025, 12 Sep 2026) yang punya citra. Jadi delapan granule baru belum bisa diuji.
- Hasil ulang tiga pasangan lama (bias RTM REPTRAN, K): ST_EMIS -1,43 / -0,91 / -1,41; e=0,99 -1,50 / -0,96 / -1,48; e=0,98 -1,12 / -0,74 / -1,11.

## Belum terverifikasi
- Penyebab bias -1,1 sampai -1,5 K (tau, kelembapan ERA5, SST kulit, kalibrasi TIRS) belum diisolasi.
- Cakupan awan scene Landsat pada tanggal-tanggal itu belum dicek.

## Langkah berikutnya
- Pengguna mengunduh Landsat L2 (ST_B10, ST_TRAD, ST_URAD, ST_DRAD, ST_ATRAN, ST_EMIS, QA_PIXEL, MTL) untuk lima tanggal di atas; lalu bangun tab SST v150.
