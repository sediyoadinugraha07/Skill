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

## Tambahan v85 (tinggi alat angin ditampilkan)
- Pengguna menanyakan arti 2,47 (contoh saya; itu angin harian rata-rata dari data pengguna sebelumnya) dan meminta tinggi alat tetap muncul. Kolom opsional dikembalikan, bawaan 1,2 m (dari keterangan pengguna). Koreksi atas v84 yang mengunci 10 m.
- Perlu diverifikasi: tinggi alat sebenarnya tiap stasiun BMKG.
- Zip: landsat_processor_v85.zip

## Tambahan v86 (topo Rn sehari penuh)
- Pengguna: hasil dengan topo Rn naik jauh. Analisis: kenaikan rata-rata utamanya dari angin (u200 19,8 ke 4,4 m/s), bukan topo (efek topo pada rata-rata ~0,0). Topo sesaat membalik bias bayangan (teduh − terpapar dari +1,1..+1,7 ke −2,1..−2,7 mm/hari). Keputusan: iluminasi terintegrasi sehari penuh, otomatis, posisi input tetap di menu Rn. Angin harian 2,47 harus dikoreksi ke jam citra (kotak centang Tab 2).
- Ditolak: pembatasan REL_MAX ad hoc dan penyetelan faktor agar cocok; dipilih alasan fisika (ETrF 24 jam).
- Belum diverifikasi: ux sebenarnya pada proses pengguna (u200 4,45 setara ux ~2,06 pada zx 1,2 m, bukan 2,47 atau 3,05); validasi lapangan; efek LST jam citra pada H.
- Zip: landsat_processor_v86.zip

## Tambahan v87 (Excel angin, Excel Rn topo, saringan lereng jangkar dingin)
- Temuan: u200 = 4,4476 di Excel pengguna sesuai ux 2,47 x faktor 1,235 = 3,05 pada zx = 10 m, h = 0,12 m, zom LAI (kotak centang tidak dicentang): pengaturan pengguna benar; dugaan saya sebelumnya (ux 2,06) keliru. Kolom zx pengguna berisi 10 m, sedangkan pengguna pernah menyebut alat sekitar 1,2 m (zx 1,2 memberi u200 6,58): perlu dikonfirmasi.
- Keputusan pengguna: Excel menampilkan ux yang diketik; Rn sebelum dan sesudah topo di Excel; saringan lereng jangkar dingin boleh aktif hanya bila Rn dikoreksi topo. Dikerjakan semuanya (tag WIND_JSON, Excel Rn, tangga 10 dan 20 persen).
- Ditolak: saringan lereng selalu aktif (mengubah hasil tanpa topo dan membingungkan).
- Belum diverifikasi: ambang 10 dan 20 persen (asumsi), efek pada data asli pengguna (ditunggu pengguna menjalankan ulang).
- Zip: landsat_processor_v87.zip

## Tambahan v88 (konsistensi u* jangkar dan piksel)
- Pengguna: tinggi alat angin 10 m (1,2 m ternyata alat hujan); Rn topo dipakai di G dan H; minta cek lahan terbuka dan bayangan, sebaran mirip hasil sebelumnya.
- Temuan: v87 hasilnya ~sama dengan topo sesaat (5,87 vs 5,93) karena kalibrasi dT tidak membedakan; akar masalah: pada Sampel_L, piksel sepanas jangkar panas punya H 150..190 W/m2 (bukan 441) dan rah ~20 (bukan 8,35). Penyebab: L jangkar memakai u* netral tetap, L piksel memakai u* terkoreksi. Perbaikan: perbarui u* jangkar tiap putaran. Uji: rasio 1,00 vs 0,18.
- Dampak simulasi: ET24 rata-rata 5,79 jadi 4,50; lahan terbuka ~0; vegetasi rapat 5,5; ET > 1,1 PET 25% jadi 2,7%.
- Tangga saringan lereng jangkar dingin memilih NDVI >= 0,6 (LAI median 1,2) sebelum melonggarkan lereng ke 20% pada LAI: belum diubah, perlu dinilai.
- Belum diverifikasi: kesesuaian dengan teks Waters; hasil pada data asli pengguna.
- Zip: landsat_processor_v88.zip

