---
date: 2026-11-09 16:50
source: claude-code
topic: landsat-processor-v190-logo-e3-tanpa-institusi
status: berlanjut
---

## Ringkasan
v190: logo E3 (pita S miring, piksel mengecil, satelit amber) menjadi logo utama, D tetap pendamping. Nama Universitas Pendidikan Ganesha dan Xinyang Normal University dihapus dari semua tampilan.

## Perubahan
- tools/make_brand_assets.py ditulis ulang; assets/brand/ dibangun ulang (17 SVG+PNG, geospectra.ico 7 ukuran, ikon_256).
- gui/main_window.py (Tentang), README baris 3, i18n (kunci lama dihapus, kunci baru via ex190; total 3977).
- tests/test_brand.py: nama aset baru dan uji bebas nama institusi. 31 tes lulus (brand, i18n, lst_multi).

## Keputusan dan yang ditolak
- QSettings ORG "Undiksha" tidak diubah: tidak tampil, dan mengubahnya mereset pengaturan pengguna.
- "Xinyang" di tests/test_et_24_bandara.py dibiarkan: itu nama lokasi, bukan atribusi.
- Ikon E3 versi penuh tidak dipakai di bawah 64 px; ico memakai ubin sederhana.

## Belum dilakukan
- Pemeriksaan kemiripan merek, tinjauan 地谱, tampilan bilah tugas Windows.
- Sentinel: menunggu unggahan R20m (SCL, B07, B8A, B11, B12), lalu L1C, DEM, S3 SLSTR L2 LST, S5P. Belum ada kode pembaca.
- Uji data nyata untuk pasangan W (v189) dan ET Waters (v186).
