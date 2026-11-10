---
date: 2026-11-09 08:30
source: claude-code
topic: landsat-processor-v178-l2-multi-lst-tabs
status: berlanjut
---

# Landsat Processor v178

## Konteks
Permintaan 07:59: (1) tombol multi-temporal di menu Landsat Level 2, hasil per folder citra; (2) tab LST ke-3 sudah digantikan tab ke-4, hapus; (3) hapus kolom tanggal di tab LST multi-temporal.

## Keputusan
- `core/landsat_l2_batch.py` baru; `LandsatL2Job._convert_found` diekstrak dari loop lama agar menu satu input dan batch memakai hitungan yang sama.
- Arsip dibaca per anggota, hanya band tercentang yang diekstrak sementara.
- Tab LST ke-3 hanya dilepas dari `LSTHostPage`; kode `lst_batch` dipertahankan karena `lst_multi` mengimpor helper darinya.
- Filter tanggal dihapus dari GUI saja, bukan dari fungsi inti.

## Ditolak
- Menghapus `core/lst_batch.py`: dipakai `lst_multi`.
- Membuka arsip penuh per citra: boros disk dan waktu.

## Status
5 uji baru lulus; uji tab disesuaikan. Belum diuji arsip USGS nyata.