## Tambahan v89 (hasil v88 pengguna diterima, ZW ET Manual 10 m)
- Hasil pengguna (zip c8083441, Excel ea68836a) dipastikan versi v88 (catatan u* jangkar diperbarui, iterasi 8, ux 2,47 jadi 3,05, zx 10, Rn topo hari). ET24 rata-rata 4,50 (v87 5,87); ET > 1,1 PET 2,8% (v87 32,5%); lahan terbuka sekitar 1,5 sampai 1,7, datar sampai landai seragam; vegetasi menurun monoton menurut relD (2,0 sampai 5,3); korelasi ET dengan NDVI 0,76.
- Kekurangan yang diterima: ET negatif 1,8% (NDVI rendah, lereng > 30 derajat; lahan terbuka lereng > 20 derajat rata-rata sekitar 0); jangkar dingin pakai NDVI >= 0,6 (LAI median 1,2, dT dingin 2,44) karena LAI+albedo hanya 26 piksel; faktor angin harian dan Erbs belum diverifikasi; belum ada validasi lapangan.
- Keputusan pengguna: hasil v88 boleh dianggap hasil Waters minimal terbaik; lanjut ke metode Bandara.
- Dikerjakan: ZW_STD ET Manual 1,2 ke 10 m (templat, contoh, teks, uji). Diuji dan ditolak mengubah: urutan tangga jangkar dingin (hasil identik karena tingkat LAI tidak lolos MIN_POOL pada 10% maupun 20%).
- Ditolak: memotong ET negatif di aplikasi (Waters tidak memotong; masking dilakukan pengguna pada analisis hilir).
- Zip: landsat_processor_v89.zip. Berikutnya: metode Bandara.

## Tambahan v90 (mulai metode Bandara: tinjauan rah, dT, H terhadap Chemin)
- Pengguna: Albedo sampai RL naik Bandara dianggap sesuai; RL naik Bandara wajib Ts_DEM (hapus pilihan LST asli: dikerjakan di v90); RL turun memakai Ta = Ts - 3 (dijelaskan, kini LST bukan Ts_DEM; keputusan menunggu); Rn disamakan (topo); G dan rho (Senay, Januar) dianggap sesuai. Minta analisis kebutuhan masukan rah, dT, H terhadap PDF Chemin (Hitungan_H.pdf, hlm. 87, 91-132).
- Temuan: kode Bandara sudah mengikuti manual (rah1 dari piksel kering) tetapi rantai rah sangat sensitif: pada data Karangasem rah_kering 83,5 s/m, L_kering -2,2 m, rah1 rata-rata 267, dT_panas 102 K, 60,7 persen piksel dT di luar -2..25 K. Perubahan tanda turunan albedo mengubah dT_kering 103 menjadi 489 K. rah_kering 30 memberi 15 K.
- Manual tidak konsisten: Zsur 10 vs 100 m, k 0,4 vs 0,41, T' = (T0 - Tz)/2, U*eff tanpa 1/k, m1 dan m2 tidak diberikan, rah2 dan rah3 ada di manual tetapi tidak diterapkan di aplikasi (keputusan 2026-10-12).
- Belum diputuskan: apakah menjalankan rah2/rah3 dan dT2/H2 sesuai manual hlm. 122-132; apakah Ta RL turun memakai Ts_DEM; ambang kering 310 K dan albedo 0,18.
- Zip: landsat_processor_v90.zip

