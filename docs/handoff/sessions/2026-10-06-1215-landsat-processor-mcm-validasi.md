---
date: 2026-10-06 12:15
source: claude.ai
topic: Landsat Processor (PySide6), MCM Mao, menu Validasi, perbaikan plot 1 banding 1
status: berlanjut
---

# Landsat Processor: dari MCM Mao sampai Validasi (v32 sampai v34)

## Tujuan

Aplikasi desktop PySide6 (Windows-first) untuk pengolahan Landsat, kode di `/home/claude/landsat_processor` pada workspace sesi claude.ai, BUKAN di repo ini. Menu: Pra-pemrosesan, Pengolahan Utama (Vegetation Index, Emissivity, LST, LST-SCM, LST-MCM), Landsat Level 2, dan Validasi.

Pekerjaan pada jendela sesi ini:
1. MCM Mao et al. (2005) sebagai tab ketiga MCM (Persamaan 33-41, Nugraha et al. 2024). Input dan sampling sama dengan Qin, laporan regresi Excel terpisah. Hasil: v32.
2. Menu "Validasi" sejajar Pengolahan Utama. Mode A: Excel ground truth (data lapangan + nilai citra). Mode B: dua raster (hasil olahan vs data pihak ketiga, misalnya USGS Level 2). Sampel acak otomatis mengikuti luasan penelitian, mekanisme sama dengan MCM. Keluaran Excel: statistik, data sampel, dan diagram 1 banding 1 yang bisa diedit (chart native, bukan gambar). Hasil: v33.
3. Qin dan Mao: diagram regresi di Excel juga diganti chart native.
4. Perbaikan plot 1 banding 1 yang tampil jelek (tanpa angka sumbu, garis tidak diagonal, titik tak terlihat). Hasil: v34, 198 tes lulus.

Batasan tetap dari pengguna: jangan mengarang rumus, angka, atau sumber; jangan paksa NaN atau nilai negatif jadi nol; beri label keyakinan pada klaim tak pasti; sikap kritis berbasis bukti; gaya tulisan Indonesia sesuai preferensi tersimpan (tanpa em dash, tanpa kalimat tanya).

## Keputusan dan alasannya

- **Mao meniru struktur Qin.** Regresi BT vs radiance (a10, b10, a11, b11) identik dengan Qin lewat `sample_and_regress_bt_radiance`; yang beda hanya turunan Ts (Persamaan 33-41 lawan 21-32). Modul laporan regresi dibuat generik (`bt_radiance_regression_report.py`) supaya tidak digandakan.
- **Variabel C10/C11/A10/A11 Mao bukan C10/C11 Qin.** Nama sama, definisi beda (Persamaan 34-37 lawan 22-23). Penyebut `C11*A10 - C10*A11` bisa nol, hasilnya NaN dan dihitung di diagnostik `n_denom_degenerate_pixels`.
- **Sampling tidak diubah** atas permintaan pengguna.
- **Sumbu plot: X = referensi/observasi/ground truth, Y = prediksi/hasil olahan.** Dasar: Correndo et al. 2021 (Agricultural Systems 192:103194, paket metrica), MATLAB modelAccuracyPlot, konvensi keterangan gambar jurnal. [Confidence sedang-tinggi]
- **Skala X dan Y sama persis (min/max identik, margin 5%)** supaya garis identitas benar-benar 45 derajat dan posisi titik di atas atau bawah garis terbaca benar (Wikipedia "Identity line"). Permintaan eksplisit pengguna.
- **Chart native openpyxl, bukan PNG matplotlib.** Pengguna ingin diagram bisa diedit di Excel.
- **Statistik:** R2 (Pearson r dikuadratkan), r, RMSE, MAE, MBE (rata-rata Y minus X). Pengguna menulis "MEE"; diasumsikan MBE. [Confidence rendah]
- **Validasi tidak melakukan resampling** antar raster; piksel valid hanya yang finite di kedua raster.
- **Koordinat sampel ditulis di CRS asli raster**, bukan dikonversi ke lon/lat, karena pyproj tidak tersedia untuk verifikasi.
- **SCM Jimenez-Munoz & Sobrino LST rendah:** penyebab ketidakcocokan tanggal ST_DRAD/URAD Level 2 dan sensitivitas ekstrem terhadap Lu, bukan bug kode. Ld/Lu memakai rata-rata skalar secara sengaja.
- **MCM Skokovic > MCM Qin:** sesuai Tabel 9 paper rujukan, jadi dianggap wajar. Pengguna memilih melewatkan penyelidikan lebih lanjut.

## Yang ditolak atau gagal

- Chart gambar PNG (matplotlib) untuk regresi dan validasi: ditolak pengguna, harus editable.
- Skala sumbu otomatis terpisah X/Y: membuat plot 1 banding 1 tidak 1 banding 1.
- Bug openpyxl yang sudah dibereskan: `axPos` default "l" untuk kedua sumbu (set X "b"); Reference xVal dan yVal beda rentang baris (harus sama, tanpa header); XYSeries memakai `.yVal` bukan `.val`; marker tanpa warna eksplisit transparan di LibreOffice.
- Nama sheet "Diagram Validasi 1:1" ditolak Excel (":" terlarang), diganti "Diagram Validasi 1 banding 1".
- `core/validation.py` sempat SyntaxError karena `from __future__` setelah konstanta string; impor dipindah ke atas.
- Zip v32 sempat 264 MB karena scratch tes `tests/_region_mask_target_crs_test` ikut terbungkus; scratch dihapus sebelum zip (sekarang sekitar 390 KB).
- Konversi koordinat ke lon/lat: ditunda, tidak ada pyproj.

## Hasil nyata

- Zip: `/home/claude/landsat_processor_v32.zip`, `_v33.zip`, `_v34.zip` (terbaru, sekitar 390 KB), di workspace sesi claude.ai. Dikecualikan dari zip: `core/six_s_correction.py` dan `bin/*`.
- 198 tes pytest lulus (80 di `tests/test_lst.py` termasuk 11 Mao; 20 di `tests/test_validation.py` termasuk 3 tes regresi bug chart). Smoke test GUI headless untuk Mao dan Validasi lulus.
- Berkas baru: `core/validation.py`, `core/validation_report.py`, `gui/validation_page.py`. Berkas diubah: `core/lst.py` (`mcm_mao`, `LSTJob.compute_mcm_mao`), `core/bt_radiance_regression_report.py`, `gui/lst_mcm_page.py`, `gui/main_window.py` (kategori "Validasi" setelah "Landsat Level 2"), `README.md`.
- Keluaran Mao: `<nama>_LST_MCM_MAO.tif` dan `<nama>_LST_MCM_MAO_regresi.xlsx`.
- Render diagram diperiksa lewat xlsx -> PDF (LibreOffice) -> PNG; titik, angka sumbu, dan diagonal tampak benar.

