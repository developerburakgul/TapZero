# TapZero

> Claude Code proje rehberi — 2026-05-23

---

## Proje

- **Platform:** iOS 17.0+
- **Dil:** Swift / SwiftUI
- **Mimari:** MVVM
- **Async:** Swift Concurrency (async/await)
- **Backend:** Firebase (Auth, Firestore, Remote Config)
- **Monetizasyon:** RevenueCat (Freemium)
- **Analytics:** Firebase Analytics (GA4)
- **DI:** DependencyContainer + @Injected
- **Navigation:** SwiftfulRouting
- **Dependency Manager:** SPM

---

## Klasör Yapısı

```
TapZero/
├── Root/              # App entry, DI, localization
├── Core/              # Manager'lar ve service'ler
├── Modules/           # Feature modülleri (ekran bazlı)
├── Design/            # Renk sistemi, tipografi
├── Components/        # Reusable UI bileşenleri
└── Helpers/           # Property wrapper'lar (@Injected)
```

---

## Kurallar

**Genel**
- Her feature kendi klasöründe, kendi ViewModel'i ile
- God class yasak — bir class bir sorumluluk
- Magic number yasak — constant kullan
- Force unwrap yasak — guard let veya if let kullan

**Naming**
- Screen: `HomeScreen`
- Builder: `HomeBuilder`
- ViewModel: `HomeViewModel`
- Manager: `AuthManager`
- Protocol: `AuthServiceProtocol`
- Model: `UserModel`

**SwiftUI**
- Preview her View'da olmalı
- View'lar 100 satırı geçmesin, alt view'lara parçala
- ViewModel'lar `ObservableObject` + `@StateObject` kullanır
- Manager'lar `ObservableObject` + `@Published private(set)` kullanır

**Git**
- Commit mesajları İngilizce yazılır
- Format: `feat: add user authentication`
- Branch: `feature/login`, `fix/crash-on-launch`
- Commit oluştururken → .claude/skills/commit/SKILL.md

---

## Conventions

- Yeni ekran/modül oluştururken → .claude/conventions/module.md
- Yeni manager/service oluştururken → .claude/conventions/manager.md
- Renk, tipografi veya design token kullanırken → .claude/conventions/design.md
- Analytics event eklerken → .claude/conventions/event.md

---

## Yapılmaması Gerekenler

- UIKit kullanma — her şey SwiftUI
- Singleton kullanma — dependency injection tercih et
- Main thread'i bloklama
- Firestore'a direkt UI'dan yazma — her zaman ViewModel üzerinden
- View'dan Palette'e direkt erişme — Design katmanını kullan
- Manager state'ini ViewModel'da duplicate etme — computed property kullan