## Tambahan: uji rah2 dan rah3 Bandara (tanpa perubahan kode aplikasi)
- Pengguna: Ta RL turun tetap LST - 3; m1 dan m2 setara a dan b NOAA (z0m = exp(a + b NDVI)); k 0,41; ingin NOAA (Chemin dan Ahmad; Chandrapala) dan Landsat (Bandara) dipadukan; minta rah2 dan rah3 diuji sebelum pengguna menjalankan di aplikasi (PDF H_Bandara.pdf berisi rah1 NOAA/Landsat saja; rah2 dan rah3 dari Hitungan_H.pdf hlm. 122-132).
- Rantai uji (skrip di scratchpad sim/run25.py dan run27.py): RL naik Ts_DEM, RL turun LST - 3, Rn topo hari (rata-rata 622), G Bandara, rho Senay. Hasil: piksel kering 28.005, rah_kering 93 s/m, L -1,8 m, rah1 rata-rata 330.
- Temuan penting: piksel basah otomatis NDVI <= 0 memilih 648 piksel puncak gunung (DEM sekitar 2800 m), x_basah 319,8 K > x_kering 312,3 K, sehingga aplikasi akan berhenti dengan galat selisih x. Sungai/laut tidak ada (laut dimasker). Perlu keputusan jangkar basah.
- Koreksi pernyataan sebelumnya: dT besar (66 sampai 109 K) bukan sendirinya cacat ET, karena H_kering = Rn - G ditetapkan; yang menentukan ET adalah rasio rah antar piksel. dT besar hanya membuat dT tidak bermakna sebagai selisih suhu.
- Hasil ET24 (cold dT = 0 / cold 1,05 ETr): Landsat 5,18 / 4,31; NOAA U*eff 4,87 / 4,00; Waters v88 4,50. Bandara dengan dT = 0 pada vegetasi rapat: ET > 1,1 PET pada 22,8 sampai 29,8 persen piksel. U*eff polinomial NOAA mentah 0,572 terpotong ke batas 0,45 (turunan albedo positif).
- Belum diputuskan: definisi jangkar basah; implementasi rah2 dan rah3 di aplikasi; apakah memakai U*eff NOAA.

## Tambahan v91 (Bandara tahap 3 dikerjakan)
- Permintaan pengguna: perbaiki L (hlm. 20), terapkan rah2 dan rah3; kolom yang dihitung aplikasi disembunyikan dan dicatat di Excel gaya Waters; tampilkan hanya masukan dari citra dan masukan manual yang benar-benar perlu (angin hanya bila perlu).
- Keputusan: Bandara tanpa angin stasiun (u* = U*eff dari citra); hv opsional (kosong = Chandrapala -5,5/5,8); jangkar basah otomatis air, fallback vegetasi dengan 1,05 ETr (adaptasi Waters); L stabil memakai Webb; |L| >= 0,5 m.
- Ditolak: NDVI <= 0 tanpa saringan (memilih puncak gunung); dT = 0 pada vegetasi (ET > 1,1 PET di 23 sampai 30 persen piksel).
- Hasil simulasi: ET24 4,11 (Waters v88 4,50); belum ada validasi lapangan.
- Zip: landsat_processor_v91.zip. Berikutnya: pengguna menjalankan pada data asli dan memeriksa Excel _H_bandara_iterasi; menu ET24 untuk Bandara belum menerima ETr dari tab 3 secara otomatis.

## Tambahan v92 dan v93
- v92: Bandara tanpa ETr; titik basah dT = 0; garis dT dua titik y = a + b x. Keputusan pengguna: Chemin tidak mengadopsi Waters.
- v93: galat jangkar basah di data pengguna diganti tangga fallback (air, vegetasi rapat, vegetasi tertinggi, terdingin). ET24 Bandara baru (tab 4 menu ET24): Lambda, Kexo24 (Excel pengguna), Rn24 = (1 - alpha) K24 + RL24, ET24 = Rn24/(L rho_w) 86400 1000, ETact24 = ET24 x Lambda.
- Temuan: manual Chemin hlm. 148 MEMBAGI rho_w (1000), bukan mengalikan; rumus pengguna dengan Pw = 1 tidak dipakai. Manual Landsat 7 memakai Rn24 = (1 - alpha) K24 - 110 tau_sw; pengguna memilih RL24 citra. Ksun Excel 1367 (manual 1358).
- Rho Chemin (persamaan Pakistan, P dan e stasiun) dibanding Senay (3,486 P/(1,01 T)): selisih <= 0,5% untuk e 15 sampai 35 mbar; rho aplikasi tetap Senay dan Januar (P dari DEM, Allen).
- Zip: landsat_processor_v93.zip. Berikutnya: pengguna menjalankan pada data asli.

