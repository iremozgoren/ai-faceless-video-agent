# ai-faceless-video-agent

A Claude Code project that produces short, faceless vertical videos (YouTube Shorts / TikTok / Reels, 1080×1920) about animals — from research to a rendered MP4 — with a human approval gate at every step. Each video is made in Turkish and then localized into German.

There is no camera footage: every frame is full-screen motion graphics rendered with [HyperFrames](https://hyperframes.heygen.com) (HTML + GSAP → MP4), synced word by word to an AI voiceover.

## What it does

`/hayvan-videosu <animal>` ("animal video") runs the whole pipeline:

1. Finds 6–8 little-known facts about the animal, each with a reliable source and a quote.
2. Independently verifies them and keeps the 4 strongest.
3. Writes a ~40-second script ("4 things you probably never heard about …").
4. Generates the voiceover (ElevenLabs), extracts word timestamps (Whisper), plans the video scene by scene, builds the HyperFrames composition, checks frames and renders it at -14 LUFS.
5. Translates and re-voices it in German, re-syncs every animation to the German word timings and renders a German MP4 + SRT.
6. Writes upload texts (titles, descriptions with sources, hashtags) as local draft files.

Nothing is ever published automatically. Uploading is always a manual step.

## Agent architecture

```
researcher ──► verifier ──► writer ──► editor ──► translator
(subagent)     (subagent)   (main)     (main)     (main)
    │              │           │          │           │
    ▼              ▼           ▼          ▼           ▼
arastirma/    report added  metin/     motion/     almanca/
<animal>.md   to research   <animal>   cikti/      metin/ ses/
              file          .txt       <animal>-   motion/ cikti/
                                       final.mp4
        ⏸ approve facts   ⏸ approve script   ⏸ approve scene plan
        ⏸ approve video   ⏸ approve translation   ⏸ approve German video
```

| Stage | Who | What it does |
|---|---|---|
| **Researcher** | `.claude/agents/arastirmaci.md` (WebSearch, WebFetch, Write) | Collects 6–8 facts with source URL, species/scope and a quote from the source. |
| **Verifier** | `.claude/agents/dogrulayici.md` (read-only) | Gets only the claims and URLs — not the researcher's quotes — so it checks them independently. Flags exaggerations, suggests corrected wording, picks the 4 strongest facts. |
| **Writer** | main session | Writes the script using only the 4 verified facts; no new facts, numbers or generalizations. |
| **Editor** | main session + HyperFrames skills | Voiceover → word timestamps → scene plan → composition → lint/frame checks → render → loudness check. |
| **Translator** | main session | Natural German (informal *du*), back-translation table for review, German voiceover, re-timed composition, SRT. |

The orchestration lives in `.claude/skills/hayvan-videosu/SKILL.md`; the editing rules in `CLAUDE.md`, the visual style in `kural-dosyasi.md` and the German additions in `almanca/kural-dosyasi-de.md`.

## Project layout

| Path | Contents |
|---|---|
| `ham/` | Raw voiceovers / recordings (not in git) |
| `metin/` | Turkish scripts |
| `arastirma/` | Research and verification notes |
| `motion/<name>/` | HyperFrames projects |
| `cikti/` | Rendered videos and transcripts (not in git) |
| `almanca/` | German scripts, audio, motion projects and outputs |
| `yayin/` | Upload text drafts |
| `scripts/` | Setup, transcription, voiceover and loudness helpers |
| `referanslar/fontlar/` | Inter font (SIL OFL) |

## Setup (macOS)

Requirements: [Homebrew](https://brew.sh), [Claude Code](https://claude.com/claude-code), an [ElevenLabs](https://elevenlabs.io) API key.

```bash
git clone <this repo> video-kurgu
cd video-kurgu
bash scripts/kurulum-mac.sh     # FFmpeg, Node.js 22+, yt-dlp, Whisper, HyperFrames skills
cp .env.example .env            # then put your own key in .env
```

`.env`:

```
ELEVENLABS_API_KEY=your-elevenlabs-api-key
```

`.env` is git-ignored. Voice IDs and the model are read from `kural-dosyasi.md` (Turkish) and `almanca/kural-dosyasi-de.md` (German).

## Usage

Open the folder in Claude Code and run:

```
/hayvan-videosu octopus
```

Claude stops at each ⏸ checkpoint and waits for an explicit approval before continuing.

Helper scripts can also be run on their own:

```bash
scripts/seslendir.sh metin/<name>.txt ham/<name>.mp3 tr          # voiceover (tr | de)
scripts/transkript.sh ham/<name>.mp3 [tr|de]                      # word-level transcript
scripts/ses-seviye.sh <input.wav|mp4> <output>                    # normalize to -14 LUFS
```

## License

The Inter font is licensed under the SIL Open Font License (`referanslar/fontlar/Inter-OFL.txt`).
