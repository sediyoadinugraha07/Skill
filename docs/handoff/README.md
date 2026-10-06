# Handoff journal

Satu jurnal berjalan untuk semua sesi, di claude.ai maupun Claude Code. Setiap sesi menghasilkan satu entri di `sessions/`, lalu satu baris di `INDEX.md`.

## Alur
1. **Awal sesi:** baca `INDEX.md`, lalu buka 2 sampai 3 entri terbaru yang relevan.
2. **Selama sesi:** tidak ada kewajiban. Untuk sesi panjang, buat entri sementara bila perlu.
3. **Akhir sesi (atau tiap jeda besar):** buat entri dari `TEMPLATE.md`, simpan di `sessions/YYYY-MM-DD-HHMM-<slug>.md`, tambahkan satu baris di `INDEX.md`, commit, push.

## Dari claude.ai
claude.ai tidak bisa menulis ke repo ini dengan sendirinya. Tempel isi `PROMPT-claude-ai.md` ke percakapan, salin hasilnya ke berkas entri baru, lalu commit. Langkah manual ini tidak bisa dihindari kecuali Anda memakai konektor GitHub yang memberi akses tulis.

## Dari Claude Code
Aturannya ada di `.claude/CLAUDE.md`. Claude Code membaca indeks di awal sesi dan menulis entri di akhir.

## Aturan isi
- Catat **alasan** keputusan dan hal yang **ditolak**, bukan hanya hasilnya.
- Jangan simpan rahasia (kunci API, password, token) atau data pribadi.
- Satu entri, satu topik utama. Ringkas, maksimal sekitar satu layar.
