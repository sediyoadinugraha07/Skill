---
date: 2026-10-28 20:30
source: claude-code
topic: landsat-processor-v133-terapan-lst
status: berlanjut
---

## Tujuan
Pengguna (Sediyoadi) ingin atmosfer hasil kalibrasi (tau, L_up, L_down) dipakai menghitung LST, dibandingkan dengan USGS ST_B10 dan tau Rozenstein, dengan Excel analisis (rumus hidup, sensitivitas, grafik Excel yang bisa disunting, PNG resolusi tinggi) untuk naskah jurnal internasional. Harus berada di halaman Kalibrasi Atmosfer, bukan menu SCM.

## Keputusan dan alasannya
- Tab kedua "Terapan LST dan analisis" di `gui/atmo_calib_page.py` karena pengguna minta tidak di SCM agar tidak membingungkan.
- Hanya jalur transmitansi hasil kalibrasi yang dipakai karena pengguna tidak punya data RTM/profil untuk menurunkan c0-c6 tropis.
- Tiga varian (dalam sampel, LOSO, Rozenstein) dengan ST_TRAD dan emisivitas sama, supaya hanya atmosfer yang beda. LOSO jadi angka jujur karena dalam sampel optimistis.
- Kalibrasi disimpan sebagai JSON (scene dan pasangan); regresi dihitung ulang saat dimuat, jadi tab 2 bisa dipakai tanpa mengulang kalibrasi.
- Rumus Excel ditulis hidup (bukan nilai) dan diuji silang dengan Python lewat sheet Cek_Rumus.

## Yang ditolak atau gagal
- Penurunan koefisien c0-c6 / split-window tropis ditunda: butuh RTM dan profil atmosfer, dan tau band 11 tidak bisa dikalibrasi dari produk L2.
- Bug sempat ada: LOSO memakai kolom W dan T_eff model utama padahal model LOSO bisa memilih kolom lain (bias LOSO sekitar -1,4 K pada dua scene sintetis); diperbaiki dengan pair_inputs terpisah.
- Bug sempat ada: kolom "LST Python" di sheet Sensitivitas bergeser satu kolom (Cek_Rumus GAGAL 299 K); diperbaiki.

## Hasil nyata
- Berkas: `core/atmo_lst.py`, `core/atmo_lst_report.py`, `tests/atmo_lst_fixture.py`, `tests/test_atmo_lst.py` (10 uji), `gui/atmo_calib_page.py` (bertab), i18n EN/ZH (17 kunci), README bagian v133.
- Data sintetis: LST dalam sampel bias -0,002 K (RMSE 0,07), LOSO RMSE 0,09, Rozenstein bias -0,83 K (RMSE 1,33). Cek_Rumus 5/5 LOLOS di LibreOffice, nol sel galat.
- Paket: `landsat_processor_v133.zip`.

## Belum terverifikasi
- Belum diuji pada data asli (Windows, korpus Bali). Angka sintetis hanya membuktikan kode, bukan akurasi metode.
- Referensi USGS adalah konsistensi, bukan kebenaran lapangan. n scene kecil berarti indikatif.
- Definisi ST_DRAD terhadap LSDS-1619; bibliografi di sheet Rujukan (dari ingatan); Wang dkk. 2015 dan Tabel I Jimenez-Munoz 2014 tidak diverifikasi.
- Pesan "malloc_consolidate" muncul saat proses pytest berakhir setelah tes GUI Qt; belum diselidiki (semua tes lolos).

## Langkah berikutnya
1. Jalankan kalibrasi lalu tab Terapan LST pada korpus asli (ATMO_CORPUS) dan baca Cek_Rumus serta catatan di Ringkasan.
2. Tambah scene (target >= 8, 1 sampai 3 tahun, sebaran W lebar) sebelum menulis klaim di naskah.
3. Cari pembanding independen (LST lapangan atau produk lain) agar ada klaim akurasi, bukan hanya konsistensi.
4. Bila data RTM/profil tersedia, turunkan koefisien split-window tropis.
