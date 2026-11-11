---
date: 2026-11-09 11:04
source: claude-code
topic: landsat-processor-v188-identitas-visual-geospectra
status: berlanjut
---

## Ringkasan
Pengguna menyetujui rekomendasi: Opsi 1 (bumi bergaris spektrum) sebagai logo utama dan ikon, Opsi 4 (sapuan satelit) sebagai ilustrasi pendamping.

## Keputusan dan alasan
- Satu tanda utama agar identitas konsisten dan pengajuan merek sederhana. Opsi 4 tidak dipakai sebagai ikon karena detail tipis (panel surya, garis bumi) hilang pada 16 sampai 32 px (diuji dengan render).
- Ikon kecil (48 px ke bawah) tanpa orbit dan titik; ikon besar penuh.
- Konsep prisma awal ditolak karena terlalu mirip sampul album terkenal.
- Layar pembuka tanpa teks versi agar tidak basi. Folder dan awalan zip tetap landsat_processor.

## Berkas
assets/brand/* (24 berkas, termasuk geospectra.ico), tools/make_brand_assets.py, gui/brand.py, gui/main_window.py (ikon, splash), build_windows.spec (ikon exe, datas), tests/test_brand.py (5 uji), README v188.

## Belum dilakukan
Cek kemiripan logo dan nama di DJKI/CNIPA/WIPO; ubah teks SVG menjadi kurva; lihat ikon di taskbar Windows; tinjauan penutur asli untuk 地谱.
