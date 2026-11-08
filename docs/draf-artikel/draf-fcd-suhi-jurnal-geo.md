# Draf rancangan artikel: FCD dan SUHI untuk Jurnal Geo (Unimed)

Status: rancangan awal, belum naskah final. Disusun dari sudut pandang editor/reviewer.
Tanggal: 2026-11-08. Sumber lokal: tab FCD dan TEI di Landsat Processor (lihat docs/handoff).

## 0. Yang belum bisa dipastikan

- Aturan penulisan Geo (bahasa, panjang naskah, gaya sitasi, jumlah rujukan minimum) belum terbaca. Host jurnal.unimed.ac.id tidak bisa dijangkau dari sesi cloud ini. Hasil pencarian hanya memuat cakupan: geografi, ilmu geospasial, studi lingkungan, perencanaan sosio-spasial. [Medium confidence, dari ringkasan mesin pencari, bukan dari halaman aslinya]
- Peringkat SINTA Geo belum terkonfirmasi. Cek di sinta.kemdiktisaintek.go.id lewat ISSN sebelum menulis klaim apa pun di surat pengantar.
- Lokasi studi, tahun citra, dan jumlah scene belum ditetapkan. Seluruh bagian Metode di bawah memakai tanda [ISI].

## 1. Penilaian editor: kelemahan paling berat lebih dulu

1. **Risiko lingkaran logika (sirkularitas) bergantung pada versi FCD.** Model FCD mengenal empat indeks: AVI, BI, SI, dan TI. TI (Thermal Index) berasal dari kanal termal, sumber yang sama dengan LST. Rumus inti yang paling sering dikutip, FCD = sqrt(VD x SSI + 1) - 1 dengan VD dari AVI dan BI serta SSI dari SI, tidak memuat TI secara langsung. Tetapi varian yang menurunkan SSI dari gabungan SI dan TI (PCA) memasukkan suhu ke dalam variabel bebas. Aplikasi ini sempat memakai varian itu di v131 dan sejak v132 bawaannya SSI = SI linear, jadi tanpa TI (pilihan lama si_ti masih ada). Artikel wajib: (a) menyatakan varian mana yang dipakai, (b) memastikan TI tidak masuk FCD utama, (c) bila varian dengan TI dilaporkan, menaruhnya hanya sebagai sensitivitas. Reviewer yang paham FCD akan memeriksa ini lebih dulu. [Medium confidence: varian dalam rumus bergantung sumber; sumber primer Rikimaru belum dibaca, rincian diambil dari ringkasan pencarian dan catatan handoff v131-v132]
2. **FCD dirancang untuk hutan, bukan kota.** Di piksel beton, atap, dan lahan terbuka, AVI/BI/SI bekerja di luar domain kalibrasinya. Artikel harus memilih: wilayah studi mencakup gradien kota ke hutan (FCD bermakna di ujung hutan) atau kota dengan ruang hijau (FCD dibaca sebagai proksi kerapatan tajuk, bukan inventori hutan). Tanpa pembatasan ini klaim "FCD menjelaskan SUHI" terlalu lebar.
3. **FCD belum tervalidasi.** Handoff mencatat VD, SSI, TI hanya garis besar di sumber, normalisasi per citra dan skala 0-100 adalah keputusan implementasi, Rikimaru 1996 belum dibaca, dan tidak ada data lapangan. Artikel yang mengandalkan FCD tanpa validasi tajuk akan dibaca sebagai analisis indeks tanpa dasar. Modul Tajuk dan LAI (v132) bisa jadi sumber validasi, tetapi baru diuji sintetis.
4. **Istilah SUHI longgar.** SUHII adalah selisih LST kawasan terbangun terhadap acuan non-terbangun (Peng dkk. 2012 memakai zona suburban/non-urban dari peta tutupan lahan). Regresi LST per piksel terhadap FCD adalah variasi termal intra-kota, bukan SUHII. Tentukan satu definisi dan konsisten.
5. **Satu citra Landsat pagi hari adalah potret sesaat.** Landsat melintas sekitar pagi menjelang siang waktu lokal, jadi yang diukur SUHI siang hari. Malam hari (di mana albedo dan cahaya malam lebih menentukan, menurut Peng dkk. 2012 dan Zhou dkk. 2014) tidak tercakup. Di tropis, awan membatasi jumlah citra. Satu tanggal tidak cukup untuk klaim umum.
6. **Faktor pengganggu.** Ketinggian (efek lapse suhu, di pegunungan mendominasi TI menurut catatan v131), fraksi lahan kedap air (menjelaskan sekitar 70 persen variansi LST di Imhoff dkk. 2010), kedekatan air, albedo. FCD tanpa kontrol ini hanya menangkap korelasi.
7. **Autokorelasi spasial.** Sel 30 m bertetangga sangat berkorelasi. OLS dengan ratusan ribu piksel menghasilkan p-value yang tak berarti.

