---
date: 2026-11-09 17:10
source: claude-code
topic: landsat-processor-v196-l1-dos-fallback-status-dem-option
status: berlanjut
---

# Landsat Processor v196

## Masukan
Log pengguna: MCM tetap kosong. 19 scene L2, 11 scene L1; semua L1 dilewati ("starting haze value tidak ditemukan"); status menampilkan "OK 0/0". Pengguna juga bertanya apakah ada koreksi topografi.

## Penyebab
DOS1 untuk NDVI L1 dicari pada piksel daratan bersih hasil dekimasi stride 3 dengan ambang 1000 piksel per nilai; air (objek gelap) sudah dibuang QA. MCM hanya di jalur L1, jadi kosong.

## Keputusan
- DOS dicari pada semua piksel valid (termasuk air), ambang 1000/stride^2 (min 10), lalu dimasker. Bila tetap gagal: fallback TOA tanpa DOS, ditulis di sumber emisivitas dan catatan (scene tidak dilewati).
- Status metode menghitung scene dilewati sebagai gagal.
- Koreksi topografi: tab 2 tidak memakai koreksi iluminasi atau lapse rate; DEM hanya untuk z pada tau. Opsi baru use_dem (bawaan aktif).

## Ditolak / belum
- Koreksi iluminasi (kosinus/SCS) tidak dihubungkan ke tab 2: tidak jelas dasar fisiknya untuk radiansi termal, dan belum diminta eksplisit.

## Uji
1114 lulus, 4 dilewati. 6 uji baru. Perbaikan DOS diuji sintetik saja; scene Bali nyata belum.
