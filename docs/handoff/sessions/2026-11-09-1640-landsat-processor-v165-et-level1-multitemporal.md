---
date: 2026-11-09 16:40
source: claude-code
topic: landsat-processor-v165-et-level1-multitemporal
status: berlanjut
---

## Tujuan
Pengguna: "bisa dibuat ET multi temporal untuk level 1 dengan metode Bandara" (metode Waters sulit). Sebelumnya ET batch hanya Level 2 (v153).

## Keputusan dan alasannya
- Pakai ulang `_chain` dari et_bandara_batch (komentarnya sudah menyebut jalur Level 1); hanya penyiapan masukan baru di core/et_l1_batch.py. Alasan: kesetaraan dengan menu lama dan jalur L2 terjaga.
- Albedo lewat fungsi menu Albedo (path radiance 0,03, tau_sw), bukan rumus L2 tanpa koreksi kedua. Uji membandingkan dengan compute_albedo.
- Emisivitas wajib dari folder menu Emissivity (Mean, cadangan Valor-Caselles); tidak ada cadangan NDVI kasar seperti L2. Alasan: konsisten dengan v164 dan LST.
- Keluarga reflektansi bernama dos/6s/surface hanya diperingatkan, tidak ditolak (pengguna bisa sengaja).

## Yang ditolak atau belum
- LST multi-temporal SCM/MCM dari Level 1 belum ada; LST harus dari folder (tab 2 atau menu per scene). Calon v166.
- Bug `_find_emis` (atmo_lst.py) memilih `_NDVI.tif` pada folder keluaran v164 untuk metode "folder": belum diperbaiki, dilaporkan ke pengguna. Perbaikan = versi tersendiri.
- Waters tidak dibuat (permintaan pengguna: sulit).

## Hasil nyata
- core/et_l1_batch.py, gui/et_l1_batch_page.py, menu "ET Multi-Temporal (Level 1)", laporan memakai write_et_batch dengan judul dan batas khusus, tests/test_et_l1_batch.py (11 uji), i18n total 3700, README v165. 56 uji terkait lulus.

## Berikutnya
Uji dengan data Level 1 nyata; perbaiki _find_emis; LST SCM/MCM multi-temporal; investigasi crash test_twi/test_modis_lst.