Penilaian keseluruhan: ide layak, tetapi hanya bila kontribusinya dirumuskan sebagai uji, bukan klaim. Pertanyaan ilmiah yang jujur: apakah FCD tanpa TI menambah daya jelaskan terhadap LST setelah NDVI/FVC, fraksi kedap air, dan ketinggian dikontrol. Bila jawabannya tidak, itu tetap temuan yang bisa diterbitkan.

## 2. Usulan judul dan rumusan

Judul kerja (pilih satu, sesuaikan [ISI]):
- "Kerapatan Tajuk Hutan (FCD) dan Intensitas Pulau Panas Permukaan Kota [ISI]: Uji Ambang Pendinginan Menggunakan Landsat 8/9"
- "Apakah" tidak dipakai di judul; gunakan bentuk pernyataan seperti di atas.

Tujuan:
1. Memetakan FCD (varian tanpa TI) dan LST [ISI wilayah, tahun].
2. Menghitung SUHII dengan definisi acuan yang dinyatakan jelas.
3. Menguji hubungan FCD dengan LST/SUHII, termasuk bentuk non-linear dan ambang (mengikuti pendekatan Jung dkk. 2021).
4. Menguji tambahan daya jelaskan FCD di atas NDVI/FVC setelah kontrol kedap air dan ketinggian.

Hipotesis:
- H1: LST menurun seiring FCD; penurunan tidak linear, melandai di atas ambang tertentu.
- H2: Efek pendinginan FCD lebih besar pada zona berkedap air tinggi.
- H3: FCD tanpa TI menambah R2 terpartial secara bermakna di atas NDVI. (Dapat ditolak.)

## 3. Desain analisis

### 3.1 Data
- Landsat 8/9 Collection 2, tanggal bebas awan [ISI], musim kemarau agar kontras vegetasi-lahan terbuka tidak tercampur efek hujan. Minimal 3 tanggal bila awan mengizinkan, supaya hasil tidak bergantung satu hari.
- Produk suhu permukaan Level-2 (ST_B10) tersedia sebagai pembanding terhadap LST hasil kalibrasi atmosfer sendiri. Dokumentasi katalog Earth Engine menyebut algoritma single-channel RIT/NASA JPL dan emisivitas dari ASTER GED; USGS merujuk Cook dkk. (2014) untuk galat dekat awan. Angka akurasi ST_B10 tidak ditemukan di hasil pencarian, ambil dari Science Product Guide USGS. [Medium confidence]
- DEM (SRTM/DEMNAS) untuk ketinggian, kemiringan, dan koreksi lapse.
- Peta tutupan lahan atau hasil klasifikasi sendiri untuk batas terbangun, acuan non-terbangun, dan air.
- Kedap air: NDBI/BSI atau klasifikasi, pilih satu dan nyatakan.

### 3.2 Pra-pemrosesan
- Masking awan dan bayangan awan, buffer di sekitarnya (galat LST dekat awan).
- Air dikeluarkan dari analisis (mengacaukan acuan).
- Resolusi seragam 30 m; LST termal diresampling dari 100 m sesuai produk resmi, cantumkan.

### 3.3 FCD
- Rumus inti: FCD = sqrt(VD x SSI + 1) - 1 (bentuk yang paling sering dikutip; sumber berbeda dalam detail AVI, jadi tulis versi yang dipakai dan alasannya).
- Varian A (utama): VD dari AVI dan BI, SSI = SI linear 0-100 (bawaan aplikasi v132), tanpa TI.
- Varian B (pembanding): SSI dari PCA SI+TI (opsi si_ti), hanya untuk uji sensitivitas; baca hasilnya dengan waspada karena memuat informasi suhu.
- Klasifikasi kelas FCD sesuai praktik sumber (cek batas kelas di sumber primer sebelum ditulis).
- Normalisasi per citra (opsi aplikasi v132) agar lintas tanggal dan sensor sebanding.

### 3.4 LST dan SUHI
- LST dari kalibrasi atmosfer aplikasi (SST/emisivitas sesuai catatan v135-v149), dibandingkan dengan ST_B10 pada sampel titik.
- SUHII = rerata LST zona terbangun - rerata LST zona acuan. Acuan: non-terbangun tanpa air, selisih ketinggian dibatasi [ISI m] (ambang ini keputusan desain peneliti, bukan hasil literatur; justifikasi dengan DEM).
- Sajikan juga LST ternormalisasi (anomali terhadap rerata kota) supaya antar tanggal sebanding.

