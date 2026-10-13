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
- Tab 2 punya mode 'ETr harian dari PET MODIS (MOD16)' (rata-rata PET scene x skala / hari komposit sebagai ETr harian). Alasan: stasiun sering tidak punya ETr harian untuk tanggal lama. Ditolak: memakai ET aktual MOD16 sebagai ETr (bukan referensi). Belum terverifikasi: skala 0,1, satuan, batas valid 32700, selisih PET MOD16 terhadap ETr alfalfa ASCE.
- Analisis hasil pengguna (Excel Tab 3): jangkar dingin Ts_DEM 28,7 C hanya di persentil 6, jangkar panas 39,7 C di ekor; zom dari LAI (pers. 31a) membuat zom hutan terlalu kecil; dugaan penyebab ETrF > 1,05 pada vegetasi lebat. Saran: sumber zom Klasifikasi lahan (Lampiran 2).

## Tambahan v79 (PET MODIS otomatis)
- Keputusan pengguna: mode PET MODIS di Tab 2 tidak punya kolom faktor skala dan hari komposit (PET sudah hasil akhir menu MODIS); hari komposit dibaca dari tag UNITS, bawaan 8.
- Menu ET24 langkah 3 menerima berkas PET MODIS dan menghitung ETr-24 per piksel; piksel kosong diisi rata-rata scene.
- Ditolak: faktor skala manual (berisiko ganda mengalikan 0,1). Nomor v49 pada permintaan dianggap salah ketik, dipakai v79.
- Belum diverifikasi: tag satuan MOD16, kecocokan tanggal komposit dengan citra (A2025281 vs tanggal 2025-10-03).
- Zip: landsat_processor_v79.zip

## Tambahan v80 (koreksi topografi Rn, simulasi zom LAI dan angin)
- Menu Rn tab 5 menerima DEM, MTL, fraksi langsung (0,85, asumsi); menghasilkan Rn, albedo_topo, Rs_topo. Opsional, bawaan mati.
- Simulasi zom LAI (0,016 m rata-rata) lawan NDVI (3 m seragam): rah 7,7 lawan 3,6 s/m, ET24 rata-rata hampir sama (4,53 lawan 4,62) pada ux 9,17; angin 2,55 m/s menaikkan ET24 ke sekitar 5,6 sampai 5,8 dan ETrF>1,1 ke 14 sampai 19%.
- Pengguna sedang memeriksa kecepatan angin 9,17 m/s (satuan dan jam ukur). Tanggal komposit PET sudah diperiksa pengguna sesuai.
- Ditolak: menjadikan koreksi topografi bawaan (risiko koreksi berlebih untuk ET24 sehari).
- Zip: landsat_processor_v80.zip

## Tambahan v81 (angin harian ke jam citra)
- Data angin pengguna hanya rata-rata harian (ux 2,47 m/s pada 1,2 m, DEM stasiun 135 m). Keputusan pengguna: kolom ux tetap, tambah kotak centang "sesuai jam perekaman citra"; bila tidak, aplikasi menyesuaikan.
- Pendekatan: f = 1 + A cos(2 pi (t - 14)/24), A = 0,4 (asumsi, belum diverifikasi); MTL wajib. Simulasi sensitivitas: ux 2,47 / 3,00 / 3,46 memberi ET24 rata-rata 5,65 / 5,33 / 5,10 mm/hari (zom NDVI, PET MODIS).
- Ditolak: faktor tetap tersembunyi (membingungkan); data angin per jam tidak bisa diambil (jaringan lingkungan menolak NASA POWER).
- Zip: landsat_processor_v81.zip

## Tambahan v82 (hilangkan kolom asumsi)
- Keputusan pengguna: kolom fraksi Rs langsung (Rn) dihapus dan dihitung aplikasi; kolom amplitudo dan jam puncak angin disembunyikan. Fraksi langsung kini dari kt dan korelasi Erbs (koefisien dicek ke dokumentasi DNV).
- Angin: berkas Relasi_Suhu_dan_Udara.xlsx berisi suhu dan kelembapan per jam pada 3 ketinggian, bukan angin; tidak bisa membangun model angin vs ketinggian. A = 0,4 dan puncak jam 14 tetap asumsi internal, dilog.
- Data berkas itu tampak berisik (suhu udara 45 C di 100 mdpal, loncatan antar jam).
- Zip: landsat_processor_v82.zip

## Tambahan v83 (menu ET Manual)
- Permintaan pengguna: menu baru ET Manual dari lembar Hasil_Hitung_Penman-AA.xlsx, input manual, luaran Excel, ETr harian lebih sesuai untuk Waters bila data stasiun ada.
- Dikerjakan: core/et_manual.py, gui/et_manual_page.py, tests/test_et_manual.py; menu di bawah ET24. Hasil: ETo FAO-56, ETr ASCE harian (alfalfa), AA.
- Keputusan: tidak mereplikasi kesalahan lembar lama; selisih dicatat di Excel luaran. Temuan penting: n/N dibagi 100 dua kali di lembar bulanan (Rs ~0,25 Ra), suku angin PM diganti 1,41, kurung AA salah.
- Belum diverifikasi: bentuk fungsi angin AA; ETr ASCE harian dari Rn FAO-56; ETr alfalfa belum otomatis mengisi Tab 2 (diketik pengguna).
- Zip: landsat_processor_v83.zip

## Tambahan v84 (ET Manual disederhanakan)
- Keputusan pengguna: Rs, tekanan udara, dan tinggi alat tidak perlu diinput karena lembar Excel aslinya juga menghitung; tinggi alat dianggap sama di stasiun Indonesia.
- Dikerjakan: Rs dari n/N, P dari elevasi, tinggi alat tetap 10 m; kolom bujur, terbit, terbenam ikut dihapus (N dari lintang). Masukan jadi 10 kolom.
- Ditolak: mempertahankan Rs terukur sebagai opsi (pengguna ingin sederhana). Risiko: stasiun dengan alat bukan 10 m (mis. 2 m) memberi u2 terlalu rendah; perlu diverifikasi bila ada.
- Zip: landsat_processor_v84.zip
