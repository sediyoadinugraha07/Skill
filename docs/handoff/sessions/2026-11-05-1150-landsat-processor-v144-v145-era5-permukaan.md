---
date: 2026-11-05 11:50
source: claude-code
topic: landsat-processor-v144-v145-era5-permukaan
status: berlanjut
---

## Tujuan
Tab 3 gagal untuk semua scene dengan pesan "tanggal tidak ada pada ERA5". Cari penyebab dan buat aplikasi bisa memproses.

## Keputusan dan alasannya
- v144: pesan galat dipisah per keadaan dan memuat isi ERA5 (rentang tanggal lengkap, hanya tekanan, hanya permukaan) agar penyebab terlihat.
- Berkas pengguna (Agustus.zip, February.zip) hanya memuat t, q, z pada 37 level; tidak ada single levels. Itu penyebab pasti. Tiga scene (4 Nov, 6 Des, 30 Des 2025) di luar rentang ERA5 (berhenti 3 Okt).
- v145: derive_surface menurunkan sp, t2m, d2m, skt, tcwv dari profil tekanan pada satu ketinggian acuan (DEM di titik profil, atau 0 m). Ditandai pendekatan di catatan laporan; aktif bawaan dengan centang di tab 3; tab 2 memakainya untuk W ERA5.

## Yang ditolak atau gagal
- Memaksa pengguna mengunduh ulang sebagai satu-satunya jalan ditolak karena memblok pekerjaan; unduhan single levels tetap disarankan untuk hasil yang sah.

## Hasil nyata
- Berkas: core/atmo_rtm.py, core/atmo_rtm_bench.py, core/atmo_lst.py, gui/atmo_calib_page.py, tests, README v144-v145, landsat_processor_v145.zip. Uji: 46 lolos, 4 dilewati.

## Belum terverifikasi
- Nilai turunan belum dibandingkan dengan ERA5 single levels asli.
- uvspec tidak ada di lingkungan ini, jadi alur benchmark penuh belum dijalankan sampai RTM; hanya sampai tahap uvspec.
- Tes uvspec pengguna dilaporkan beroperasi (v142 atau lebih baru).

## Langkah berikutnya
- Pengguna menjalankan tab 3 dengan v145; kirim log bila gagal.
- Tab 4 uji SST menunggu paket berkas SST.
