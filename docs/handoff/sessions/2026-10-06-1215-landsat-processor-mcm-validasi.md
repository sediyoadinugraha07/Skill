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

## Langkah berikutnya

1. Kode aplikasi belum ada di repo manapun. Taruh `landsat_processor_v34.zip` ke repo (misalnya repo terpisah `landsat-processor`) supaya Claude Code bisa melanjutkan; dokumen ini tidak membawa kodenya.
2. Tanyakan arti "MEE" ke pengguna, sesuaikan kolom statistik bila perlu.
3. Buka `*_validasi.xlsx` dan `*_regresi.xlsx` di Excel asli, pastikan sumbu, garis diagonal, dan titik tampil benar.
4. Uji Validasi dengan data lapangan nyata dan raster Level 2 USGS.
5. Pertimbangkan konversi koordinat ke lon/lat bila pyproj tersedia dan bisa diverifikasi.
6. Sebelum tiap rilis: bersihkan cache dan scratch, zip tanpa `core/six_s_correction.py` dan `bin/*`, ekstrak ke direktori bersih, jalankan penuh pytest dan smoke test GUI headless.
