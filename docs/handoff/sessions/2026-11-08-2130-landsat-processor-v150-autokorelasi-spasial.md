---
date: 2026-11-08 21:30
source: claude-code
topic: landsat-processor-v150-autokorelasi-spasial
status: berlanjut
---

## Tujuan
Membangun tab Autokorelasi Spasial (Advanced Analysis) yang menerima raster jenis apa pun (kontinu, hitungan, biner, kategorik) dan vektor, dengan keluaran citra, Excel analisis, dan diagram. Tahap berikut yang disetujui pengguna: v151 geostatistik (semivariogram), v152 regresi spasial (OLS diagnostik, GWR, MGWR).

## Keputusan dan alasannya
- Bobot raster lewat konvolusi 2D, bukan matriks n x n, karena raster berjuta piksel harus layak; S1 dan S2 diturunkan dari konvolusi dan dicocokkan dengan matriks eksplisit di uji.
- Data kategorik dianalisis per kelas (indikator Moran, proporsi tetangga sekelas, peta kohesi, kelas fokus untuk LISA/Gi*) karena nilai kelas tidak boleh dirata-ratakan.
- p permutasi dipakai untuk klaster dan FDR hanya bila permutasi >= 499; di bawahnya dipakai p analitik randomisasi. Alasan: dengan 99 permutasi p minimum 0,02 sehingga BH pada ribuan piksel tidak bisa meloloskan klaster, terbukti di uji klaster tertanam (0% terdeteksi).
- Local Moran memakai definisi Anselin (m2 = jumlah z^2 / N). esda 2.10 memakai std ddof=1, selisih tepat N/(N-1); dicatat di uji dan README.
- esda dan libpysal hanya untuk uji silang (skip bila tidak ada), bukan dependensi aplikasi.

## Yang ditolak atau gagal
- Memakai esda sebagai dependensi runtime ditolak: menambah beban pemasangan dan hitungan matriks tidak muat untuk raster besar.
- Gi* pada data bertanda campur: esda memberi tanda berlawanan; Gi* hanya bermakna untuk variabel positif, jadi nilai digeser ke minimum nol.
- Awalnya FDR langsung di atas p permutasi 99: gagal total (lihat keputusan di atas).

## Hasil nyata
- Berkas baru: core/spatial_autocorr.py, core/spatial_autocorr_report.py, gui/autocorr_page.py, tests/test_spatial_autocorr.py; tab ditambahkan di gui/advanced_analysis_page.py; 44 kunci i18n; README bagian v150.
- 21 uji lulus. I, z normalitas, z randomisasi, Geary C, Gi* cocok dengan esda sampai 1e-8. Rumus hidup Cek_Rumus dihitung ulang LibreOffice: selisih maksimum 4e-15, tanpa sel galat.

## Belum terverifikasi
- Belum diuji pada raster nyata pengguna (Bali); uji sintetis tidak membuktikan kecocokan pada data nyata.
- Waktu dan memori pada raster puluhan juta piksel (lihat catatan uji besar di README bila ada).
- Moran bivariat: interpretasi bisa menyesatkan bila kedua variabel sama-sama bertren.

## Langkah berikutnya
1. Pengguna mencoba v150 pada LST, TEI, dan peta tutupan lahan nyata.
2. v151 geostatistik: semivariogram empiris dan model, anisotropi, tab terpisah dari interpolasi.
3. v152 regresi spasial: OLS diagnostik, spatial lag/error, GWR, MGWR.
