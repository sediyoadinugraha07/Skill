---
date: 2026-10-13 10:40
source: claude-code
topic: landsat-processor-waters-h-v78
status: berlanjut
---

## Tujuan
Metode Waters untuk H: rho dan rah tentatif, dT dari dua jangkar pada Ts_DEM, iterasi stabilitas, keluaran final; diagnosis Rn > 700 W/m2 lewat albedo TOA.

## Keputusan dan alasannya
- rho dan rah Waters berstatus TENTATIF (tag STATUS) karena nilai final butuh Ta = Ts - dT dari iterasi; tab H menolak berkas tentatif.
- z_ref dihapus, ketinggian dari DEM terhadap muka laut, karena z_ref hanya menggeser dT secara konstan.
- Garis dT = b + a Ts_DEM dalam Kelvin; Excel menampilkan b dalam C (b_C = b_K + 273.15 a). dT tidak dikurangi 273.15.
- Kolam jangkar minimum 300 piksel dan saringan kemiringan <= 1% untuk jangkar panas, karena jangkar tiga piksel dan puncak gunung terpilih pada uji Karangasem. Bila kolam kecil, saringan dilonggarkan dengan peringatan.
- Batas z/L stabil <= 1: pengaman numerik aplikasi, bukan Waters.
- Albedo Waters memakai reflektans TOA dibagi cos(theta_z); DOS menggandakan koreksi atmosfer.

- ETr sesaat dihitung otomatis di tab 2 (Penman-Monteith per jam ASCE-EWRI, acuan tinggi bawaan) karena iterasi L tidak bisa menggantikan syarat batas ET jangkar dingin; tab 3 membacanya dari tag zom; lembar ETr di Excel. Rasio ET panas bawaan 0.

## Yang ditolak atau gagal
- Dugaan "DOS2 mengurangi NIR berlebihan" ditarik: DOS2 sah, masalahnya penggandaan koreksi dengan alpha_path.
- Regresi Ts_DEM terhadap Ts sebagai dT ditolak: hasilnya suhu absolut. Dipakai hanya sebagai diagnostik di Excel.

## Hasil nyata
- Kode: core/et_h_waters.py (baru), perubahan et_h_rho/rah/dt/excel, gui/et_h_page.py, tests/test_et_h.py (6 uji lulus), README v78.
- Zip: landsat_processor_v78.zip, diuji dari ekstrak bersih.
- Simulasi Karangasem (albedo TOA 0,152): konvergen 5 iterasi; H rata-rata sekitar 137 W/m2 (Rn - G 588); dT_panas 3,3 K; rah_panas sekitar 8 s/m.

## Belum terverifikasi
- ETr: Cn, Cd, G, Rnl, fcd, Ra jam terverifikasi via web (ASCE Tabel 2, IFAS, K-State, UC Davis PMhrDoc) dan uji silang paket refet (selisih < 1e-4 mm/jam). Belum dicek langsung dari dokumen: u2, es, Delta, P (FAO-56). Aturan baru: tolak bila sudut matahari < 17,2 derajat.
- ux = 3 m/s, ETr = 0,55 mm/jam, ujung zom 0,002 m (pinjaman Chemin) hanyalah asumsi ilustrasi.
- Albedo 0,22 sampai 0,24 tidak tercapai di Karangasem (hanya 31 piksel); jangkar dingin jatuh ke NDVI atau LAI saja.
- Pada varian tanpa LAI, jangkar panas jatuh ke puncak gunung (DEM 2800 m) karena saringan kemiringan dibuang.
- Persamaan 38 Waters hasil ekstraksi tertulis -5(2/L), kemungkinan salah ketik; aplikasi memakai -5 z/L.

## Langkah berikutnya
1. Pengguna menjalankan v78 pada data nyata dengan ux, zx, h, ETr stasiun.
2. Putuskan sumber NDVI/SAVI (DOS2+cos atau TOA) dan L SAVI.
3. Faktor Mountain Lampiran 12 setelah satuan kemiringan terverifikasi.
