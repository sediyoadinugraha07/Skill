---
date: 2026-10-25 23:00
source: claude-code
topic: landsat-processor-v125-pyarrow
status: berlanjut
---

## Tujuan
Aplikasi tidak bisa dibuka setelah perbaiki_lingkungan.bat (v124). Error di layar: AttributeError _ARRAY_API not found, jejak lewat gui.forecast_page > core.forecast > pandas > pyarrow.

## Keputusan dan alasannya
- Penyebab: skrip v124 menaikkan numpy ke 2.x, pyarrow (opsional untuk pandas) di komputer pengguna masih dibangun untuk numpy 1; pandas hanya menangkap ImportError sehingga AttributeError menjatuhkan start aplikasi.
- Perbaikan utama di kode, bukan menyuruh pengguna memperbaiki paket: import_pandas menonaktifkan paket opsional rusak lalu mengulang impor; satu halaman rusak tidak menjatuhkan aplikasi; --fix memperbarui paket opsional dan menghapus yang tetap rusak.
- Skrip .bat memakai peluncur py agar sama dengan Python aplikasi (py.exe terlihat di layar).
- Versi 125 (124 sudah terkirim).

## Yang ditolak atau gagal
- Menyuruh pengguna menurunkan numpy ditolak: memecah paket lain yang sudah dibangun untuk numpy 2.
- Membuang pandas ditolak (Forecasting dan tabel sampel memerlukannya).
- Skrip v124 gagal karena hanya memperbarui daftar tetap dan tidak melihat paket opsional.

## Hasil nyata
- core/envcheck.py (blokir opsional, --fix, --json), main_window.py (_broken_page, impor terlindung), perbaiki_lingkungan.bat, cek_lingkungan.bat, tests/test_envcheck.py (13 uji, termasuk pyarrow tiruan di subproses), README v125. Suite penuh 588 lulus.

## Belum terverifikasi
- Perilaku di Windows pengguna; kemungkinan folder pengguna masih berisi forecast_page versi lama (jejak memperlihatkan impor tanpa pelindung).
- Paket lain yang masih dibangun untuk numpy 1 di komputer itu; laporan cek_lingkungan.bat akan menunjukkannya.

## Langkah berikutnya
1. Pengguna mengganti seluruh folder dengan v125, menjalankan cek_lingkungan.bat dan membuka aplikasi.
2. Bila masih ada GAGAL, kirim laporannya; perbaikan berikutnya v126.
