---
date: 2026-11-05 17:00
source: claude-code
topic: landsat-processor-v147-normalisasi-tei
status: berlanjut
---

## Tujuan
Coba normalisasi persentil sebagai pembanding min-max, lalu beri menu pilihan metode normalisasi di tab TEI.

## Keputusan dan alasannya
- Tab TEI: Metode (min-max bawaan, persentil 2 dan 98 bisa diubah) dan Cakupan (per scene, seluruh scene dalam folder dengan dua lintasan, atau batas manual).
- Bawaan tetap min-max per scene karena itu yang dinyatakan pengguna dipakai saat menurunkan ambang.
- Cakupan seluruh scene ditambahkan karena normalisasi per scene menghapus tingkat kekeringan absolut antar bulan; Tabel 5 naskah (rata-rata bulanan bervariasi) menyiratkan skala bersama (dugaan, perlu konfirmasi pengguna).

## Hasil nyata
- Karangasem 3 Okt 2025: min-max kering 18,3 / sedang 81,4 / tidak kering 0,3 persen; persentil 2 sampai 98: 21,1 / 51,0 / 27,8.
- core/tei.py, core/tei_report.py, gui/tei_page.py, tests/test_tei.py (10 lolos), README v147, i18n, landsat_processor_v147.zip.

## Belum terverifikasi
- Cara normalisasi yang dipakai saat ambang 0,449 dan 0,832 diturunkan belum dipastikan.
- Belum dibandingkan dengan raster TEI asli pengguna.

## Langkah berikutnya
- Pengguna memilih normalisasi untuk naskah; SST, ERA5 single levels, dan Tes uvspec masih menunggu.