## Tambahan v94
- Pengguna: menu ET24 harus dibedakan per metode (tab luar Waters dan Bandara, tab langkah di dalam); dT Chemin untuk kasus gurun, sehingga dT Bandara memakai adopsi pengguna (regresi Ts_DEM terhadap LST dalam derajat Celsius, dT = a + b LST); pilihan RL24 atau -110 tau_sw diserahkan ke analisis; minta rujukan lain untuk ET dengan fraksi evaporatif.
- Dikerjakan: GUI ET24 dua tab luar; Bandara tiga langkah (Lambda, Rn24, ET24) dengan Excel masing-masing; compute_bandara_h dt_mode regresi (bawaan) atau dua_titik; RL24 manual atau citra.
- Temuan: file contoh pengguna (ROI 1878 piksel) memberi Ts_DEM = 1,82 + 0,9708 LST (C), R2 0,9999; seluruh scene Karangasem memberi a 16,7, b 0,533, R2 0,41. dT regresi 25,5 sampai 40,2 K (bukan Ts - Ta). Lambda rata-rata 0,485 (P5 0,36, P95 0,59): kontras sempit. ETact24 3,38 mm/hari (RL24 manual) dan 2,46 (RL citra); ET24 potensial 6,94 dan 5,07; PET MOD16 komposit 6,03.
- Rujukan lain: Almhab dan Busu 2008 (Eq. 17 tercetak rusak, dan memaksa L = 0 bila stabil), Tan dkk. 2021 (ET24 = 86400 Lambda (Rn24 - G24)/lambda).
- Keputusan: RL24 bawaan -110 tau_sw (argumen harian rata-rata); RL citra tetap tersedia. Belum diputuskan: ROI atau seluruh scene untuk regresi dT.
- Zip: landsat_processor_v94.zip.

## Tambahan v95
- Pengguna: tab Rn24 membingungkan (kolom tau aktif/mati, tau konstan); input Rn, Rs, albedo harus versi topo; ETact tampak terpotong; ET Bandara terlalu tinggi. Berkas: H_bandara_iterasi.xlsx, rah_Bandara_regresi.xlsx, Rn_sebelum_sesudah_topo.xlsx, ET24_pot dan ETact24 (raster).
- Temuan: ETact hanya 18% piksel karena U*eff = NaN untuk z0m > 0,26 m (ln(Zsur/z0m) - psi <= 0,05). H piksel kering hanya sekitar 150 dari 486 W/m2 pada regresi mentah. Albedo_topo dikali K24 datar menghasilkan Rn24 tidak konsisten di lereng teduh. rah1 rata-rata 1205 s/m (44% di luar 5 sampai 500) belum dipecahkan: U*eff kecil akibat psi 3,59 dari L piksel -1,3 m (manual hlm. 20), U*kering 0,157 m/s.
- Dikerjakan: lantai U*eff 0,2; K24 topo; Λ dipotong 0 sampai 1; opsi dT regresi terskala; GUI Rn24 dirapikan. Ditolak: menjadikan regresi terskala bawaan (Λ median 0, tidak masuk akal).
- Terbuka: asal U*kering dan rah1 terlalu besar (butuh keputusan pengguna); validasi ETact terhadap ET terukur; apakah regresi Ts_DEM cocok sebagai dT.
- Zip: landsat_processor_v95.zip.

## Tambahan v96
- Pengguna: pakai satu perhitungan rah1 dan U*eff saja, sesuaikan dengan Almhab dan Busu 2008, dan adopsi dT Almhab ke Chemin bila bisa.
- Almhab: rah = ln(z2/z1)/(u* k), z1 0,1 m, z2 2 m; u* = u(z) k / ln(z/zm) dengan angin stasiun 200 m; dT dua titik dengan Ts (Eq. 15), dT basah = 0; iterasi L sampai H berubah < 10%, L > 0 dipaksa netral. Dua titik ini sama dengan manual Chemin.
- Dikerjakan: rah_mode almhab (bawaan) di tab 2, rah Almhab + psi di tab 3, GUI dT bawaan dua titik. Angin 200 m diturunkan dari rah_kering Chemin karena tanpa stasiun (penyesuaian, perlu ditinjau). Data uji: rah rata-rata 63 s/m (sebelumnya 1205); regresi dT mentah menjadi Lambda 0 (H > Rn - G) sehingga tidak layak; dua titik Lambda 0,65 (p5 0,04, p95 1,0), ETact 4,4 mm/hari (belum divalidasi).
- Terbuka: rah_kering Chemin (sekitar 93 s/m, dT kering 40 K) masih tinggi; jangkar basah pada data uji jatuh ke fallback; validasi terhadap ET terukur.
- Zip: landsat_processor_v96.zip.

