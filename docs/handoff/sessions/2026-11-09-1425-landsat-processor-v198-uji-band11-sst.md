---
date: 2026-11-09 14:25
source: claude-code
topic: landsat-processor-v198-uji-band11-sst
status: berlanjut
---

# Landsat Processor v198: uji band 11 dan MCM terhadap SST

## Keputusan
- Uji band 11 di Validasi SST dinilai perlu: rho11 tab 2 dipaskan terhadap LST band 10 (sirkular), SST kulit satu-satunya acuan independen.
- Modul baru core/sst_band11.py: tau11 tersirat dari kuadrat tertutup, rho11 tersirat per scene, LOSO, bias Ts11 dan MCM (Skokovic, Qin, Mao, Mao asli), kepekaan e11. Output {awalan}_band11.xlsx.
- Tab 2: LSTParams.rho11_fixed melewati pemaskan sirkular.
- Tes: 5 baru (test_sst_validation), 3 baru (test_atmo_lst_l1). Suite 1141 lulus, 4 dilewati.

## Ditolak atau belum
- e11 laut tidak dipaskan, hanya asumsi pengguna (e10 - 0,005) dengan tabel kepekaan.
- Hanya z = 0; semua tes sintetis; data Bali nyata belum diuji.
- Regresi Qin/Mao di laut mungkin buruk-kondisi (R2 dilaporkan).
- Offset kalibrasi B11 hanya sebagian terserap ke rho11 (terbukti di tes).
