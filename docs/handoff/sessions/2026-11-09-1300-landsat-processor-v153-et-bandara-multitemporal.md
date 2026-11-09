---
date: 2026-11-09 13:00
source: claude-code
topic: landsat-processor-v153-et-bandara-multitemporal
status: berlanjut
---

## Tujuan
ET24 Bandara otomatis untuk banyak tanggal dari folder Level 2, dengan tabel angin per tanggal dan satu tinggi vegetasi, lalu TEI multi-temporal.

## Keputusan dan alasannya
- Orkestrator memanggil fungsi menu ET yang sudah ada (tanpa rumus baru) supaya hasil identik dengan jalur manual.
- Cara dT bawaan "dua titik": mode regresi tak terkalibrasi memberi H sekitar 4 kali Rn minus G dan ET24 = 0 pada uji sintetis (aplikasi sendiri memperingatkannya).
- Albedo dari SR Level 2 dihitung langsung (bobot ESUN, tanpa koreksi atmosfer kedua), karena modul albedo lama mengasumsikan reflektansi TOA.
- Tanggal tanpa angin dilewati secara bawaan; angin turunan citra hanya sebagai pilihan dengan peringatan, agar sumber angin tidak bercampur diam-diam.
- Tinggi vegetasi hv satu nilai setahun (arahan pengguna); h_st stasiun bawaan 0,12 m dan dapat ditimpa per tanggal di tabel.
- QA_PIXEL dibaca mentah: nilai 0 = bersih, bukan NoData (bug awal membuat semua piksel terbuang).

## Yang ditolak atau gagal
- Memakai hv sebagai h_st ditolak: keduanya berbeda besaran (vegetasi wilayah lawan stasiun).
- Regresi dT sebagai bawaan ditolak (lihat di atas).

## Hasil nyata
- core/et_bandara_batch.py, core/et_bandara_batch_report.py, mode di gui/tei_page.py (tabel angin), 11 uji baru, 58 lulus pada rangkaian terkait.
- Belum dijalankan pada data Level 2 nyata: sandbox hanya punya berkas ST (tanpa SR_B2..B7).

## Belum terverifikasi
- Perilaku pada scene nyata (kering/basah, kalibrasi dT, ET dibanding pengukuran).
- Albedo SR berbobot ESUN lawan koefisien Liang; faktor angin rata-rata harian ke jam citra.

## Langkah berikutnya
1. Pengguna menjalankan satu scene Level 2 nyata dan membandingkan ET24 dengan jalur menu ET manual.
2. Geostatistik v154, regresi spasial v155.
