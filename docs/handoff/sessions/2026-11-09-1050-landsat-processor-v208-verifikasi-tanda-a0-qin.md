---
date: 2026-11-09 10:50
source: claude-code
topic: landsat-processor-v208-verifikasi-tanda-a0-qin
status: berlanjut
---

# Landsat Processor v208: verifikasi tanda A0 MCM Qin

## Permintaan
Pengguna mengunggah Rozenstein 2014 dan Qin 2001 (JGR dan mono-window) untuk mengecek tanda A0.

## Hasil pembacaan teks
- Qin, Dall'Olmo, Karnieli 2001 (JGR 106 D19, 22655-22670) Pers. 36a: A0 = E1 a4 - E2 a5 (minus). Turunannya: B = E1 L4 - E2 L5 (Pers. 29), Li = a + bT (Pers. 20, a negatif).
- Rozenstein dkk. 2014 (Sensors 14, 5768) Pers. 4a: A0 = E1 a10 + E2 a11 (plus), padahal Pers. 7-10 (A, E0, E1, E2) identik dengan Qin dan a10, a11 negatif (Tabel 1). Tanda plus tidak konsisten.
- Nugraha 2024 Pers. 30 juga plus. Aplikasi memakai minus (benar menurut sumber asli).
- Uji model maju Planck independen: minus galat +0,08 sampai +0,47 K, plus -1,2 sampai -7,0 K.

## Dilakukan
Hanya komentar kode core/lst.py dan README; APP_VERSION v208. Tidak ada perubahan hitungan.

## Terbuka
- Kesetaraan Qin dan Mao versi Nugraha masih dari pemeriksaan aljabar, teks Mao 2005 belum dicocokkan.
- Offset MCM per scene belum dijelaskan.
