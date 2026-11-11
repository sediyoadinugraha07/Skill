---
date: 2026-11-09 06:11
source: claude-code
topic: landsat-processor-v192-sentinel-l1c
status: berlanjut
---

# Landsat Processor v192: Sentinel-2 L1C

## Ringkasan
Menu Sentinel > S2 L1C, 10 tab: laporan kualitas, reflektansi TOA dan radiansi, masker MSK_CLASSI, koreksi DOS1/DOS2, perbandingan dengan L2A, lalu indeks, air, penajaman, perubahan, komposit yang memakai kode S2A lewat allow_l1c dan atm. Kode baru: core/s2l1c.py, gui/s2l1c_page.py. 1086 uji lulus (tanpa test_twi dan test_modis_lst).

## Keputusan dan alasan
- Fungsi S2A dipakai ulang (open_scene allow_l1c, pseudo-SCL 60 m dari MSK_CLASSI, hook Scene.atm) daripada menyalin: satu jalur kode, hasil konsisten dengan S2A.
- DOS memakai kuantil 0,01% per band dari piksel bebas awan; DOS1 Tz=1, DOS2 Tz=cos(zenit). Hasil di-cache per adegan dan pengaturan supaya dos_correct tidak menghitung dua kali.
- Validasi terhadap L2A di 60 m: RMSE daratan TOA 0,0511, DOS1 0,0488, DOS2 0,0397. NIR makin bias (DOS tidak mengoreksi transmisi). Dilaporkan apa adanya di README dan HELP.
- Bug yang ditemukan: berkas QI_DATA/MSK_QUALIT_B04.jp2 cocok dengan pola band L1C, jadi QI_DATA dilewati; tetapi MSK_CLDPRB/SNWPRB di QI_DATA harus tetap terbaca (urutan pengecekan diperbaiki, tes lama menangkapnya).

## Ditolak
- Deteksi bayangan awan geometris: tidak ada di L1C dan tidak divalidasi, diberi peringatan saja.
- Koreksi sirus dengan B10: hanya penandaan, tanpa koreksi.
- Default DOS di tab pengolahan: tetap "tanpa koreksi", pengguna memilih sendiri; hanya tab Koreksi DOS yang default DOS2.

## Belum beres
- Urutan nama layer MSK_QUALIT (hanya layer jenuh = ke-8 konsisten dengan sampel) dan ambang B10 (SentiWiki) perlu verifikasi ke spesifikasi/kode Sen2Cor.
- Validasi hanya satu adegan tropis; tampilan Windows belum dilihat.
- Lama: pasangan W (v189), ET Waters (v186), tinjauan merek/Mandarin, koreksi topografi DEM, sampel S3 SLSTR/S5P, koefisien albedo, Tasseled Cap.