## Belum terverifikasi

- Arti "MEE" menurut pengguna (diasumsikan MBE). Perlu konfirmasi.
- Tampilan chart di Microsoft Excel asli; baru dicek di LibreOffice.
- Akurasi LST tiap metode terhadap data lapangan nyata; belum ada validasi lapangan.
- Ketergantungan akurasi pada data Landsat 8/9 spesifik.
- Jumlah sampel regresi (n) bukan angka baku literatur; murni parameter pengguna.

## Verifikasi di Claude Code (2026-10-06, dari zip v34 yang diunggah)

Zip diekstrak ke direktori bersih, dependensi dipasang (numpy 2.5.3, rasterio, openpyxl 3.1.5, PySide6, dll).

Terkonfirmasi:
- Seluruh `main.py`, `core/*.py`, `gui/*.py` lolos kompilasi. Tidak ada SyntaxError di `core/validation.py`.
- Berkas baru ada: `core/validation.py`, `core/validation_report.py`, `gui/validation_page.py`. Kategori "Validasi" terdaftar di `gui/main_window.py` setelah Landsat Level 2.
- `core/six_s_correction.py` dan `bin/*` memang tidak ikut zip.
- Jumlah definisi tes 198 (80 di `test_lst.py`, 20 di `test_validation.py`), cocok dengan entri.
- Kode chart: `axPos` sumbu X "b", skala min/max X dan Y identik, marker berwarna eksplisit, nama sheet "Diagram Validasi 1 banding 1". Cocok dengan keputusan di atas.
- Statistik MBE ada di kode dan docstring-nya mencatat tebakan "MEE" sebagai [Confidence rendah].

Koreksi atas entri:
- **"198 tes lulus" tidak reproduksibel di luar workspace asal.** Hasil rerun: 197 lulus, 1 gagal (`tests/test_region_masking.py::test_apply_with_target_crs_reprojection`). Penyebabnya path hardcoded `/home/claude/qa_pixel_check/...` dan `/home/claude/shp_check/...` di lima berkas tes yang membaca data nyata (QA_PIXEL dan shapefile Karangasem tidak ada di zip). Itu masalah ketergantungan data, bukan bug logika, tetapi belum dibuktikan karena data aslinya tidak tersedia di sini.
- Tes lain yang memakai data nyata (`test_cloud_mask_real_data.py`, `test_region_masking_real_shapefile.py`, `test_cloud_masking_output_into_region_masking.py`, `test_full_pipeline.py`) terkumpul nol fungsi `test_` di tingkat modul. Mereka tampaknya berupa skrip, bukan tes pytest, sehingga tidak ikut hitungan 198. Perlu dicek.

Belum diverifikasi di sesi ini:
- Render chart di Excel asli (di sini juga tidak ada Excel atau LibreOffice yang saya jalankan).
- Kebenaran rumus Mao dan sumber paper (Nugraha et al. 2024, Correndo et al. 2021). Saya tidak memeriksa sumbernya. This needs verification.
- Smoke test GUI headless Mao dan Validasi belum saya ulang.
- Kode aplikasi masih hanya ada di zip unggahan, belum di repo manapun.

## Berkas pendukung yang diunggah (analisis di Claude Code)

PDF dan xlsx asli tidak dimasukkan ke repo (PDF berhak cipta penerbit). Hanya catatan ini yang disimpan.

**Publikasi rujukan** (hanya halaman 1-2 tiap PDF yang saya baca; isi persamaan belum saya cocokkan dengan kode):
1. Nugraha, Kamal, Murti, Widyatmanti (2023), "Development of the triangle method for drought studies based on remote sensing images: A review", Remote Sensing Applications: Society and Environment 29:100920. Tinjauan metode segitiga Ts/VI dan TVDI. Latar teori kekeringan, bukan sumber rumus LST aplikasi.
2. Nugraha dkk. (2024), "Accuracy assessment of land surface temperature retrievals from remote sensing imagery: pixel-based, single and multi-channel methods", Geomatics, Natural Hazards and Risk 15(1):2324975. Membandingkan SCM dan MCM (Skokovic, Qin, Mao) dengan CBEM/NBEM. Dugaan kuat sumber "Nugraha et al. (2024)" untuk MCM di README, tetapi nomor persamaan 18-20 dan 21-41 belum dicocokkan. This needs verification.
3. Nugraha dkk. (2024), "Comparison of Lambertian Model on Multi-Channel Algorithm for Estimating Land Surface Temperature...", Korean Journal of Remote Sensing 40(4):397-418. Koreksi topografi (SCS dan Cosine) pada MCM. Relevan untuk `core/topographic_correction.py`.

Catatan: Correndo et al. 2021 (dasar konvensi sumbu plot) tidak termasuk berkas yang diunggah, jadi sitasinya masih belum diperiksa.

**`validasi_perbandingan_raster.xlsx`** (LST Qin sebagai X, LST Skokovic sebagai Y, scene LC08 116/66, 3 Okt 2025, UTM 50N):
- Statistik di sheet ringkasan direproduksi persis dari sheet Data Sampel (n=2500): R2 0,98879, RMSE 4,0719 K, MAE = MBE = 3,7753 K.
- MAE sama dengan MBE karena Y lebih besar dari X di seluruh 2500 titik (selisih 1,28 sampai 11,03 K). Regresi Y atas X berslope 1,389, intersep -113,9. Jadi R2 tinggi menyembunyikan bias sistematik yang membesar pada suhu tinggi; R2 tidak peka terhadap slope dan bias. Sebaiknya laporan menyertakan slope dan intersep.
- Qin dipakai sebagai "referensi", padahal itu hasil model, bukan observasi. Statistik di sini mengukur ketidaksepakatan dua metode, bukan akurasi. Selaras dengan catatan di entri bahwa belum ada validasi lapangan.
- Chart native valid: sumbu X "b", Y "l", min 288 dan max 326 sama untuk kedua sumbu. Tampilan visual di Excel belum dilihat.
- Header kolom koordinat berisi seluruh teks WKT proyeksi (ratusan karakter), membuat tabel sulit dibaca. Usul: header pendek (mis. "X (UTM 50N, m)") dan WKT di sheet ringkasan.