### 3.5 Statistik
1. Statistik deskriptif LST per kelas FCD, uji Kruskal-Wallis atau ANOVA dengan pasca-uji.
2. Korelasi dan regresi pada titik sampel acak berstrata dengan jarak antar titik melebihi rentang semivariogram (mengurangi autokorelasi). Jumlah titik [ISI], minimal beberapa ratus.
3. Cek Moran's I residual. Bila signifikan, pakai model spasial (lag/error) dan/atau GWR.
4. Bentuk ambang: regresi bersegmen atau GAM; laporkan titik patah dengan selang kepercayaan.
5. Kontrol: ketinggian, kedap air, jarak ke air, albedo bila ada. Cek VIF.
6. Daya jelaskan tambahan: bandingkan model (NDVI saja) dengan (NDVI + FCD) lewat delta R2 dan AIC dengan validasi silang berblok spasial.
7. Sensitivitas: FCD varian A vs B, tiap tanggal terpisah, ukuran sampel berbeda.

### 3.6 Validasi FCD
- Titik lapangan atau interpretasi citra resolusi tinggi pada [ISI >= 30] titik: tutupan tajuk terhadap kelas FCD (matriks konfusi, akurasi keseluruhan, kappa).
- Foto tajuk dengan modul Tajuk dan LAI (fisheye bila ada), laporkan sebagai PAI, bukan LAI sejati; ambang Otsu dan Minimum memberi hasil berbeda cukup jauh (v132), tulis sensitivitasnya.

## 4. Kerangka naskah (IMRaD)

| Bagian | Isi | Panjang saran |
|---|---|---|
| Abstrak (ID dan EN) | latar 1 kalimat, tujuan, data, metode, 2-3 angka temuan, implikasi | 200-250 kata (cek aturan Geo) |
| Pendahuluan | SUHI sebagai masalah kota tropis; peran vegetasi/tajuk; celah: FCD jarang dipakai sebagai proksi pendinginan dan hampir tak ada uji ambang untuk konteks Indonesia [Low confidence, belum disurvei tuntas]; tujuan dan hipotesis | 4-5 paragraf |
| Tinjauan pustaka (bisa melebur ke pendahuluan) | SUHI dan penentu; hubungan tajuk-LST; FCD dan penerapannya di Indonesia | 1-2 halaman |
| Metode | wilayah studi (peta), data, FCD (varian A/B), LST, SUHII, statistik, validasi; semua keputusan implementasi diungkap | 2-3 halaman |
| Hasil | peta FCD dan LST; tabel per kelas; kurva ambang; model spasial; validasi FCD | 3-4 halaman |
| Pembahasan | bandingkan dengan Imhoff, Peng, Zhou, Jung, Clinton; efek TI pada varian B; batas FCD di kota; kebijakan RTH | 2 halaman |
| Kesimpulan | jawab tiap tujuan, keterbatasan, saran | 1-2 paragraf |

Gambar minimal: peta lokasi, peta FCD, peta LST/SUHII, kurva LST terhadap FCD dengan ambang, diagram alir metode. Gunakan menu Layout aplikasi (v121) untuk peta bergaya jurnal.

## 5. Peta literatur

Status verifikasi: seluruh entri di bawah hanya dikonfirmasi pada tingkat abstrak/catatan bibliografis lewat pencarian web hari ini. Tidak ada teks lengkap yang dibaca. Buka tiap makalah sebelum disitir; angka di kolom "Pesan" jangan disalin tanpa memeriksa isi aslinya.