## Tambahan v97
- Pengguna: angin rata-rata diisi manual seperti Waters beserta tinggi alat, lalu rah dan dT; apakah logika dT Waters tanpa ETr bisa dan optimal untuk Chemin.
- Dikerjakan: ux, zx, h, faktor jam citra opsional di tab 2 Bandara (station_u200 dipakai ulang). dT Waters tanpa ETr = dua titik dengan H basah 0; tidak ada kode baru.
- Temuan: ETact di data uji tidak sensitif terhadap angin (ux 2 sampai 5 m/s: 5,2 sampai 4,5 mm/hari), jadi ET tinggi bukan terutama karena angin. Dugaan penyebab: jangkar basah fallback vegetasi (dT = 0) dan bentuk garis dT; belum diverifikasi.
- Terbuka: peta piksel basah (laut atau waduk), validasi terhadap ET terukur, opsi H jangkar basah tidak nol (butuh ETr atau fraksi).
- Zip: landsat_processor_v97.zip.

## Tambahan v98
- Pengguna: kolom peta basah muncul lagi (usulan dihapus); apakah batas |Rn - G| 0 atau 20 berpengaruh; ETact bernilai 0 di wilayah kering, apakah itu kekurangan (dugaan nilai sebenarnya nol atau negatif); bandingkan dengan Waters.
- Temuan: dengan angin 2,47 m/s (harian, 3,05 m/s di jam citra), dT kering 6,8 K dan rah akhir 17,7 s/m (wajar). ETact 4,96 vs Waters 4,50 mm/hari, r = 0,949. Nol (25.444 piksel, 3%) hanya di desil terpanas (29% desil itu); Waters di sana median -0,06 (negatif pada banyak piksel), jadi nol konsisten secara fisik; sebabnya jangkar kering = median sehingga piksel lebih panas punya H > Rn - G. Lambda = 1 pada 7,8% piksel (lebih dingin dari jangkar basah vegetasi), Waters di sana 5,98 mm/hari. Batas 20 W/m2 hanya 320 piksel, dampak < 0,001 mm/hari.
- Dikerjakan: peta basah disembunyikan; Lambda mentah disimpan; teks Excel angin diperbaiki.
- Ditolak: menghapus pemotongan ke nol (ET negatif tidak bermakna fisik); mengubah jangkar kering ke persentil ekstrem (belum diputuskan).
- Zip: landsat_processor_v98.zip.

## Tambahan v99
- Pengguna: nilai 0 ETact dipertahankan atau disesuaikan; deteksi laut atau danau di Waters dan Bandara; jadikan batas 20 W/m2 ketetapan; apakah wilayah lain (Xinyang) akan galat.
- Keputusan: nol dipertahankan (ET negatif tidak bermakna; Waters juga sekitar nol di piksel itu), Lambda mentah disimpan sebagai pembanding. Batas 20 tetap dan tidak ada di GUI.
- Temuan: Bandara mendeteksi air lewat NDVI <= 0, lereng <= 1%, Ts_DEM <= persentil 10 (butuh NDVI di tab 3; air hangat di atas persentil 10 tidak terdeteksi). Waters tidak punya deteksi air: jangkar dingin = vegetasi penuh (NDVI >= 0,6 atau LAI), air hanya diperlakukan pada G/Rn = 0,5 (NDVI < 0).
- Risiko wilayah lain: ambang kering Chemin (310 K, albedo 0,18) khas lokasi studinya; fallback persentil dan kini albedo median. Masukan wilayah (angin, ETr, tanggal MTL, tinggi vegetasi) tetap harus sesuai wilayah.
- Zip: landsat_processor_v99.zip.

