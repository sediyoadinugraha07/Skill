---
date: 2026-11-09 09:30
source: claude-code
topic: landsat-processor-v206-paket-standar-jurnal-tab4-tab5
status: berlanjut
---

# Landsat Processor v206: paket standar jurnal tab 4 dan tab 5

## Permintaan
Tab 4 (benchmark ERA5-RTM, opsi Landsat 8, 9, gabung) dan tab 5 (validasi SST, uji band 11) perlu keluaran berstandar jurnal bereputasi, dengan data asli Excel agar bisa dibangun ulang bila ada kekeliruan.

## Yang dibangun
- core/validation_pack.py baru: write_sst_pack, write_band11_pack, write_bench_pack. Hanya membaca hasil, tidak mengubah angka.
- Statistik per sensor L8, L9, Gabungan: n, bias, SD, RMSE, MAE, median, SD robust, batas kesepakatan 95%, CI95 bootstrap atas scene (tab 5) atau tanggal (regresi grid tab 4). Kurang dari 10 unit ditandai indikatif.
- Data asli: CSV pasangan lengkap (SSTParams.full_pairs=True), Excel dengan sheet data, Rekonstruksi berumus hidup, Reproduksi (versi, seed, parameter, sha256 berkas), Kamus_Data, Data_Grafik, gambar 300 dpi.
- Tab 4 dan tab 5 tersambung otomatis (try/except, kegagalan hanya dicatat).

## Alasan dan yang ditolak
- Bootstrap atas scene dan tanggal, bukan piksel: piksel dalam scene tidak independen.
- Tidak melaporkan R2 sebagai ukuran utama; bias, SD, RMSE disertai n dan CI.
- Rujukan hanya yang benar-benar dibaca (CEOS LPV hanya abstrak; Ghent LPVE; Underfly L8/L9 2023; SST CCI). Bland-Altman dan bootstrap adalah praktik umum, bukan kutipan.

## Catatan terbuka
- Selisih b L8 minus L9 tab 4 bercampur dengan perbedaan tanggal atmosfer.
- Belum diuji pada data nyata; pengguna akan mengulang seluruh pengolahan.
- Tes: 1178 lulus, 4 dilewati.
