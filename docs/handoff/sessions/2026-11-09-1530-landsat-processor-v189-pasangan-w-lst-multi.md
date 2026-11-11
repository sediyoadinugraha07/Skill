---
date: 2026-11-09 15:30
source: claude-code
topic: landsat-processor-v189-pasangan-w-lst-multi
status: berlanjut
---

# Landsat Processor v189 (GeoSpectra): pasangan w pada LST multi-temporal

## Yang dikerjakan
- `core/lst_multi.py`: `resolve_w`, strategi same_day / nearest / nearest_mean / mean, parameter w_strategy, w_max_days (4), w_mean_days (30), w_min_n (3). Kolom sumber w di Excel dan baris Cek folder. GUI tab "LST multi-temporal" mendapat 4 kontrol. i18n ex189 (9 kunci, total 3977).
- Tes: tests/test_lst_multi_wpair.py (11), tes lama LST multi, lst_batch, l2_batch, i18n, brand lolos (51).

## Keputusan dan alasan
- Bawaan fungsi inti tetap same_day (kompatibel); bawaan GUI nearest_mean sesuai urutan yang diminta pengguna (sama, terdekat, rata-rata).
- Tie hari -k dan +k dirata-rata; interpolasi linear belum dibuat. W di luar 0,05 sampai 8 diabaikan.
- Sumber w dicatat per citra karena w pengganti menambah ketidakpastian; besarnya belum diukur.

## Ditolak
- Menebak w dari tabel atau konstanta bila semua cadangan gagal: citra tetap dilewati.

## Belum
- Uji dengan W MODIS dan Landsat nyata; sensitivitas LST terhadap selisih w; nilai jendela 4 dan 30 hari belum tervalidasi.
- Lanjutan: Sentinel-2 L2A menunggu sampel lengkap (R20m, B04, B08 10 m); sampel tersimpan di /home/claude/s2_samples (sesi ini).
