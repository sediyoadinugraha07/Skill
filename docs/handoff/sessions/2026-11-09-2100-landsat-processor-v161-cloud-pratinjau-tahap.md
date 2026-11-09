---
date: 2026-11-09 21:00
source: claude-code
topic: landsat-processor-v161-cloud-pratinjau-tahap
status: berlanjut
---

## Tujuan
Permintaan pengguna: cloud masking multi-temporal perlu pilihan/pemeriksaan seperti menu satu scene agar tidak keliru.

## Keputusan dan alasannya
- Ditafsirkan sebagai: menu satu scene punya pratinjau QA dan tahap mask terpisah dari penerapan. Dibuat preview_cloud_batch (tanpa tulis berkas) dan parameter stage ("masks" atau "both").
- Satu kriteria untuk seluruh deret (konsistensi antar tanggal); dicatat di Excel dan tag MASK_SIG.

## Yang ditolak atau gagal
- Override kriteria per scene belum dibuat (risiko deret tidak seragam); ditawarkan bila pengguna memang membutuhkan.

## Hasil nyata
- cloud_batch.py (+preview, +stage), cloud_batch_page.py (tombol pratinjau, combo tahap), 2 uji baru (14), i18n 4 kunci, README v161.