**`..._MCM_QIN_regresi.xlsx`** (B10 dan B11, n=2500 dari 860.860 piksel valid):
- Regresi direproduksi persis: B10 a=-33,7437 b=0,14448 R2=0,99959 RMSE=0,00923; B11 a=-27,1248 b=0,12021 R2=0,99982 RMSE=0,00354.
- Berkas ini memakai **gambar PNG matplotlib**, bukan chart native. Jadi dihasilkan versi lama (sebelum v33). Kode v34 sudah memakai ScatterChart native, jadi contoh ini perlu dibuat ulang dengan v34 sebelum dipakai sebagai acuan tampilan.

**Publikasi ke-4:** Nugraha, Kamal, Murti, Widyatmanti (2026), "Comparison of Land Surface Temperature Retrieval using Remote Sensing Imagery: Classification-Based versus Normalized Difference Vegetation Index-Based Emissivity Methods", Remote Sensing in Earth Systems Sciences 9:18, doi 10.1007/s41976-025-00268-7 (25 halaman, saya baca hlm 1-16).
- Data **MODIS Terra** (MOD021KM band 31/32, MOD11A2 sebagai pembanding, MOD05_L2 uap air, MCD12Q1 tutupan lahan), Jawa Timur, Agustus-November 2023. Bukan Landsat.
- Membandingkan SCM Artis & Carnahan dan enam MCM (Sobrino, Qin, Mao, Becker & Li, Wan & Dozier, Coll) dengan emisivitas CBEM dan NBEM (GO, VC, THM/Sob/Tang).
- Hasil kunci menurut abstrak: MCM-Qin menghasilkan LST terlalu rendah (galat sekitar 14 K), MCM Wan & Dozier paling dekat ke MOD11A2 (galat sekitar 2 K), SCM-AC galat rata-rata di atas 7 K. Ini hasil MODIS, tidak otomatis berlaku untuk Landsat.
- Persamaan MCM ada di Eq. 13 (Sobrino), 16-25 (Qin), 26-36 (Mao, dengan konstanta khusus MODIS 0,13787 dan 31,65677 untuk band 31), 37 (Becker & Li, Tabel 5), 38 (Wan & Dozier, Tabel 6), 39-41 (Coll, Tabel 7). Piksel validasi memakai plot 1 banding 1 terhadap MOD11A2, mirip menu Validasi aplikasi.
- Metode uap air: rasio radiance band 17-19, W = f17 W17 + f18 W18 + f19 W19 (Eq. 6-10). Itu khusus MODIS; Landsat tidak punya band uap air setara, jadi aplikasi harus mengambil w dari sumber lain.

**Perlu dicek terhadap `core/lst.py`:** teks paper pada Eq. 17-18 (Qin) tampak ditulis C = epsilon / tau, sedangkan kode memakai C = epsilon * tau (bentuk Qin et al. 2001). Pembacaan saya atas gambar halaman bisa keliru, atau itu salah ketik di paper. This needs verification terhadap PDF sumber dan Qin et al. 2001 sebelum kode diubah. Kode tidak saya ubah.

Belum ada metode MCM Sobrino (Eq. 13), Becker & Li, Wan & Dozier, dan Coll di aplikasi, hanya Skokovic, Qin, Mao. Ketiga yang lain adalah kandidat perluasan, tetapi koefisiennya di paper dikhususkan untuk MODIS, sehingga untuk Landsat 8/9 perlu sumber koefisien TIRS yang bisa diverifikasi.

## Pencocokan rumus kode terhadap paper (2026-10-06)

Sumber: Nugraha dkk. (2024), Geomatics, Natural Hazards and Risk 15(1):2324975, halaman 8-12 (Eq. 11-41), dibandingkan baris demi baris dengan `core/lst.py` v34 dan komentar nomor persamaan di kodenya. Penomoran persamaan di kode terbukti mengikuti paper ini, jadi "Nugraha et al. (2024)" di README adalah paper ini.

**Cocok (tanpa selisih):**
- **MCM Mao, Eq. 33-41:** Ts = Tb10 + B1(Tb10-Tb11) + B0 (33); C10, C11 = (1-tau)(1+(1-eps)tau) (34, 35); A10, A11 = eps*tau (36, 37); B1 = C10/(C11 A10 - C10 A11) (38); L = a + b*Tb (39, 40); B0 = [C11(1-A10-C10)L10 - C10(1-A11-C11)L11]/(C11 A10 - C10 A11) (41). Semua suku, tanda, dan penyebut sama dengan `mcm_mao`.
- **MCM Qin, Eq. 21-32:** C = eps*tau (22, 23); D (24, 25); E0 = D11 C10 - D10 C11 (26); E1, E2 (27, 28); A = D10/E0 (29); A0, A1, A2 (30-32); Ts = A0 + A1 Tb10 - A2 Tb11 (21). Sama dengan `mcm_qin`.
- **MCM Skokovic, Eq. 18-20 dan Tabel 4:** koefisien C0 -0,268, C1 1,378, C2 0,183, C3 54,300, C4 -2,238, C5 -129,200, C6 16,400 sama persis dengan `MCM_SKOKOVIC_COEFFICIENTS`; bentuk rumus (18) sama; Mean LSE dan Delta LSE (19, 20) sama dengan `core/emissivity.py`.
- **Tb, Eq. 16:** K2 / ln(K1/L + 1) sama dengan kode.

