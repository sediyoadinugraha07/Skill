---
date: 2026-10-25 22:00
source: claude-code
topic: landsat-processor-v124-envcheck
status: berlanjut
---

## Tujuan
Pengguna melaporkan kotak "Sampel" berisi "numpy.dtype size changed ... Expected 96 from C header, got 88 from PyObject". Cari penyebab dan perbaiki.

## Keputusan dan alasannya
- Penyebab kode: pandas dipakai pertama kali oleh menu Sampel (v122) dan Forecasting (v123) tetapi tidak ada di requirements.txt dan build_windows.spec. Penyebab di komputer pengguna: pandas dibangun untuk numpy berbeda dari numpy terpasang (96 vs 88 = struktur dtype numpy 2 vs 1). Bagian ini dugaan kuat, versi pengguna belum terlihat.
- Tidak membuang pandas dari kode karena Forecasting dan tabel sampel bergantung padanya; yang diperbaiki: requirements, spec, pesan galat jelas, halaman Forecasting tidak menjatuhkan aplikasi saat pandas rusak, menu Bantuan Periksa Lingkungan, perbaiki_lingkungan.bat.
- Versi 124 karena 123 sudah terkirim.

## Yang ditolak atau gagal
- Merombak sampling tanpa pandas ditolak (refaktor besar, tidak menyelesaikan Forecasting).
- Tes awal gagal pada urutan suite penuh karena atribut paket core menyimpan modul lama; fixture diperbaiki.

## Hasil nyata
- core/envcheck.py, tests/test_envcheck.py (8 uji), perubahan pada sampling.py, sampling_page.py, forecast_page.py, main_window.py, requirements.txt, build_windows.spec, perbaiki_lingkungan.bat, README v124. Suite penuh 583 lulus.

## Belum terverifikasi
- Perbaikan pada Windows pengguna: pengujian memakai simulasi pandas rusak. Hasil perbaiki_lingkungan.bat atau menu Periksa Lingkungan di komputer pengguna belum dilihat.

## Langkah berikutnya
1. Minta pengguna menjalankan Bantuan > Periksa Lingkungan Python dan mengirim laporannya bila masih gagal.
2. v125 untuk perbaikan berikutnya.
