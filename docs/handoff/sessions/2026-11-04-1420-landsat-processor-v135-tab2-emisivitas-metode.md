---
date: 2026-11-04 14:20
source: claude-code
topic: landsat-processor-v135-tab2-emisivitas-metode
status: berlanjut
---

## Tujuan
Tab 2 (Terapan LST dan analisis): ganti kolom folder emisivitas dengan menu metode emisivitas yang dihitung aplikasi, tambah menu metode LST (yang memakai uap air), dan tampilkan hasil LST metode Landsat berdampingan dengan LST atmosfer hasil kalibrasi.

## Keputusan dan alasannya
- Memakai ulang fungsi core.emissivity dan core.lst lewat modul baru core/atmo_lst_methods.py karena rumus harus sama dengan menu aslinya.
- Metode LST fase 1 hanya satu band (JMS dengan tau Rozenstein dari W, Artis-Carnahan) karena produk L2 tidak punya band 11.
- Fallback ke ST_EMIS bila SR_B4/SR_B5 tidak ada, dengan catatan per scene, agar proses tidak berhenti.
- Folder emisivitas pengguna dipertahankan sebagai salah satu pilihan menu (kompatibel dengan versi lama).

## Yang ditolak atau gagal
- Metode multi-kanal (Skokovic, Qin, Mao) ditunda karena butuh band 11 dari Level 1 (pemindaian L1 dan MTL L1 belum ada).

## Hasil nyata
- Berkas: core/atmo_lst_methods.py, core/atmo_lst.py, core/atmo_lst_report.py, gui/atmo_calib_page.py, tests/test_atmo_lst_methods.py, README v135, zip landsat_processor_v135.zip.
- Sheet baru: Emisivitas_Metode, Metode_LST, Sampel_Metode (rumus hidup), Grafik_Metode; Cek_Rumus lolos di LibreOffice.
- Uji: 29 lolos, 2 dilewati (rtm + lst + methods).

## Belum terverifikasi
- Jalur W dari ERA5 di tab 2 belum diuji dengan ERA5 nyata.
- Jalur WSL (tab 3) belum diuji di Windows.
- Uji pada data nyata Bali oleh pengguna belum ada.

## Langkah berikutnya
1. Pengguna menjalankan tab 2 pada data Bali dan melaporkan log.
2. Fase 2: metode MCM dengan band 11 dari Level 1.
3. Fitur uji laut SST setelah pengguna mengirim daftar berkas dan paket tanggal.

## Tambahan (sesi yang sama)
- v136: pyproj dibuang dari tab 2 dan tab 3 (penyebab kegagalan tab 2 di mesin pengguna), diganti rasterio.warp.
- v137: core/libradtran_setup.py dan tombol pasang/tes libRadtran di tab 3 (jalur WSL belum diuji di Windows).
- Aturan pengguna: setiap perubahan memakai nomor versi baru berurutan (v138 dst), jangan menimpa nama zip yang sama; zip lama bernama v135 sudah memuat v136 dan v137.
- v138: wsl -l -q timeout 30 dtk pada mesin pengguna; panggilan wsl kini stdin kosong, tanpa jendela konsol, batas 150 dtk, pesan perbaikan jelas. Penyebab pasti belum terverifikasi.
- v139: configure libRadtran gagal "Could not find NetCDF" di Ubuntu pengguna (gcc/gfortran 15); pemasang kini memasang libnetcdf-dev, netcdf-bin, python3 dan memeriksa nc-config sebelum configure. Build selanjutnya di WSL pengguna belum terkonfirmasi.
- v140: configure ke-2 gagal "Did not find GSL"; pemasang menambah libgsl-dev, pkg-config dan memeriksa gsl-config. Build selanjutnya belum terkonfirmasi.
- v141: make libRadtran berhenti di libsrc_c ("No rule to make target /opt/local/include/..."): .depend bawaan arsip berjalur macOS. Pemasang menghapus .depend berjalur /opt/local sebelum make. Dugaan penyebab kuat tetapi belum dikonfirmasi pada pohon sumber pengguna.
- v142: uvspec WSL buatan pengguna jalan; Tes uvspec gagal "Unknown command on line 2" karena jalur Windows berspasi. Direproduksi, atm/grid kini disalin ke folder sementara dan dirujuk relatif (wsl --cd). Belum dikonfirmasi di Windows pengguna.
