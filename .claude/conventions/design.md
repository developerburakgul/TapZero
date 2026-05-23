# Design System Convention

> Renk ve tipografi kullanım kuralları.

---

## Katmanlı Renk Sistemi

İki katman var — View'larda her zaman **Design** katmanı kullanılır, asla Palette direkt kullanılmaz.

```
Palette (ham hex)  →  Design (semantik)  →  View
```

---

## Renk Kullanımı

### Semantik Renkler — `TapZeroDesign`

View'larda bu renkler kullanılır:

```swift
// Background
TapZeroDesign.Background.primary
TapZeroDesign.Background.secondary
TapZeroDesign.Background.tertiary

// Foreground (text)
TapZeroDesign.Foreground.primary
TapZeroDesign.Foreground.secondary
TapZeroDesign.Foreground.tertiary

// Accent
TapZeroDesign.Accent.primary
TapZeroDesign.Accent.secondary

// System (iOS native)
TapZeroDesign.System.systemRed
TapZeroDesign.System.separator
```

### Feature-Specific Renkler

Her feature kendi enum'ına sahip olabilir:

```swift
TapZeroDesign.ForceUpdate.icon
TapZeroDesign.NetworkStatus.sheetGradientStart
TapZeroDesign.Splash.gradientStart
```

---

## Yeni Renk Ekleme

### 1. Mevcut semantik renk yeterliyse — direkt kullan

```swift
Text("Hello").foregroundStyle(TapZeroDesign.Foreground.primary)
```

### 2. Feature'a özel renk gerekiyorsa — Design'a yeni enum ekle

```swift
// TapZeroDesign.swift içine
enum [FeatureName] {
    @DynamicColor(hexLight: TapZeroPalette.Blue.B500, hexDark: TapZeroPalette.Blue.B400)
    static var icon: Color

    @DynamicColor(hexLight: TapZeroPalette.Blue.B100, hexDark: TapZeroPalette.Neutral.N800)
    static var iconBackground: Color
}
```

### 3. Palette'de olmayan hex gerekiyorsa — önce Palette'e ekle

```swift
// TapZeroPalette.swift içine
enum NewColor {
    static let NC50  = "#..."
    static let NC500 = "#..."
    static let NC900 = "#..."
}
```

---

## @DynamicColor Wrapper Kullanımı

```swift
// Sistem rengi (UIKit → SwiftUI)
@DynamicColor(systemColor: UIColor.systemBackground)
static var primary: Color

// Light/Dark ayrı hex
@DynamicColor(hexLight: TapZeroPalette.Blue.B500, hexDark: TapZeroPalette.Blue.B400)
static var accent: Color

// Tek hex (light = dark)
@DynamicColor(hex: TapZeroPalette.Neutral.N900)
static var solid: Color
```

---

## Palette Yapısı — `TapZeroPalette`

10 renk ailesi, her biri 50-900 skalası (Tailwind CSS):

| Renk | Prefix | Örnek |
|------|--------|-------|
| Red | R | `TapZeroPalette.Red.R500` |
| Orange | O | `TapZeroPalette.Orange.O400` |
| Yellow | Y | `TapZeroPalette.Yellow.Y300` |
| Green | G | `TapZeroPalette.Green.G500` |
| Teal | T | `TapZeroPalette.Teal.T500` |
| Blue | B | `TapZeroPalette.Blue.B500` |
| Indigo | I | `TapZeroPalette.Indigo.I500` |
| Purple | P | `TapZeroPalette.Purple.P500` |
| Pink | PK | `TapZeroPalette.Pink.PK500` |
| Neutral | N | `TapZeroPalette.Neutral.N800` |

Skala: `50` (en açık) → `900` (en koyu)

---

## Typography — `TapZeroTypography`

```swift
// Display — hero, splash
TapZeroTypography.Display.large    // 34pt bold
TapZeroTypography.Display.medium   // 28pt bold
TapZeroTypography.Display.small    // 24pt bold

// Heading — section title, header
TapZeroTypography.Heading.h1       // 22pt bold
TapZeroTypography.Heading.h2       // 20pt semibold
TapZeroTypography.Heading.h3       // 17pt semibold

// Body — content text
TapZeroTypography.Body.large       // 17pt regular
TapZeroTypography.Body.medium      // 15pt regular
TapZeroTypography.Body.small       // 13pt regular

// Label — button, tag, form
TapZeroTypography.Label.large      // 17pt semibold
TapZeroTypography.Label.medium     // 15pt medium
TapZeroTypography.Label.small      // 13pt medium

// Caption — metadata, hint
TapZeroTypography.Caption.regular  // 12pt regular
TapZeroTypography.Caption.medium   // 11pt medium
```

---

## Kurallar

- View'larda asla hardcoded hex veya `Color.red` gibi literal kullanma
- Palette'i View'dan direkt çağırma, her zaman Design katmanından geç
- Light/dark mode desteği `@DynamicColor` ile otomatik
- Feature-specific renkler `TapZeroDesign.[FeatureName].[variant]` pattern'ında