**Catatan penting:**
- Keraguan sebelumnya soal C = epsilon/tau di paper MODIS 2026 (Eq. 17-18) **tidak berlaku untuk kode**: paper 2024 yang menjadi sumber kode menulis C = eps*tau, sama dengan kode. Selisih itu ada antar-paper (kemungkinan salah baca gambar atau salah ketik di paper 2026), bukan di kode. Belum diperiksa terhadap Qin et al. (2001b) asli, yang tidak diunggah.
- Paper 2024 menyebut tau10/tau11 memakai profil "mid-latitude summer" dan mengutip Rozenstein dkk. (2014) tanpa menuliskan koefisiennya di halaman yang saya baca. Koefisien tau di kode (dari README) **belum dicocokkan dengan sumber manapun** karena sumber primernya (Rozenstein 2014) tidak ada di berkas. This needs verification.
- Konstanta SCM (Eq. 11-15) belum dicocokkan, hanya Eq. 16 dari bagian itu.
- Pencocokan ini membuktikan kode sama dengan paper, bukan bahwa paper benar. Hasil Qin/Mao/Skokovic yang saling berbeda beberapa Kelvin (lihat catatan validasi di atas) tetap tidak diselesaikan oleh pencocokan ini.

## Pencocokan terhadap Rozenstein dkk. (2014), PDF asli (2026-10-06)

Sumber: Sensors 14(4):5768-5780, PDF diunggah pengguna, halaman 1-8 dibaca (Eq. 1-10, Tabel 1-2, bagian sensitivitas). Dibandingkan dengan `core/lst.py`.

**Cocok:**
- Tabel 2 (transmitansi): 1976 US Standard tau10 = -0,1146w + 1,0286, tau11 = -0,1568w + 1,0083; Mid-Latitude Summer tau10 = -0,1134w + 1,0335, tau11 = -0,1546w + 1,0078 (rentang w 0,5-3 g/cm2). `ROZENSTEIN_TAU_COEFFICIENTS` memuat angka yang sama untuk kedua profil, tanda dan intersep benar.
- Eq. 3-10: Ts = A0 + A1 T10 - A2 T11; A0 = E1 a10 + E2 a11, A1 = 1 + A + E1 b10, A2 = A + E2 b11; C = eps*tau; D = (1-tau)(1+(1-eps)tau); A = D10/E0; E1, E2, E0. Sama dengan `mcm_qin`.

**Temuan, perlu diputuskan (belum diubah di kode):**
- Di Rozenstein, a_i dan b_i adalah koefisien regresi **L_i = B_i(T) / (dB_i/dT)** (Eq. 1-2), satuan Kelvin. Contoh: L10 = -64,4661 + 0,4398 T; L11 = -68,8678 + 0,4755 T (0-60 C); Tabel 1 memberi varian per rentang suhu (0-30, 0-40, 10-40, 10-50 C). Rozenstein menyarankan memilih koefisien sesuai rentang suhu citra.
- Aplikasi memakai regresi **radiance vs BT** (contoh: a10 = -33,74, b10 = 0,1445). Itu besaran lain (radiance dalam W/m2/sr/um, bukan L_i dalam Kelvin). Paper Nugraha 2024 (Eq. 30-32, 39-40) hanya menulis "regression coefficients between temperature and radiance", jadi ambigu; untuk Qin, definisi Rozenstein yang eksplisit adalah L_i.
- Uji satu piksel sintetis buatan saya (Tb10 300,0 K, Tb11 298,7 K, eps 0,975/0,978, w 1,5): Qin dengan koefisien aplikasi 301,23 K, dengan koefisien L_i Rozenstein 300,91 K; Mao 302,40 K lawan 303,87 K; Skokovic 303,34 K. Selisih Qin hanya 0,3 K di kasus ini, tetapi Mao 1,5 K. Satu piksel sintetis tidak mewakili citra nyata; belum diuji pada raster. Perbedaan definisi ini **tidak menjelaskan** bias Skokovic > Qin sebesar 3,8 K di contoh validasi (arah bias sama, tetapi koefisien L_i membuat Qin sedikit lebih rendah, bukan lebih tinggi).
- Untuk Mao, persamaan 39-41 memakai L (radiance) langsung sehingga regresi radiance mungkin benar; saya belum memeriksa Mao et al. (2005) asli. This needs verification.

**Belum:** notifikasi koreksi Rozenstein 2014 (Sensors) tidak ada di PDF ini dan belum dibaca; Persamaan SCM (11-15) belum dicocokkan; Qin et al. (2001b) asli belum dibaca.

## Pencocokan persamaan SCM terhadap paper (2026-10-06)

Sumber: Nugraha dkk. (2024), Geomatics, Natural Hazards and Risk 15(1):2324975, hlm. 8-10 (Eq. 11-17), dibandingkan dengan `scm_jimenez_munoz_sobrino` dan `scm_artis_carnahan` di `core/lst.py`.

**Cocok:**
- **JM&S, Eq. 11-14:** Ts = gamma[(1/eps)(psi1 Lsen + psi2) + psi3] + delta; psi1 = 1/tau, psi2 = -Ld - Lu/tau, psi3 = Ld; gamma = Tsen^2/(b_gamma Lsen); delta = Tsen - Tsen^2/b_gamma; b_gamma 1320 K (B10) dan 1199 K (B11). Semuanya sama dengan kode. Konsistensi internal: c2/b_gamma = 14387,7/1320 = 10,90 um dan 14387,7/1199 = 12,00 um, wajar untuk pusat Band 10 dan 11.
- **Artis & Carnahan, Eq. 15:** Ts = Tb / [1 + (lambda Tb / rho) ln eps], rho = 1,438e-2 m.K. Sama dengan kode. Dari h*c/sigma yang ditulis paper didapat 1,4395e-2 (selisih 0,1% dari 1,438e-2; pembulatan paper, kode memakai angka literal paper).
- **Eq. 16 (Tb)** sama dengan kode.
- **Hitung ulang manual:** nilai JM&S dan AC dari fungsi kode sama dengan hitungan tangan (291,4467 K dan 301,7364 K untuk Tb 300 K, eps 0,975, tau 0,8634, Ld 1,5, Lu 2,5, Lsen 9,6). Sanity: inversi langsung persamaan transfer radiasi memberi sekitar 291,3 K (memakai K1/K2 B10 dari ingatan saya, [Confidence sedang]; hanya pemeriksaan kewajaran, bukan bukti).

