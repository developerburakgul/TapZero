# App Store Screenshots

Store görselleri için SwiftUI Preview tabanlı ekranlar.
Figma'daki device frame'lerine konulacak optimize edilmiş UI içerikleri.

---

## Ekranlar

| # | Ekran | Açıklama | Durum |
|---|-------|----------|-------|
| 1 | Gameplay | Zamanlayıcı ekranı (daire + "5.00s" + "Target") — aktif oyun anı | - |
| 2 | Play (Home) | Number picker ile hedef seçme ekranı ("5" seçili + "Play" butonu) | - |
| 3 | Scores | Skor sonuç/detay ekranı | - |
| 4 | Stats | İstatistik ekranı (ortalama, en iyi skor, trendler) | - |
| 5 | Share | Skor paylaşım kartı — 6 renk fan layout | done |
| 6 | Leaderboard | Günlük sıralama tablosu | - |

---

## Kurallar

- Her ekran 10 locale için preview içerir (EN, TR, AR, DE, ES, FR, IT, JA, KO, PT-BR)
- Tüm textler `TextKey` üzerinden — hardcoded string yasak
- Sayılar locale-aware formatlanır (`localeOverride` ile tam locale: `ar_SA`, `de_DE` vs.)
- Her locale'de farklı userName + InitialAvatarView
- Light mode, `.environment(\.colorScheme, .light)`