## Tambahan v100
- Pengguna: ETact Bandara punya piksel NoData, perlu diperbaiki atau tidak.
- Temuan: 320 piksel, semuanya |Rn - G| < 20 W/m2 (Rn median 7), ET24 potensial negatif, gugus kecil di lereng sangat teduh; tetangga Lambda median 0,89. H tidak NaN.
- Dikerjakan: tanpa Lambda dan Rn24 <= 0 diisi 0; ETact negatif dinaikkan ke 0; tanpa Lambda dan Rn24 > 0 tetap NoData. Ditolak: mengisi Lambda dari tetangga (tidak berdasar fisik pada Rn24 negatif).
- Zip: landsat_processor_v100.zip.

## v101: BT MODIS dan LST SCM MODIS
- Keputusan pengguna: ET MODIS ditunda; validasi ET digabung ke menu Validasi yang ada (penyamaan resolusi dilakukan manual pengguna). Lanjut ke LST MODIS: BT di MODIS L1B dulu, lalu SCM, lalu MCM.
- Rumus pengguna "Ts = b/1+alog(((lambda*b)/rho)*b0)" ditafsirkan sebagai Artis & Carnahan Pers. 3/4: Ts = Tb/(1 + (lambda Tb/rho) ln eps). Bentuk harfiah salah (prioritas operator dan ln dipasang pada hasil kali) dan lambda 11.030 (um) dengan rho 0.01438 (m K) tidak sepadan; lambda dikonversi ke meter. Contoh Tb 300 K, eps 0.98: benar 301.40 K, harfiah 312.33.
- Diterapkan di core/modis.py (mode "bt"), core/modis_lst.py, gui/modis_lst_page.py, core.lst.scm_artis_carnahan(wavelength_um). Ditolak: BT untuk band selain 31/32 (band 20 dsb. punya kontribusi surya siang hari, belum divalidasi).
- Terbuka: lambda pusat tunggal vs respons detektor (sampai 0,11 K); emisivitas harus se-grid dengan BT MODIS (1 km), belum ada resampling otomatis; MCM MODIS belum dibangun.

## v102: NDVI Threshold di menu Emissivity
- Keluhan pengguna: empat pilihan NDVI Threshold tidak terlihat jelas. Penyebab: keempatnya hanya item satu QComboBox tanpa koefisien. Kini empat radio button dengan koefisien tampil, plus ringkasan rumus aktif. Bug kecil: "&" pada label dibaca Qt sebagai mnemonic, diganti "&&".
- Koefisien Tabel 3 sudah sama persis dengan PDF Nugraha et al. 2024 (tidak ada yang diubah). Rumus tunggal (tanpa tiga cabang NDVIs/NDVIv Pers. 4) tetap, sesuai keputusan pengguna sebelumnya.
- Terbuka: pemakaian koefisien Tabel 3 untuk MODIS band 31/32 belum divalidasi; emisivitas MODIS perlu se-grid dengan BT 1 km.

## v103: area gulir
- Keluhan: halaman terpotong saat maximize dan tidak bisa digeser saat jendela kecil. Penyebab: 16 halaman (termasuk Emissivity) menaruh layout langsung di widget tanpa QScrollArea. Dipilih pembungkusan generik di main_window (hanya bila halaman belum punya QScrollArea) daripada mengubah 16 berkas satu per satu. Efek samping: main_window menyimpan daftar halaman di self._pages karena stack kini berisi pembungkus.
- Lebar: kotak centang berteks panjang tidak bisa membungkus dan memaksa lebar minimum; diganti teks pendek plus label penjelas.
- Terbuka: Vegetation Index masih lebar minimum 1968 px (belum diselidiki sumbernya), Koreksi Topografi 962, Reprojection 848, Landsat L2 839.