**Temuan:**
1. **Paper salah ketik di Eq. 17:** tertulis L = ML*Qcal*AL; seharusnya ML*Qcal + AL. Kode memakai `mult*dn + add` (benar, sesuai rumus USGS). Bukan masalah di kode.
2. **Nilai lambda efektif tidak tertulis di halaman yang saya baca.** Kode memakai titik tengah rentang spektral resmi (10,895 dan 12,005 um); paper tidak menyebut angka di bagian itu. Tidak bisa dibuktikan cocok atau tidak. This needs verification.
3. **Penyimpangan yang disengaja dari paper:** Ld dan Lu di paper berasal dari ACPC; aplikasi memakai rata-rata raster ST_DRAD dan ST_URAD (atas instruksi pengguna). Satu skalar untuk seluruh scene dan untuk kedua band.
4. **Risiko tanpa penjaga:** `raster_mean` tidak memeriksa kewajaran nilai. Menu L2 menerapkan faktor skala 0,001, jadi jika pengguna memasukkan raster ST_DRAD/ST_URAD mentah (belum diskalakan), Ld dan Lu menjadi 1000 kali lipat dan keluaran menjadi tidak masuk akal tanpa peringatan (uji: Ld=1500, Lu=2500 menghasilkan -21052 K, lolos tanpa error). Usul: tolak atau beri peringatan bila rata-rata Ld/Lu di luar rentang fisik yang wajar (rentang itu perlu sumber yang bisa diverifikasi).
5. **Docstring usang di `core/lst.py`:** docstring modul menyebut fungsi `raster_mean_from_l2_product` yang tidak ada (nama sebenarnya `raster_mean`); docstring `scm_jimenez_munoz_sobrino` masih mengatakan tidak ada konversi otomatis tau dari uap air, padahal `LSTJob` sudah mengkonversinya lewat `rozenstein_tau_from_water_vapor`. Hanya dokumentasi, belum diperbaiki.
6. **b_gamma:** paper memberi 1320 K untuk B10. Saya mengingat angka lain (1324 K) dari literatur Jimenez-Munoz 2014, tetapi tidak punya sumber di sesi ini, [Low confidence]; tidak dipakai untuk menyimpulkan apa pun. This needs verification terhadap sumber aslinya bila presisi penting.

Tiga persamaan MCM, Rozenstein, dan kedua SCM kini semuanya cocok dengan sumbernya, kecuali butir terbuka di atas dan di bagian Rozenstein (definisi a_i, b_i untuk Qin).

## Pencocokan terhadap Qin dkk. (2001b) dan Mao dkk. (2005), PDF asli (2026-10-06)

Dibaca: Qin dkk. (2001b), JGR 106(D19):22655-22670, hlm. 1-8 (Eq. 1-39, Tabel 3-4); Mao dkk. (2005), IJRS 26(15):3181-3204, hlm. 1-17 (Eq. 1-28). Qin, Karnieli, Berliner (2001) tentang **mono-window Landsat TM** diunggah tetapi belum dibaca (metode berbeda, bukan bagian dari persamaan MCM aplikasi); sisa halaman Qin 2001b (validasi) juga belum dibaca.

**Temuan 1 (serius): tanda suku E2*a11 pada A0.** Qin 2001b Eq. 29 dan 36a: B = E1 L4 - E2 L5, sehingga **A0 = E1*a4 - E2*a5** (minus). Rozenstein 2014 Eq. 4a, Nugraha 2024 Eq. 30, dan `core/lst.py` (`mcm_qin`) menulis **A0 = E1*a10 + E2*a11** (plus). Ekspansi di Qin 2001b Eq. 33-34 mendukung tanda minus. Uji round trip (`scripts/verify_mcm_roundtrip.py` di repo App_RS): model maju dibangun dari persamaan transfer radiasi yang diasumsikan paper (Eq. 21 Mao / Eq. 12 Qin) dengan Planck monokromatik, Ts diketahui, lalu rumus invers diuji memulihkan Ts. Hasil (galat K terhadap Ts benar, Ts 295-320 K): Qin dengan tanda plus **-3,3 K** (konsisten, bias dingin); Qin dengan tanda minus **+0,04 sampai +0,10 K**. Arah dan besar bias plus (sekitar -3,3 K) searah dengan contoh validasi pengguna (Qin lebih rendah dari Skokovic sekitar 3,8 K), tetapi itu belum membuktikan penyebabnya, hanya konsisten. Kode belum diubah.

**Temuan 2: definisi a_i, b_i untuk Qin.** Qin 2001b Eq. 15 dan 20: L_i = B_i(T)/[dB_i/dT] = a_i + b_i T_i (Kelvin). Tabel 3 memberi koefisien per rentang suhu (untuk AVHRR). Hitungan saya dengan Planck monokromatik pada 10,895/12,005 um menghasilkan L10 = -64,55 + 0,4402 T dan L11 = -69,11 + 0,4767 T (0-60 C), dekat dengan angka Rozenstein 2014 untuk TIRS (-64,4661/0,4398 dan -68,8678/0,4755), jadi model Planck saya konsisten dengan paper. Memakai koefisien regresi radiance untuk Qin (seperti aplikasi) hampir tidak mengubah galat di uji ini (-3,1 sampai -3,3 K dengan plus), jadi tanda adalah masalah utama; definisi a_i,b_i tetap salah konsep untuk Qin dan sebaiknya mengikuti L_i.

**Temuan 3: Mao.** Mao 2005 memakai **linearisasi radiance** B_i = a_i + b_i T (Eq. 2-3; B31 = 0,13787 T - 31,65677, B32 = 0,11849 T - 26,50036), jadi regresi radiance vs BT di aplikasi **benar untuk Mao** (koreksi atas kekhawatiran di bagian Rozenstein untuk metode ini). Solusi eksak Mao ada di **Eq. 25**: Ts = [C32(B31+D31) - C31(D32+B32)] / (C32 A31 - C31 A32), dengan A = b*eps*tau, B = b*T + a(1 - eps*tau), C = D'*b, D = -D'*a, D' = (1-tau)(1+(1-eps)tau). Persamaan Nugraha 2024 Eq. 33-41 (dipakai `mcm_mao`: Ts = Tb10 + B1(Tb10-Tb11) + B0) **tidak ekuivalen secara aljabar** dengan Eq. 25 Mao. Uji round trip: Mao Eq. 25 galat -0,13 sampai +0,40 K (naik pelan terhadap suhu karena linearisasi tunggal 0-60 C); `mcm_mao` aplikasi **-1,7 sampai -1,9 K**. Eq. 26 Mao (bentuk Ts = T31 + A(T31-T32) + B) tertulis tetapi definisi A dan B-nya tidak ada di halaman yang saya baca.

