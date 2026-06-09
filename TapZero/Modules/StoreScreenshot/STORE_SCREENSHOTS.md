# App Store Screenshots

Store görselleri için SwiftUI Preview tabanlı ekranlar.
Figma'daki device frame'lerine konulacak optimize edilmiş UI içerikleri.
Ham ekran değil — her biri store için yaratıcı şekilde optimize edilmiş.

---

## Ekranlar

| # | Ekran | Açıklama | Durum |
|---|-------|----------|-------|
| 1 | Gameplay | Countdown sekansı — 3→2→1→GO motion efekti | done |
| 2 | Play (Home) | Number picker ile hedef seçme | done |
| 3 | Scores | Farklı skorların üst üste fan'ı (perfect/good/mid) | done |
| 4 | Stats | İstatistik ekranı (ortalama, en iyi skor, trendler) | done |
| 5 | Share | Skor paylaşım kartı — 6 renk fan layout | done |
| 6 | Leaderboard | Sıralama tablosu + podium | done |

---

## Wireframe'ler

### 1. Gameplay — Countdown Sekansı

Countdown sayılarını (3, 2, 1, GO) üst üste azalan opacity
ile gösterip "motion" hissi veriyoruz. Tek frame'de tüm
countdown deneyimini anlatıyor.

```
┌──────────────────────────┐
│                          │
│                          │
│        ╭──────────╮      │
│       ╭┤          ├╮     │  ← Concentric ring'ler
│       │╰──────────╯│     │
│       │            │     │
│       │  3         │     │  ← "3" (opacity 0.15, arkada)
│       │   2        │     │  ← "2" (opacity 0.30, ortada)
│       │    1       │     │  ← "1" (opacity 0.50)
│       │     GO     │     │  ← "GO" (opacity 1.0, önde)
│       │            │     │
│       ╰────────────╯     │
│                          │
│                          │
│                          │
│                          │
└──────────────────────────┘

Efekt: Her sayı hafifçe offset + scale ile sıralanır,
       sanki countdown animasyonunun tüm frame'leri
       tek karede üst üste binmiş gibi.
       GO en büyük ve en opak → hero element.
```

### 2. Play (Home) — Hedef Seçim

Gerçek ekran yapısı korunuyor — NumberPicker zaten
yakındaki sayıları farklı boyutlarda gösteriyor,
bu doğal "depth" efekti store için yeterince etkileyici.

```
┌──────────────────────────┐
│  ○ burak          891    │  ← UserStrip
│                          │
│                          │
│         TARGET           │
│                          │
│          4               │  ← Uzak sayı (36pt, soluk)
│          4               │  ← Yakın sayı (72pt)
│                          │
│          5               │  ← Seçili sayı (132pt, bold)
│                          │
│          6               │  ← Yakın sayı (72pt)
│          7               │  ← Uzak sayı (36pt, soluk)
│                          │
│       5 seconds          │
│     swipe to select      │
│                          │
│   ┌──────────────────┐   │
│   │       PLAY       │   │  ← PlayButton (60pt)
│   └──────────────────┘   │
└──────────────────────────┘

NumberPicker'ın depth efekti zaten store-ready.
selectedTarget = 5, bestScore = 891.
```

### 3. Scores — Performans Fan'ı

Share'deki fan mantığı — ama renk varyantları yerine
farklı performans seviyeleri gösteriliyor.
3 ScoreCard: perfect (yeşil), good (yeşil), mid (sarı).
Scoring sistemini tek karede anlatıyor.

```
┌──────────────────────────┐
│                          │
│                          │
│  ┌── Mid (sarı) ──┐     │
│ ┌── Good (yeşil) ─┐│    │  ← 3 kart fan layout
│┌── Perfect ───────┐││    │    (Share'deki gibi rotation + scale)
││                  │││    │
││      1000        ││┘    │  ← Hero: Perfect score (yeşil)
││    ● Perfect     │┘     │
││                  │      │
││  ◄───●───────►   │      │  ← Timeline (perfect = ortada)
││  TARGET  │  YOU  │      │
││  10.00   │ 10.00 │      │
│└──────────────────┘      │
│                          │
│   ┌──────────────────┐   │
│   │    Play Again     │   │  ← CTA button
│   └──────────────────┘   │
│                          │
└──────────────────────────┘

Fan kartları (arkadan öne):
- Mid:     640 skor, sarı, rotation -8°, scale 0.88
- Good:    847 skor, yeşil, rotation +5°, scale 0.94
- Perfect: 1000 skor, yeşil, rotation 0° (hero)

Mesaj: "Her seferinde daha iyisini yap"
```

