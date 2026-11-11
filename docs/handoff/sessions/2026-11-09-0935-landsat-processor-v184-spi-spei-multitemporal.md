---
date: 2026-11-09 09:35
source: claude-code
topic: landsat-processor-v184-spi-spei-multitemporal
status: berlanjut
---

## Konteks
Pengguna (09:02, 11 Nov): bangun indeks presipitasi SPI atau SPEI, wajib multi-temporal; cek literatur metode SPI dan SPEI; bangun bila memungkinkan.

## Literatur (yang benar-benar terbaca)
- Pieper dkk. 2020 HESS 24:4541: gamma 2-parameter standar SPI; EWD3 3-parameter lebih normal untuk simulasi; GGD3 sering gagal konvergen; sampel ~31 tahun membatasi pembedaan kandidat.
- Dokumentasi paket R SPEI: SPEI bawaan log-logistik, SPI bawaan gamma, opsi Pearson III; pencocokan ub-pwm, pp-pwm, max-lik (hanya log-logistik); periode acuan opsional; PET thornthwaite/hargreaves/penman.
- Tutorial precip-index: gamma, Pearson III, log-logistik; acuan 30 tahun WMO; kelas WMO.
- Stagge 2015 dan Beguería 2014 gagal dibaca (hanya judul); klaim tentangnya TIDAK dipakai sebagai dasar.

## Dibuat (v184)
- core/drought_index.py, gui/drought_index_page.py, DroughtHostPage, menu Indeks Kekeringan. tests/test_drought_index.py (21), i18n ex184, README v184.

## Keputusan dan alasan
- Pencocokan tervektorisasi sendiri (gamma Thom, Pearson III L-momen, log-logistik/GLO L-momen, empiris Gringorten) karena scipy per piksel tak layak untuk raster besar.
- Keluaran multi-band per skala (satu file terbuka saat blok ditulis) + opsi per bulan.
- Z dipotong 3,5; sampel minimal 20 tahun; nol p=q.

## Ditolak
- Pencocokan scipy per piksel; menghitung Penman-Monteith di aplikasi (butuh banyak variabel; lewat raster PET).
- GEV/Weibull/GGD3 (belum ada dasar kuat memilihnya; GGD3 sering gagal konvergen).

## Belum diverifikasi
Perbandingan dengan paket R SPEI/climate_indices pada data nyata; Thornthwaite di iklim hangat; kinerja pada raster besar.

## Temuan saat uji
Rumus sigma Pearson III awal salah (kurang akar alpha); uji terhadap scipy menangkapnya.