**Persamaan lain di Mao 2005 yang terbaca:** tau MODIS Eq. 8a-8b (eksponensial, spesifik MODIS), emisivitas campuran Eq. 9-16 (Rv = 0,9332 + 0,0585 Pv, Rs = 0,9902 + 0,1068 Pv, NDVIv 0,65 dan NDVIs 0,05), semuanya khusus MODIS dan belum dibandingkan dengan `core/emissivity.py`.

**Batas pembuktian:** uji round trip hanya membuktikan konsistensi aljabar terhadap model maju yang diasumsikan paper sendiri (Planck monokromatik, atmosfer satu lapis, Ta = suhu efektif); itu bukan validasi dengan data nyata atau radiative transfer penuh. Galat absolut dalam skenario nyata bisa berbeda. Skokovic/Sobrino tidak diuji dengan cara ini.

**Usulan perbaikan (belum dilakukan, menunggu persetujuan):** (a) `mcm_qin`: A0 = E1*a10 - E2*a11 dan koefisien L_i (Kelvin) dengan pilihan rentang suhu; (b) `mcm_mao`: implementasi Eq. 25 Mao dengan fungsi linear generik; (c) tes pytest berbasis round trip; (d) tinjau ulang apakah tanda plus di Rozenstein/Nugraha adalah salah ketik di paper tersebut (periksa notifikasi koreksi Rozenstein 2014).

## Perbaikan diterapkan di repo App_RS (commit 5ae505c, 2026-10-06)

- `mcm_qin`: A0 = E1*a10 - E2*a11. Koefisien a_i,b_i kini L_i (Kelvin): `LSTJob.compute_mcm_qin(..., li_source="image")` meregresi L_i vs BT dari sampel citra (`sample_and_regress_bt_li`, Excel tetap dibuat), atau `li_source` = "0-60"/"0-30"/"0-40"/"10-40"/"10-50" memakai `ROZENSTEIN_LI_COEFFICIENTS` (Tabel 1 dan teks Rozenstein 2014, tanpa sampling dan tanpa Excel). Raster radiance tidak dipakai lagi untuk Qin (boleh None).
- `mcm_mao`: solusi eksak Mao 2005 Eq. 22-25; regresi radiance tetap. Deteksi piksel degenerate memakai faktor bebas-b karena `denom == 0` tidak andal di float32.
- Tes: `tests/test_mcm_roundtrip.py` baru (Qin dan Mao memulihkan Ts dalam 0,3-0,6 K; kontrol negatif tanda plus gagal di bawah -2,5 K) plus pembaruan dan penambahan tes di `tests/test_lst.py`. Hasil: 205 lulus, 1 gagal (tes yang bergantung data nyata `/home/claude/...`, sama seperti sebelumnya).
- GUI tab Qin: pilihan sumber koefisien L_i; validasi tidak lagi mewajibkan radiance. **Hanya `py_compile` yang dijalankan; GUI belum dijalankan** karena PySide6 tidak bisa dimuat di lingkungan ini (libEGL.so.1 tidak ada).
- Hasil Qin dan Mao yang dibuat sebelum perbaikan harus dihitung ulang.

## Langkah berikutnya

1. Kode aplikasi belum ada di repo manapun. Taruh `landsat_processor_v34.zip` ke repo (misalnya repo terpisah `landsat-processor`) supaya Claude Code bisa melanjutkan; dokumen ini tidak membawa kodenya.
2. Tanyakan arti "MEE" ke pengguna, sesuaikan kolom statistik bila perlu.
3. Buka `*_validasi.xlsx` dan `*_regresi.xlsx` di Excel asli, pastikan sumbu, garis diagonal, dan titik tampil benar.
4. Uji Validasi dengan data lapangan nyata dan raster Level 2 USGS.
5. Pertimbangkan konversi koordinat ke lon/lat bila pyproj tersedia dan bisa diverifikasi.
6. Sebelum tiap rilis: bersihkan cache dan scratch, zip tanpa `core/six_s_correction.py` dan `bin/*`, ekstrak ke direktori bersih, jalankan penuh pytest dan smoke test GUI headless.

## Koreksi lanjutan (2026-10-06, sesi sama, rilis v35)

Pengguna tidak jadi pindah ke Claude Code; pengembangan dilanjutkan di claude.ai. Setelah PDF asli Qin 2001b dan Mao 2005 dibaca, keputusan di atas dikoreksi:

- Keputusan "a/b diregresi sebagai radiance vs BT" SALAH untuk Qin dan Mao. Qin 2001b Pers. 15 dan 20 memakai L = B/(dB/dT) dalam Kelvin. Sekarang y = L dari BT dan K2 (isian K2 baru di GUI).
- Nugraha Pers. 30 (A0 plus) berbeda dari Qin 2001b Pers. 36a (minus). Kode memakai minus.
- Uji model maju Planck: Qin lama meleset 5 sampai 8 K, baru dalam 0.5 K. Mao lama meleset 2 sampai 3 K, baru dalam 0.5 K.
- Dengan koefisien L yang sama, Qin dan Mao kini identik secara numerik (selisih 0.000 pada data nyata). "Mao meniru Qin" kini terbukti, bukan hanya asumsi.
- Hasil: `landsat_processor_v35.zip`, 205 tes lulus. Detail di bagian README "Koreksi MCM Qin dan Mao terhadap sumber asli (v35)".
- Belum dilakukan: pemeriksaan terhadap artikel acuan lain yang akan diunggah pengguna; mono-window Qin 2001 (Karnieli) belum ada di aplikasi.

## Koreksi lanjutan 2 (rilis v36 dan v37)

- v36: Excel MCM Qin/Mao punya sheet "Diagram Parameter Li" (chart native ala Gambar 1b Qin, dua band, garis regresi Li = a + bT, tanpa pembagian rentang suhu).
- v37: Mao dipisah dua rumus. (1) Mao 2005 asli Pers. 25, koefisien radiance vs BT (Gambar 2 Mao), tanpa K2, bawaan. (2) Nugraha/Sekertekin Pers. 33-41, parameter L Kelvin, butuh K2, identik dengan Qin.
- Dasar: Sekertekin & Bonafoni 2020 Tabel 2 (L10 = 0.4464*T - 66.61) berdimensi Kelvin; `planck_L_parameter` mereproduksinya. Klaim pengguna bahwa L di rumus B1/B0 adalah regresi radiance tidak didukung makalah itu.
- Data nyata: Mao asli minus Qin = -0.05 C (sd 0.02). 208 tes lulus.