## v104: MODIS Emisivitas dan MCM Sobrino
- Keputusan pengguna: menu emisivitas MODIS terpisah karena koefisien NDVI Threshold Tabel 3 Landsat khusus Band 10/11. Metode: NBEM Valor & Caselles dan NDVI Threshold (Sobrino, Tang). Pernyataan "CBEM merujuk Valor and Caselles" ditafsirkan sebagai salah label (itu NBEM); CBEM tutupan lahan tidak dibangun.
- MCM pertama: Sobrino dan Raissouni. Pengguna menyebut input mean LSE dan BT 31/32; rumus (Pers. 13 artikel = LST1 Sobrino 2003 Pers. 12) juga butuh Delta LSE dan uap air W, jadi keduanya input wajib. W raster atau satu nilai (g/cm2).
- Pengguna menyatakan P1-P7 = reflektansi band MODIS dan Tabel 3 sesuai sumber, minta dicek. Hasil cek dari PDF (Tang 2015, Sobrino 2003/2008): Tang cocok persis; Sobrino TIDAK cocok. Versi pertama v104 memakai Tabel 3 apa adanya (emisivitas turun sampai 0,961); diganti mengikuti sumber primer (tiga cabang NDVI, Tabel IV Sobrino 2008). Hasil akan beda dari hitungan literal Tabel 3 artikel; perlu disampaikan ke pengguna bila artikelnya dipublikasi ulang/dikoreksi. Alasan ditolak: mempertahankan rumus yang diketahui salah.
- Pv NDVI Threshold memakai NDVImin 0,2 dan NDVImax 0,5 tetap (definisi metode); Tahap A MODIS bawaan 0,2/0,5. Suku kekasaran C hanya Tang, hanya di piksel campuran, C = (1-es)(1-Pv)F*ev dengan F = 0,55 (Tang Pers. 7; di Landsat dipakai Fev = 0,55 sebagai satu simbol, selisih sekitar 1e-4).
- Pers. 14/15 artikel menulis LSE10/LSE11 (sisa Landsat); dipakai e31/e32. Pers. 13 artikel salah ketik "(a4+a5W)/(1-e)"; dipakai (a4+a5W)(1-e) dari Sobrino 2003.
- Terbuka: reflektansi TOA vs permukaan untuk rumus Tang/Sobrino; konstanta air/salju Tang belum ada; MCM lain (Qin, Mao, Becker-Li, Wan-Dozier, Coll) belum dibangun.

## v105: MCM Qin et al. di MODIS LST

- Permintaan: MCM ke-2 = Qin, sesuai artikel rujukan dan Qin 2001 (sudah diunggah sebelumnya); identifikasi input; luaran satu raster LST Qin.
- Keputusan: input = BT31, BT32, e31, e32 (per band, bukan mean/delta seperti Sobrino), W (raster atau nilai). tau otomatis dari W lewat Mao et al. 2005 Pers. 8 (tanda eksponen diperiksa pada gambar halaman PDF Mao dan terhadap Tabel 2 Mao). L = B/(dB/dT) dalam Kelvin dari Planck pada c2/lambda, diregresikan terhadap BT sampel acak; tidak butuh radiance.
- Ditolak: mengikuti teks artikel 2026 apa adanya (C = e/tau, E0 tanpa minus, L = regresi radiance). Dasar: Qin 2001 Pers. 21, 32, 15, 20. Laporan regresi Excel seperti di Landsat tidak dibuat, karena pengguna meminta luaran hanya satu citra LST; koefisien regresi disimpan di tag GeoTIFF dan dilaporkan di GUI.
- Pemeriksaan: model maju Planck (Ta = Ts - 8 K) memulihkan Ts dalam 0.1 K untuk W 1 sampai 4; ini menguji aljabar dan L, bukan akurasi lapangan.
- Terbuka: artikel melaporkan MCM Qin kurang dari MOD11A2 sekitar 14 K; penyebab pada data artikel belum diketahui (kandidat: W, L, emisivitas, BT dari radiance L1B); belum diuji pada granule nyata. tau Mao hanya sahih pada rentang simulasi Mao. Satu rentang suhu regresi (tanpa opsi rentang ganda seperti Landsat). MCM lain (Mao, Becker-Li, Wan-Dozier, Coll) belum dibangun.
