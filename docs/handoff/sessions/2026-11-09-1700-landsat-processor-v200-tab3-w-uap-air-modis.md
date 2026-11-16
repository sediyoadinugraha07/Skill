---
date: 2026-11-09 17:00
source: claude-code
topic: landsat-processor-v200-tab3-w-uap-air-modis
status: berlanjut
---

# Landsat Processor v200: tab 3 Terapan LST (W uap air MODIS)

Permintaan pengguna (2026-11-16 16:37): terapkan regresi transmitansi tab 1 dengan W dari menu Uap Air MODIS (Nugraha) di tab baru di samping tab 2; tab 2, ERA5, SST tidak berubah; batas piksel regresi W dibuat fleksibel.

## Yang dibuat
- `core/wv_apply.py` (baru): `build_w_nug`, `fit_scale`, `override_w`, `format_log`; mode skala fit, none, manual.
- `LSTParams.w_nug`; override W di `apply_scene` (Level 2, termasuk LOSO) dan `apply_scene_l1`.
- GUI: tab "Terapan LST (W uap air MODIS)" setelah tab 2; worker membangun w_nug dari scene L2 dan L1.
- `core/modis_wv.py`: min_valid bawaan 30 (sebelumnya 200), sampel regresi mengikuti piksel tersedia (lantai 500, maksimal separuh piksel valid, n_max 20000), peringatan di bawah 200 piksel. GUI tunggal dan batch punya spinbox.
- Tes: `tests/test_wv_apply.py` (11), suite penuh 1153 lolos, 4 dilewati.

## Keputusan dan yang ditolak
- Lantai sampel tetap 500 (bukan 15): menurunkannya mengubah hasil scene normal dan memecahkan tes lama; area kecil sudah ditangani batas separuh piksel valid.
- Mode tanpa skala disediakan tetapi bukan bawaan: k0_b per W fisis, W Nugraha sekitar 0,6, jadi tau sekitar 0,92.
- Tidak mengubah tab 2 sama sekali.

## Batasan
- s dipaskan dari data yang sama, LOSO tidak sepenuhnya out-of-sample; dinamik W Nugraha tertekan (CV sekitar 4% berbanding 20%), tau antar scene cenderung seragam.
- Hanya data sintetis. Perlu uji dengan data nyata, dibandingkan dengan ST_B10 dan validasi SST.
- Belum diperiksa: ekor panas 50 sampai 60 C di hasil tab 2, kemiripan Qin dan Mao_orig, rho11 mentok 0,60 pada 10 Apr 2025.