## Koreksi lanjutan 3 (rilis v38)

- Pengguna meminta rentang suhu pada hasil Qin dan Mao: tabel per rentang dan diagram editable, tunggal maupun gabungan, bisa memilih range tunggal atau banyak.
- Keputusan: rentang hanya memengaruhi Excel ("Tabel Range", "Diagram Range B10/B11"); LST tetap satu regresi seluruh sampel. Alasan: pengguna sebelumnya menyatakan tidak perlu rentang untuk perhitungan LST, dan Qin sendiri menyebut Tabel 2/3 sebagai contoh.
- Titik rentang = sampel citra, bukan grid Planck teoretis. Akibatnya rentang di luar suhu citra kosong dan ditandai, tidak dipaksakan.
- Tidak dibuat: REE, uji T/F (definisi REE belum diverifikasi), mode LST piecewise per rentang (belum diminta).
- 211 tes lulus. Paket `landsat_processor_v38.zip`.

## Addendum lanjutan 4 (v39): menu Sistem Koordinat terpisah

- Permintaan: proyeksi UTM + zona di Region Masking "diam"/tidak berjalan; pengguna minta menu terpisah untuk identifikasi dan perubahan CRS (citra mentah maupun hasil olahan), tab Geografis/UTM dengan zona, lalu blok proyeksi di Region Masking dihapus.
- Dibuat `core/reprojection.py` (inspect_raster, suggest_utm, reproject_raster_file, reproject_files) dan `gui/reprojection_page.py`, terdaftar di Pra-pemrosesan. Blok "Proyeksi hasil" + `target_crs` dihapus dari Region Masking (page, job, region_mask).
- Keputusan: alasan memisah = Region Masking cukup memotong, perubahan CRS berlaku untuk semua jenis citra. Ditolak: tetap di Region Masking.
- Bug Windows TIDAK direproduksi di sandbox (1,5 detik). Dugaan: exception di slot Qt hilang di .exe tanpa konsol; PROJ_LIB bentrok (QGIS/PostgreSQL). Mitigasi di `main.py`: excepthook ke error_log.txt dan pin PROJ/GDAL data bawaan rasterio. Belum diuji di Windows.
- Catatan data: scene USGS selatan berlabel UTM 50N (northing negatif) itu sah; menu menandai dan bisa mengubah ke 50S.
- Tes: 216 lulus (tests/test_reprojection.py baru). Artefak: landsat_processor_v39.zip.

## Addendum lanjutan 5 (v40): Mao tanpa K2 dan menu Thermal Index

- Mao: opsi formulasi Nugraha dan isian K2 dihapus dari GUI (Mao = radiance vs BT, Pers. 25 asli). `mcm_mao` bentuk Nugraha tetap di core hanya untuk uji identitas dengan Qin. Alasan: pengguna ingin Mao berbeda tampilan dari Qin; sesuai diskusi sebelumnya bahwa Mao asli memakai radiance, bukan parameter L.
- Menu baru Thermal Index (core/thermal_index.py, gui/thermal_index_page.py): TVI, CWSI (Idso, Twet/Tdry manual, Twet/Tdry dari citra), TCI (multi-tahun atau persentil spasial), VHI, UTFVI. TVDI sengaja ditunda ke analisis lanjutan.
- Sumber yang benar-benar dibaca: NOAA VIIRS VHP (TCI, VHI, a=0.5), makalah UTFVI (kelas, penyebut Tmean), studi CWSI Idso (baris dasar VPD), dua dokumen Indonesia untuk TVI. Temuan: arah TVI tidak seragam (EVI/LST vs LST/EVI), jadi dibuat pilihan; kelas TVI 0-55-70-85-99 tidak diadopsi. CWSI mode citra adalah pendekatan sendiri, ditandai perlu verifikasi.
- Masukan indeks adalah raster olahan; perbedaan Landsat 7 vs 8/9 hanya di hulu (band termal, band NDVI, SLC-off).
- Belum divalidasi dengan data lapangan atau citra nyata; tes memakai raster sintetis.

## Addendum lanjutan 6 (v41): Advanced Analysis, TVDI

- Menu Pengolahan Utama > Advanced Analysis (tab; satu analisis per tahap). Tahap 1: TVDI (core/tvdi.py, core/tvdi_report.py, gui/tvdi_page.py).
- Acuan: Sandholt dkk. 2002 (dibaca penuh). Keputusan pengguna dijalankan: Ts_max wajib regresi tepi kering; Ts_min pilihan minimum LST atau garis basah regresi. Ditambah satu opsi dari makalah: rata-rata minimum per interval VI.
- Tepi kering: ekstrem LST per interval VI (baku 0.02), sisi menurun otomatis dari puncak tepi. Sepertiga tengah dibuang tidak ditiru (kriteria tidak dijabarkan).
- Temuan: tepi kering dari sampel acak tidak stabil (data nyata 860 ribu piksel: sd kemiringan b 4.8 pada 20 ribu sampel, 2.6 pada 100 ribu, 0.3 pada 300 ribu). Baku jadi 100 ribu; ada sheet Kestabilan (10 ulangan + referensi semua piksel). Dicatat sebagai keputusan, alasan: sampel kecil menangkap ekstrem lebih sedikit.
- Uji nyata memakai BT B10 sebagai pengganti LST (belum ada LST nyata di sandbox). Belum divalidasi terhadap kelembapan tanah. Kelas 5 tingkat = satu versi literatur.
- Artefak: landsat_processor_v41.zip. Berikutnya: analisis lanjutan lain satu per satu sesuai arahan pengguna.

## Addendum lanjutan 7 (v42): pemeriksaan TVDI dan perbaikan
- Pengguna melaporkan TVDI tinggi pada area NDVI tinggi dan suhu rendah (data Karangasem, LST MCM Qin). Hasil unggahan identik dengan kode; penyebab metodologis: sampel 5 ribu dan interval 0.005 (Ts_max terlalu rendah), serta Ts_min minimum mutlak dari piksel dingin di sekitar Gunung Agung (efek ketinggian).
- Keputusan: baku 300 ribu sampel dan Ts_min persentil 1; sheet Sensitivitas; opsi DEM (gamma 6.5 K/km, kasar, belum diuji pada DEM nyata); Mode Sederhana; panduan. Ditolak: memaksa satu pilihan Ts_min sebagai benar, karena tanpa data lapangan tidak ada dasar.
- TVDI relatif terhadap scene, bukan kelembapan absolut; wilayah dominan kering tidak otomatis menghasilkan TVDI tinggi. Artefak: landsat_processor_v42.zip.

