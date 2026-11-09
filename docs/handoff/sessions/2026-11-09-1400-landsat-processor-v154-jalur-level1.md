---
date: 2026-11-09 14:00
source: claude-code
topic: landsat-processor-v154-jalur-level1
status: berlanjut
---

## Tujuan
LST dan ET multi-temporal tidak hanya dari Level 2: satu folder Level 1 mentah diolah sampai LST, ET24 Bandara, dan TEI, dengan pilihan metode eksplisit per tahap agar aplikasi tidak menebak.

## Keputusan dan alasannya
- Rantai ET v153 dipecah menjadi `_chain` bersama; jalur Level 1 dan Level 2 memakai rantai yang sama (hasil setara, satu tempat perbaikan).
- Masker QA dan wilayah dihitung SEBELUM DOS: awan dan area di luar wilayah mencemari histogram objek gelap.
- DOS bersama albedo toa_tau ditolak (koreksi atmosfer ganda); MCM wajib emisivitas dua band dan W; SCM Jimenez-Munoz tidak ada di jalur ini (butuh L_up/L_down Level 2).
- LST disimpan sebagai `<scene>_<metode>_LST_K.tif` supaya katalog v152 mengenalinya; sumber TEI dikunci ke metode terpilih.
- Satu scene gagal tidak menghentikan batch; alasan masuk daftar dilewati.
- Penomoran: geostatistik jadi v155, regresi spasial v156.

## Yang ditolak atau gagal
- Memakai menu satu-scene berulang ditolak (permintaan pengguna: multi-temporal).
- DOS pada seluruh scene termasuk awan ditolak (lihat di atas).

## Hasil nyata
- core/pipeline_l1.py, panel "Jalur Level 1" di gui/tei_page.py (kolom W di tabel angin), tests/l1_fixture.py, tests/test_pipeline_l1.py (9 uji), i18n 15 kunci, README v154. Uji terkait lulus.

## Belum terverifikasi
- Semua uji sintetis; belum pada Level 1 nyata dan belum dibandingkan dengan hasil menu manual.
- Kualitas QA_PIXEL Level 1, DOS pada scene tropis berawan, emisivitas hanya dari NDVI, ET lawan pengukuran.
- Tabel CSV/Excel belum membaca kolom W (hanya GUI).

## Langkah berikutnya
1. Pengguna menjalankan satu scene Level 1 nyata dan membandingkan LST/ET24 dengan menu manual.
2. Geostatistik v155, regresi spasial v156; WUP menunggu artikel.
