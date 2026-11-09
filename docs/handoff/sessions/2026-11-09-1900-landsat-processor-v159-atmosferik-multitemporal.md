---
date: 2026-11-09 19:00
source: claude-code
topic: landsat-processor-v159-atmosferik-multitemporal
status: berlanjut
---

## Tujuan
Koreksi atmosferik (DOS Chavez) multi-temporal untuk Landsat Level 1, pola sama dengan v158.

## Keputusan dan alasannya
- Per band memanggil `dos_correct_band_chavez` yang sama dengan menu lama; hasil identik bit-demi-bit dengan rantai manual (diuji DOS1 dan DOS2).
- Dua sumber: Level 1 mentah (radiometrik tanpa clip otomatis) dan keluaran v158. Keluaran ber-clip ditolak oleh penjaga lama.
- DOS mandiri per scene (SHV per scene), bukan target gelap bersama; SHV antar tanggal hanya dibandingkan dan ditandai, tidak dipaksa sama. Alasan: haze memang berbeda tiap tanggal.
- Masker SHV opsional (QA dan shapefile) dan bawaan mati agar setara menu lama.
- Skala z robust diberi lantai 0,005 karena MAD nol (nilai kembar) membuat z tak bermakna.
- Menu dibungkus AtmosphericHostPage; kelas lama tidak diubah. Nama berkas baru dicek terhadap zip v158 (tidak bentrok).

## Yang ditolak atau gagal
- DOS3/DOS4 belum dibuat. Fixture lama ber-noise membuat B4/B5 tanpa nilai berulang; uji memakai band dihaluskan.
- Uji awal: patch awan uji ternyata tidak lebih gelap, dan ambang selisih terlalu ketat; diperbaiki di uji, bukan di kode.

## Hasil nyata
- core/atmospheric_batch.py, atmospheric_batch_report.py, gui/atmospheric_batch_page.py, atmospheric_host.py, tests/test_atmospheric_batch.py (12 uji), i18n 18 kunci (total 3612), README v159. 202 uji terkait lulus.

## Berikutnya
Multi-temporal untuk menu awan, wilayah, emisivitas; uji dengan Level 1 nyata; regresi spasial; WUP menunggu artikel.
