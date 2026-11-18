---
date: 2026-11-09 10:15
source: claude-code
topic: landsat-processor-v207-paket-standar-jurnal-tei
status: berlanjut
---

# Landsat Processor v207: paket standar jurnal TEI

## Permintaan
Analisis TEI perlu data Excel asli dan penyajian berstandar jurnal bereputasi, termasuk bisa dianalisis dengan data lapangan.

## Temuan awal
TEI sudah punya Excel per scene (sampel berumus hidup, regresi, kontribusi suku, kelas, per ketinggian) dan Excel multi-temporal (ringkasan, tren). Belum ada: statistik sebaran penuh, koordinat piksel, transisi kelas, CI tren, jejak reproduksi, validasi lapangan.

## Dibangun
- core/tei_pack.py: write_tei_pack, dipanggil otomatis dari compute_tei_auto dan compute_tei_multitemporal (juga jalur Level 1 dan Level 2). Hanya membaca keluaran, tidak mengubah angka TEI.
- Excel standar, CSV piksel bersampel (koordinat, lon, lat), gambar 300 dpi, sheet Rekonstruksi berumus hidup, Reproduksi (sha256), Kamus_Data.
- Validasi lapangan dari CSV opsional (kolom di tab TEI): Pearson, Spearman, Kendall dengan CI, matriks kesalahan, kappa, Wilson, skor ambang, Kruskal-Wallis.
- Versi di sheet Reproduksi semua paket menjadi v207.

## Alasan dan yang ditolak
- Statistik sebaran dari seluruh raster, bukan sampel; sampel hanya untuk CSV.
- Kontribusi_Suku wajib: pada data nyata TEI praktis monoton terhadap ET, penelaah akan menanyakannya.
- Rujukan hanya yang dibaca: Hou dan Pu 2024, Cao dkk. 2019, Gaona dkk. 2025. Definisi TS, HR, MR, FAR milik aplikasi.

## Terbuka
- Belum diuji pada data lapangan nyata.
- Tanda A0 Qin: koreksi minus terbukti numerik, sumber Qin 2001b dan Rozenstein Pers. 4a belum dicocokkan (PDF perlu diunggah ulang).
- Tes: 1185 lulus, 4 dilewati.
