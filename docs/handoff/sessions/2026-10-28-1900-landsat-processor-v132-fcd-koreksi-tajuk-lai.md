---
date: 2026-10-28 19:00
source: claude-code
topic: landsat-processor-v132-fcd-koreksi-tajuk-lai
status: berlanjut
---

## Tujuan
Pengguna meminta kerapatan tajuk dan LAI dari foto (fisheye atau biasa) dengan dasar NDVI, plus telusur ulang literatur FCD (Landsat 7 vs 8/9) agar yang sudah dibangun tidak keliru.

## Keputusan dan alasannya
- FCD v131 dikoreksi: band dinormalkan per citra (rerata +- 2 SB menjadi 20-220, uraian makalah ISPRS XXXV Komisi VII) dan SSI bawaan = SI linear 0-100. Alasan: v131 memakai reflektan x 255 dan PCA SI+TI padahal sumber eksplisit hanya menyebut transformasi linear SI. Pilihan lama tetap tersedia (refl255, si_ti).
- Beda Landsat 7 vs 8/9 hanya dicatat dan dinetralkan oleh normalisasi per citra (diuji); tidak ada sumber yang menguji FCD lintas sensor. Koefisien Roy 2016 untuk NDVI tidak terbaca, jadi koreksi NDVI a,b hanya diterapkan bila pengguna mengisi.
- Foto tajuk: kanal biru, ambang Otsu atau Minimum (Glatthorn dan Beckschafer 2014), fisheye per cincin zenit (Miller, Lang-Xiang, LAI57, fCover), foto biasa lewat DCP (Macfarlane 2007, celah besar 1,3%). Semua diberi label PAI.
- Deteksi fisheye otomatis: skor kontras cincin dalam-luar, ambang 60 (foto biasa pengguna memberi 35-50, fisheye 77). Ambang awal 50 menghasilkan satu positif palsu (skor 50,4), dinaikkan.
- Kalibrasi NDVI: empat model, pilihan lewat LOOCV, layer ekstrapolasi; tanpa foto memakai FVC dimidiate kuadrat (rumus dari ingatan, ditandai perlu verifikasi).

## Yang ditolak atau gagal
- Tes GUI sempat menggantung karena QMessageBox modal pada mode offscreen; sekarang di-monkeypatch.
- Tes deteksi lingkaran awal memakai fisheye sintetis bertepi gelap (tidak realistis); diganti cakram terang.
- Bug kecil: predict_formula_text mengevaluasi semua cabang dict (IndexError pada model 2 parameter); diganti if berurutan.

## Hasil nyata
- Uji sintetis Poisson G=0,5: LAI 1, 2, 3 dipulihkan 1,02, 2,02, 2,99. Cek_Rumus Excel cocok (LibreOffice). Tiga foto pengguna: 1 fisheye, 2 foto biasa. Hasil sangat bergantung ambang: fisheye PAI efektif 1,56 (Otsu) vs 2,29 (Minimum).
- 12 tes baru (tests/test_canopy.py), 3 tes FCD ditambah/diubah; zip landsat_processor_v132.zip.

## Belum terverifikasi
- Proyeksi dan sudut pandang lensa clip-on pengguna tidak diketahui (bawaan equidistant 180). Foto biasa miring hanya indikatif.
- Rumus Carlson dan Ripley 1997 dan koefisien NDVI Roy 2016 belum dicek ke makalah. Penulis makalah ISPRS XXXV tidak tercantum pada salinan yang terbaca.
- Tidak ada foto bertitik koordinat, jadi kalibrasi NDVI belum diuji pada data nyata (hanya sintetis). GUI belum diuji di Windows asli.
- Protokol task-observer proyek tidak dijalankan di sesi ini.

## Langkah berikutnya
1. Pengguna memotret titik dengan koordinat (X,Y) minimal 10 titik berspektrum NDVI lebar, lalu kalibrasi.
2. Tanyakan proyeksi lensa clip-on; bandingkan hasil ambang Otsu dan Minimum.
