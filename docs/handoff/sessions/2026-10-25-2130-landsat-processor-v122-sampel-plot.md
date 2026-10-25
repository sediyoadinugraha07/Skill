---
date: 2026-10-25 21:30
source: claude-code
topic: landsat-processor-v122-sampel-plot
status: berlanjut
---

## Tujuan
Menu baru di Pengolahan Utama untuk mengambil titik sampel ML/DL dari banyak raster dan vektor, hanya pada piksel bernilai, keluaran Excel dengan X dan Y.

## Keputusan dan alasannya
- Rangka sampel = sel valid di semua layer Wajib pada grid acuan, karena itu menjamin tiap titik punya nilai walau NoData antar citra berbeda.
- Raster beda grid/CRS disamakan lewat WarpedVRT sel terdekat, karena nilai asli tidak diubah.
- Layer opsional boleh kosong di titik, agar citra berawan tidak mengosongkan seluruh rangka.
- Excel memakai rumus aktif (diverifikasi LibreOffice) agar bisa diaudit.
- Versi 122; perbaikan berikutnya 123 dan seterusnya, tidak memakai nama yang sama.

## Yang ditolak atau gagal
- Koreksi sebaran titik ditolak, sesuai permintaan pengguna (sebaran condong diterima).
- Bug yang sudah diperbaiki: fixture UTM tidak overlap, nama subset 2 bagian, GeoPackage dtype string pandas.

## Hasil nyata
- core/sampling.py, core/sampling_report.py, gui/sampling_page.py, tests/test_sampling.py (22 uji lulus), i18n +52 kunci, README bagian v122.
- Uji data Bali: grid 20,5 juta sel, rangka 3,8 juta, 2000 titik berstrata 9,7 detik.

## Belum terverifikasi
- GUI di Windows asli.
- Waktu pada raster sangat besar di atas 150 juta sel (ditolak oleh batas).
- Autokorelasi spasial pada pembagian latih/uji.

## Langkah berikutnya
1. Umpan balik pengguna, perbaikan menjadi v123.
2. Kalibrasi atmosfer dengan data setahun, cek ST_DRAD, hubungkan tau ke menu LST.
