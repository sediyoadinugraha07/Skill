---
date: 2026-11-09 18:00
source: claude-code
topic: landsat-processor-v158-radiometrik-multitemporal
status: berlanjut
---

## Tujuan
Koreksi radiometrik multi-temporal dari modul yang ada untuk Landsat Level 1 mentah (satu folder, banyak scene).

## Keputusan dan alasannya
- Modul hitung (mtl_parser, correct_band, raster_io) dipakai ulang tanpa rumus baru; batch hanya orkestrasi. Hasil identik bit-demi-bit dengan menu satu scene (diuji).
- LandsatRadiometricJob tidak dipakai langsung: ia satu MTL per eksekusi dan fallback glob `*_B<n>.TIF` dapat memilih band scene lain pada folder banyak scene. Pemasangan lewat atmo_scan (ID scene).
- Level 2 dilewati dan dilaporkan (penskalaan sendiri).
- Statistik persen di luar [0,1] dihitung sebelum pemotongan; pemotongan dilakukan setelah correct_band(clip_negative=False) dan setara hasil menu lama.
- Resume lewat tag GeoTIFF BATCH_SIG (parameter), supaya luaran lama dengan parameter berbeda tidak terpakai diam-diam.
- Menu Koreksi Radiometrik dibungkus RadiometricHostPage dengan dua tab; kelas lama tidak diubah.
- Setelah v156 menimpa berkas lama, setiap berkas baru kini dicek namanya terhadap zip sebelumnya (tidak ada tabrakan di v158).

## Yang ditolak atau gagal
- Memanggil Job berulang per scene ditolak (risiko campur band).
- Harmonisasi Landsat 8 dan 9 ditolak untuk tahap ini (di luar cakupan; dicatat).

## Hasil nyata
- core/radiometric_batch.py, core/radiometric_batch_report.py, gui/radiometric_batch_page.py, gui/radiometric_host.py, tests/test_radiometric_batch.py (9 uji), i18n 16 kunci, README v158.

## Belum terverifikasi
- Scene Level 1 nyata dalam jumlah besar; waktu proses dan disk untuk arsip besar.
- Band termal L4-L7 dengan VCID (parser lama tidak membaca).

## Langkah berikutnya
1. Pengguna menjalankan folder Level 1 nyata dan membandingkan satu scene dengan menu lama.
2. Lanjut multi-temporal untuk menu berikutnya (atmosferik, awan, wilayah, emisivitas) sesuai urutan diskusi.
