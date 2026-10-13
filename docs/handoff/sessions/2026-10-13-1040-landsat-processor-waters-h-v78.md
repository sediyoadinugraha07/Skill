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

- Revisi ETr: tab 2 tidak lagi menghitung Penman-Monteith (modul terpisah nanti, user: aplikasi meminimalkan data lapangan). Tab 2 menerima ET harian stasiun (mm/hari) lalu konversi sinusoidal ke laju sesaat pada jam citra; atau mm/jam langsung; atau kosong (H dingin 0).

- ETr harian: tanggal, jam, lokasi dibaca dari MTL (user menolak input ulang); pilihan ETo dihapus. Kemiringan jangkar panas < 1% bersumber Waters Lampiran 7 (khusus Mountain Model); jendela elevasi tambahan aplikasi.

- zom Waters disederhanakan: hanya pers. 28 (c = 0,12 tetap, h rata-rata lokasi penelitian, zom seragam); ujung bawah/atas, pers. 31b, dan pinjaman Chemin dihapus atas permintaan user. Jendela elevasi dan kemiringan jangkar panas tidak lagi di GUI (otomatis).

## Yang ditolak atau gagal
- Pers. 31b dan mode otomatis Chemin ditolak user (fokus Waters, membingungkan).
- Penman-Monteith per jam di tab 2 ditolak user: menggandakan modul PM terpisah dan menuntut data lapangan.
- Dugaan "DOS2 mengurangi NIR berlebihan" ditarik: DOS2 sah, masalahnya penggandaan koreksi dengan alpha_path.
- Regresi Ts_DEM terhadap Ts sebagai dT ditolak: hasilnya suhu absolut. Dipakai hanya sebagai diagnostik di Excel.

## Hasil nyata
- Kode: core/et_h_waters.py (baru), perubahan et_h_rho/rah/dt/excel, gui/et_h_page.py, tests/test_et_h.py (6 uji lulus), README v78.
- Zip: landsat_processor_v78.zip, diuji dari ekstrak bersih.
- Simulasi Karangasem (albedo TOA 0,152): konvergen 5 iterasi; H rata-rata sekitar 137 W/m2 (Rn - G 588); dT_panas 3,3 K; rah_panas sekitar 8 s/m.

## Belum terverifikasi
- zom seragam menyamakan air, tanah gundul, dan hutan; Waters memakai h per jenis penutup lahan. Di Karangasem H rata-rata hanya berubah 143 ke 153 W/m2 untuk h 0,5 sampai 20 m (ETr 0,55 asumsi).
- Konversi harian ke sesaat (sinusoidal) adalah pendekatan, tidak diverifikasi pada dokumen; fraksi sekitar 0,11 per jam pada 10:00 Bali. Nilai harian ETo vs ETr berbeda 10 sampai 25% (perkiraan).
- ETr: Cn, Cd, G, Rnl, fcd, Ra jam terverifikasi via web (ASCE Tabel 2, IFAS, K-State, UC Davis PMhrDoc) dan uji silang paket refet (selisih < 1e-4 mm/jam). Belum dicek langsung dari dokumen: u2, es, Delta, P (FAO-56). Aturan baru: tolak bila sudut matahari < 17,2 derajat.
- ux = 3 m/s, ETr = 0,55 mm/jam, ujung zom 0,002 m (pinjaman Chemin) hanyalah asumsi ilustrasi.
- Albedo 0,22 sampai 0,24 tidak tercapai di Karangasem (hanya 31 piksel); jangkar dingin jatuh ke NDVI atau LAI saja.
- Pada varian tanpa LAI, jangkar panas jatuh ke puncak gunung (DEM 2800 m) karena saringan kemiringan dibuang.
- Persamaan 38 Waters hasil ekstraksi tertulis -5(2/L), kemungkinan salah ketik; aplikasi memakai -5 z/L.

## Langkah berikutnya
1. Pengguna menjalankan v78 pada data nyata dengan ux, zx, h, ETr stasiun.
2. Putuskan sumber NDVI/SAVI (DOS2+cos atau TOA) dan L SAVI.
3. Faktor Mountain Lampiran 12 setelah satuan kemiringan terverifikasi.

## Tambahan sesi 2026-10-13 sore (tab 1/2/5)
- Tab 1 hanya LST (Bandara: rho final langsung; Waters: tentatif, final dari iterasi tab 3). Alasan: pengguna ingin menghindari salah pilih Ta.
- Tab 2: filter dialog MTL (txt, json) diperbaiki; sumber zom berlabel NDVI/LAI/Klasifikasi lahan (NDVI = pers. 28, zom = 0,12 h; NDVI hanya acuan grid). Excel ETr tab 2 baru; ETr sesaat otomatis mengisi tab 3 dan tab 5.
- ET24 (Waters hlm. 34-35) dipecah tiga tab atas permintaan pengguna dan dipindah ke menu terpisah 'ET24 (ET Aktual Harian)' di bawah menu H (gui/et_24_page.py, core/et_et24.py; tersambung ke menu H lewat sinyal ready_for_et24 di main_window): tab 1 ETinst (lambdaET = Rn - G - H, ETinst = 3600 lambdaET / lambda, tanpa ETr), tab 2 ETrF (ETinst / ETr sesaat dari tab 2 menu H), tab 3 ET24 (ETrF x ETr-24 = ETr harian). Ditolak: memotong ETrF ke 0-1 (manual tidak menyuruh); menggabung ketiganya dalam satu tab; menaruhnya sebagai tab 5 sampai 7 di dalam menu H (bercampur dengan H).
- Belum terverifikasi: scene Karangasem dengan ETr 0,55 (asumsi) memberi ETrF rata-rata 1,21; ET24 bergantung pada sebaran sinusoidal bila ETr sesaat dari ETr harian; rumus rho Senay/Januar belum dicocokkan ke makalah asli.