### 4. Stats — İstatistik Derinliği

Stats ekranı zaten veri yoğun ve etkileyici.
Gerçek ekran yapısı korunuyor — data richness
kendisi store için yeterli bir satış noktası.

```
┌──────────────────────────┐
│     Scores │ ■ Stats     │  ← SegmentedControl
│                          │
│  ┌────────────────────┐  │
│  │       724          │  │  ← HeroStatView
│  │   avg score  ↑ 12% │  │    (büyük ortalama + trend)
│  │      42 games      │  │
│  └────────────────────┘  │
│                          │
│  ┌──────┐  ┌──────┐     │
│  │  986 │  │   18 │     │  ← KPIGridView (2x3)
│  │ best │  │streak│     │
│  ├──────┤  ├──────┤     │
│  │   23 │  │   60 │     │
│  │ perf │  │games │     │
│  ├──────┤  ├──────┤     │
│  │  38% │  │0.34s │     │
│  │ rate │  │ avg  │     │
│  └──────┘  └──────┘     │
│                          │
│  ┌────────────────────┐  │
│  │ ████████ 25% perf  │  │  ← DistributionView
│  │ ████████████ 40%   │  │    (rating breakdown)
│  │ ████████ 20% mid   │  │
│  │ ██████ 15% bad     │  │
│  └────────────────────┘  │
│                          │
└──────────────────────────┘

Gerçek ekran yeterince impresif.
İmpresif mock data ile doldurmak yeterli.
```

### 5. Share — Renk Fan'ı (done)

```
┌──────────────────────────┐
│                          │
│   ╲ Purple ╱             │
│  ╲ Orange ╱│             │
│ ╲ Green  ╱ ││            │  ← 6 ScoreCard fan
│╲ Blue   ╱  │││           │    (bottom anchor'dan dönen)
│╲ Light ╱   ││┘           │
│┌ Dark ─────┐┘            │  ← Hero: Dark tema
││   912     │             │
││  0.08s off│             │
│└───────────┘             │
│                          │
│   ○ ○ ○ ○ ○ ○           │  ← Color picker
│  ┌────────────────────┐  │
│  │       Share        │  │
│  └────────────────────┘  │
└──────────────────────────┘
```

### 6. Leaderboard — Yarışma Sahnesi

Gerçek ekran yapısı korunuyor — podium + liste
zaten güçlü bir rekabet görselliği sunuyor.
Kullanıcı top 10'da → ulaşılabilir hedef hissi.

```
┌──────────────────────────┐
│    ■ Global │ Daily      │  ← SegmentedControl
│                          │
│         ┌─────┐          │
│    ┌────┤  1  ├────┐     │  ← PodiumView
│    │ 2  │ 984 │  3 │     │    (altın/gümüş/bronz madalyalar)
│    │971 │Mira │958 │     │
│    │Kenj│     │Yuna│     │
│    └────┴─────┴────┘     │
│                          │
│   4   Liam Carter   932  │
│   5   Sofia Rossi   918  │
│   6   Noah Kim      904  │
│   7 ★ Burak         891  │  ← Kullanıcı highlight
│   8   Emma Liu      876  │
│   9   Raj Patel     854  │
│  10   Ava Chen      837  │
│                          │
└──────────────────────────┘

Gerçek ekran zaten store-ready.
Podium + madalyalar + highlight yeterli.
```

---

## Kurallar

- Her ekran 10 locale için preview içerir (EN, TR, AR, DE, ES, FR, IT, JA, KO, PT-BR)
- Tüm textler `TextKey` üzerinden — hardcoded string yasak
- Sayılar locale-aware formatlanır (`localeOverride` ile tam locale: `ar_SA`, `de_DE` vs.)
- Her locale'de farklı userName + InitialAvatarView
- Light mode, `.environment(\.colorScheme, .light)`
