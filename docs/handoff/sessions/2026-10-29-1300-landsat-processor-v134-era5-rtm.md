---
date: 2026-10-29 13:00
source: claude-code
topic: landsat-processor-v134-era5-rtm
status: berlanjut
---

## Tujuan
Pengguna (Sediyoadi) ingin meneliti transmitansi atmosfer band 10 untuk jurnal bereputasi (RSASE atau IJRS) dan memilih ERA5 sebagai dasar RTM karena data in situ sulit diperoleh di Indonesia. Ia mengunggah 8 berkas ERA5 dan libRadtran 2.0.6 lalu meminta proses ERA5 ke RTM dibangun.

## Keputusan dan alasannya
- Tab ketiga "Benchmark ERA5-RTM" di halaman Kalibrasi Atmosfer, karena alurnya sejalan dengan dua tab sebelumnya.
- Hasil diberi label benchmark, bukan validasi: ST_ATRAN USGS dan ERA5 sama-sama reanalisis.
- tau dan L_up diturunkan dari dua suhu permukaan (tau = dL/dB), L_down = F turun/pi; REPTRAN kasar utama, LOWTRAN pembanding.
- tau(z) dicocokkan dengan kuadrat terkecil nonlinear langsung pada tau.
- Jalur Windows lewat WSL2 dengan konversi path ke /mnt/c.

## Yang ditolak atau gagal
- REPTRAN halus ditolak: tabel O3 tidak ikut paket.
- Regresi ln(-ln tau) ditolak: misfit 0,077.
- Bug satuan Planck (per m-1 vs per cm-1) membuat tau ribuan; diperbaiki.
- make gagal karena src/.depend artefak macOS; .depend dihapus.

## Hasil nyata
- Berkas: core/atmo_rtm.py, atmo_rtm_bench.py, atmo_rtm_report.py, tests/test_atmo_rtm.py (12 uji lolos termasuk uvspec nyata dan LibreOffice), gui/atmo_calib_page.py (tab ketiga), i18n 11 kunci, README v134, paket landsat_processor_v134.zip.
- 3 scene nyata Karangasem: selisih tau RTM-USGS +0,01 sampai +0,03 (L8) dan +0,13 (L9 2026-09-12). 326 profil: k0 = 0,1755 W (R2 0,93; leave-date-out 0,081), T_up = 7,5 + 0,971 T_eff (0,8 K).
- ST_DRAD USGS sekitar 2,4 sampai 3,3 kali lebih kecil daripada F turun/pi.

## Belum terverifikasi
- Jalur WSL belum diuji di Windows. run_bench diuji dengan MTL rekonstruksi, bukan folder Landsat asli.
- Definisi ST_DRAD (LSDS-1619), SRF Landsat 9 (skala K2), selisih REPTRAN kasar vs LOWTRAN (~0,05), bibliografi sheet Rujukan.
- Selisih +0,13 pada scene L9 belum dijelaskan (kandidat: SRF L9, atmosfer 2026, W).

## Langkah berikutnya
1. Pasang libRadtran di WSL2 pengguna, jalankan tab dengan folder Landsat asli.
2. Tambah tanggal ERA5 (musim dan W lebar) agar regresi tidak hanya tiga klaster.
3. Selidiki selisih scene L9 dan verifikasi ST_DRAD.
4. Cari pembanding independen (bukan reanalisis) sebelum klaim akurasi.