## Addendum lanjutan 8 (v43): DEM beda grid dan Heat Island
- Penyebab error DEM TVDI: bukan salah proyeksi, melainkan label CRS (32750 vs 32650 dengan northing negatif) dan extent/ukuran berbeda. Perbaikan: align_to_reference otomatis ke grid LST; tes di tests/test_grid_align.py (galat 0 m pada bidang miring).
- Heat Island sebagai tab kedua Advanced Analysis: SUHI (raster LST, acuan cincin luas sama Peng 2012, jendela elevasi, profil, sensitivitas, Excel) dan UHI (stasiun suhu udara pengguna). Keputusan: UHI tidak diestimasi dari LST karena beda besaran fisik; kelas intensitas tidak diadopsi karena tidak ada dasar yang terverifikasi.
- Temuan uji: pada citra gunung (Karangasem) SUHII berubah -0.6 vs +10.6 K hanya oleh jendela elevasi; ditampilkan sebagai peringatan. Mask kota nyata belum ada. Artefak: landsat_processor_v43.zip.

## Addendum lanjutan 9 (v44): SUHI revisi
- Permintaan pengguna: NDBI, mask kota otomatis (bukan manual), ambang/arah ambang/air jangan manual, penjelasan cincin/raster acuan/jendela elevasi/pita jarak, DEM untuk wilayah studi, baca literatur pembanding.
- Keputusan: NDBI dimasukkan ke Vegetation Index (MNDWI sudah ada). Mask kota baku NDBI > 0 karena aturan Zha (NDVI <= 0) menghasilkan 0 kota di citra tropis bervegetasi lebat (NDVI rata-rata 0.72); Otsu ditawarkan tapi menghasilkan 31% (bukan kota). Ditolak: memaksa satu ambang sebagai benar; histogram dan luas menurut tiap aturan ditampilkan.
- Temuan: NDBI menandai tanah terbuka di lereng Gunung Agung sebagai kota; SUHII 7.3 K turun ke 2.2 K setelah wilayah studi dibatasi 300-500 m dengan DEM. Pilihan acuan juga menggeser hasil (1 sampai 5 K).
- Literatur dibaca: Chakraborty & Lee 2019, Schwarz dkk. 2011, ESA LST CCI (slide), ulasan NDBI, studi NDBI wilayah kering. Zha 2003 asli tidak terbaca. Artefak: landsat_processor_v44.zip.

## Addendum lanjutan 10 (v45): artikel Zha 2003 dan Granada 2022
- Pengguna mengunggah Zha dkk. 2003 (NDBI) dan Hidalgo-García & Arco-Díaz 2022 (SUHI Granada), meminta: apakah UHS dapat diterapkan, apakah alur aplikasi sama, tautan Peng 2012.
- Keputusan: UHS diterapkan (LST > mean + 2 sd, seluruh piksel valid) sebagai raster, statistik per zona, sheet Excel; filter median 5x5 Zha sebagai opsi. Ditolak: menyamakan acuan pedesaan dengan satu titik stasiun (tidak tersedia dari data penginderaan jauh, dan rentan terhadap elevasi); klaim kepercayaan 95% pada UHS (hanya sah untuk sebaran normal).
- Temuan: Pers. 8 artikel Granada membalik tanda NDBI; Tabel 3 SUHI tidak konsisten dengan Pers. 10 (rentang dan simpangan baku). Zha memakai DN mentah, sehingga aturan NDVI <= 0 kemungkinan tidak berlaku pada reflektansi terkoreksi atmosfer (inferensi, belum diuji; di Karangasem aturan Zha menghasilkan 0 kota).
- Tautan Peng 2012: https://doi.org/10.1021/es2030438 (Environ. Sci. Technol. 46(2):696-703). Crossref ditolak proxy (429), DOI diambil dari portal ip-paris. Artefak: landsat_processor_v45.zip.

## Addendum lanjutan 11 (v46): UHI berbasis LST, stasiun opsional
- Permintaan: SUHI dianggap sesuai (perbaikan ditunda). UHI harus dari data penginderaan jauh; stasiun opsional; lacak rumus ke sumber asli (artikel Nugraha & Atmaja 2020); Excel; putuskan peran elevasi.
- Keputusan: modul baru core/uhi_rs.py + core/uhi_rs_report.py, tab "UHI (dari LST)". UHI = anomali LST terhadap statistik wilayah studi (T > mu + 0.5 sd, intensitas, Tr relatif, 5 kelas mean-SD, UHS mu + 2 sd). Stasiun dijadikan sheet penguat opsional dan tidak mengubah zona UHI (diuji). Elevasi opsional: batas wilayah studi dan koreksi regresi LST-elevasi.
- Ditolak: menganggap rumus artikel sudah benar tanpa verifikasi. Ma 2010, Rajasekar & Weng 2009 (versi IJRS), Xu 2013, Tsou 2017 tidak dapat dibuka (paywall/diblokir; shell tidak boleh mengunduh); yang terbaca: abstrak Rajasekar & Weng versi ISPRS (Gaussian MODIS, bukan rumus itu), Remote Sens. 10:665, Sci. Rep. 2025. Status ditulis di sheet Literatur dan README.
- Temuan: ambang mu + 0.5 sd menandai ~31% piksel pada sebaran simetris apa pun (derau murni uji: 30.9%), jadi luas UHI mencerminkan bentuk sebaran; Karangasem: 25.5% UHI, 88% kota masuk UHI tetapi hanya 16% UHI berupa kota. LST berkorelasi -0.59 dengan elevasi. Koreksi elevasi adalah rancangan sendiri (kemiringan -8.2 K/km, R2 0.15 setelah dibatasi <= 500 m), perlu rujukan.
- Belum: multitemporal (2000/2010/2018 seperti artikel), validasi lapangan, verifikasi sumber asli. Artefak: landsat_processor_v46.zip.