| Rujukan | Pesan yang dipakai | Dipakai di |
|---|---|---|
| Rikimaru, A. dan Miyatake, S. (1997). Development of Forest Canopy Density Mapping and Monitoring Model using Indices of Vegetation, Bare soil and Shadow. Proc. ACRS 1997, FR97-5. https://acrs-aars.org/proceeding/ACRS1997/Papers/FR97-5.htm | dasar model FCD (judul lengkap dan daftar penulis perlu dicek di halaman asli) | Metode |
| Peng, S. dkk. (2012). Surface urban heat island across 419 global big cities. Environ. Sci. Technol. 46(2), 696-703. | definisi SUHII, siang vs malam, vegetasi menentukan siang | Pendahuluan, Metode |
| Imhoff, M.L., Zhang, P., Wolfe, R.E., Bounoua, L. (2010). Remote sensing of the urban heat island effect across biomes in the continental USA. Remote Sens. Environ. 114(3), 504-513. doi:10.1016/j.rse.2009.10.008 | kedap air menjelaskan sekitar 70 persen variansi LST; UHI beragam menurut bioma | Pembahasan |
| Xian, G. dan Crane, M. (2006). An analysis of urban thermal characteristics and associated land cover in Tampa Bay and Las Vegas using Landsat satellite data. Remote Sens. Environ. 104(2), 147-156. doi:10.1016/j.rse.2005.09.023 | Landsat, kedap air, tutupan vegetasi; kota kering bisa jadi heat sink | Pendahuluan |
| Clinton, N. dan Gong, P. (2013). MODIS detected surface urban heat islands and sinks: Global locations and controls. Remote Sens. Environ. 134, 294-304. doi:10.1016/j.rse.2013.03.008 | intensitas pembangunan, jumlah vegetasi, ukuran kota sebagai prediktor utama | Pembahasan |
| Zhou, D., Zhao, S., Liu, S., Zhang, L., Zhu, C. (2014). Surface urban heat island in China's 32 major cities: Spatial patterns and drivers. Remote Sens. Environ. 152, 51-61. doi:10.1016/j.rse.2014.05.017 | variasi musiman dan harian; siang terkait vegetasi | Pembahasan |
| Zhou, D. dkk. (2019). Satellite remote sensing of surface urban heat islands: Progress, challenges, and perspectives. Remote Sens. 11(1), 48. doi:10.3390/rs11010048 | tinjauan; Landsat dan MODIS sekitar 78 persen studi; keterbatasan metodologis | Pendahuluan, Metode |
| Jung, M.C., Dyson, K., Alberti, M. (2021). Urban Forestry & Urban Greening 57, 126930. doi:10.1016/j.ufug.2020.126930 (judul lengkap perlu dicek) | sel Landsat 30 m; efek tutupan tajuk non-linear dan bergantung tingkat pembangunan | Metode (ambang), Pembahasan |
| Cook, M. dkk. (2014), dirujuk oleh dokumentasi USGS | galat ST dekat awan (rujukan tidak dibaca langsung, cek dulu) | Metode (masking) |

Sumber FCD berbahasa Indonesia yang muncul di pencarian dan layak dibaca untuk konteks nasional (judul dan penulis belum terbaca): Majalah Geografi Indonesia UGM (artikel 15383, https://jurnal.ugm.ac.id/mgi/article/view/15383), Environment and Natural Resources Journal (https://ph02.tci-thaijo.org/index.php/ennrj/article/download/241847/165149), dokumentasi TROFMIS (https://trofmis-manual.readthedocs.io/en/latest/Background/Forest%20Canopy%20Density.html).

Celah literatur yang masih harus ditutup sebelum submit (target umum jurnal SINTA tinggi biasanya puluhan rujukan, cek aturan Geo):
- Studi FCD atau kerapatan tajuk terhadap LST di kota tropis Indonesia dan Asia Tenggara (hasil pencarian umum hanya menemukan studi tutupan tajuk/NDVI, belum satu pun yang memakai FCD secara eksplisit untuk SUHI).
- Studi SUHI Indonesia (Jakarta, Bandung, Medan, Denpasar, dll.) agar naskah tidak terlihat terputus dari literatur nasional. Cari di Sinta/Garuda dan Majalah Geografi Indonesia.
- Metode LST Landsat 8/9 (single-channel, split-window tak berlaku untuk TIRS) dan validasi terhadap data in situ.
- Metode statistik spasial (SAR/GWR) untuk LST.

## 6. Yang perlu dari penulis

1. Wilayah studi dan alasannya (kota, gradien kota-hutan, atau zona tertentu).
2. Tanggal citra yang sudah ada atau yang bisa diunduh, termasuk persentase awan.
3. Ada atau tidak data lapangan (foto tajuk, titik GPS, citra resolusi tinggi).
4. Pilihan bahasa naskah dan tenggat dari volume Geo yang disasar.
5. Izin jaringan untuk jurnal.unimed.ac.id agar template dan aturan bisa dibaca langsung, atau tempel teks Author Guidelines ke sesi berikutnya.

## 7. Kerangka abstrak (isi setelah angka ada)

Latar: Pulau panas permukaan (SUHI) memperburuk beban termal kota tropis, sementara kerapatan tajuk jarang diuji sebagai penjelas spasialnya.
Tujuan: Menguji hubungan kerapatan tajuk hutan (FCD) dengan suhu permukaan dan SUHII di [ISI].
Metode: Landsat 8/9 tanggal [ISI]; FCD tanpa indeks termal; LST kalibrasi atmosfer; regresi spasial dan analisis ambang dengan kontrol ketinggian serta kedap air.
Hasil: [ISI: koefisien, ambang FCD, delta R2, akurasi validasi FCD].
Simpulan: [ISI], dengan keterbatasan citra siang hari dan jumlah tanggal terbatas.
Kata kunci: forest canopy density, surface urban heat island, land surface temperature, Landsat, [ISI].
