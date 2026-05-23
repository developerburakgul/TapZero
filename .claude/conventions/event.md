# Event Naming Convention

> Analytics event isimlendirme standardı.

---

## Format

```
{feature}_{action}_{target}
```

- Her parça **camelCase** yazılır
- Parçalar arasında tek `_` (underscore) ayırıcı kullanılır
- `target` opsiyoneldir (ekran görüntülenmesi gibi durumlarda gerekmez)

---

## Feature (Ekran / Modül)

Modül klasör adlarıyla eşleşir:

| Modül | Feature |
|---|---|
| Splash | `splash` |
| Welcome | `welcome` |
| CreateAccount | `createAccount` |
| EmailAuth | `emailAuth` |
| Onboarding | `onboarding` |
| Tabbar | `tabbar` |
| Home | `home` |
| Favorites | `favorites` |
| Settings | `settings` |

Yeni modül eklendiğinde feature adı modül klasör adının camelCase hali olur.

---

## Action (Fiil)

| Action | Ne zaman |
|---|---|
| `viewed` | Ekran göründüğünde |
| `tapped` | Butona / elemente dokunulduğunda |
| `completed` | Çok adımlı veya async işlem başarıyla bittiğinde |
| `failed` | Hata oluştuğunda |
| `changed` | Ayar / değer değiştirildiğinde |
| `dismissed` | Sheet / alert / modal kapatıldığında |
| `submitted` | Form gönderildiğinde |
| `toggled` | Switch değiştirildiğinde |
| `selected` | Picker / listeden seçim yapıldığında |
| `switched` | Tab / segment değiştirildiğinde |

---

## Örnekler

```
splash_viewed                     → Uygulama açıldı
createAccount_tapped_apple        → Apple ile giriş denedi
createAccount_completed_signIn    → Giriş başarılı
createAccount_failed_signIn       → Giriş başarısız
onboarding_completed_step         → Adım tamamlandı (param: stepNumber)
settings_changed_language         → Dil değiştirdi (param: language)
settings_tapped_signOut           → Çıkış butonuna bastı
settings_completed_signOut        → Çıkış başarılı
tabbar_switched_tab               → Tab değiştirildi (param: tabIndex, tabName)
```

---

## Dashboard Okuma

Event'ler GA4 dashboard'da user flow olarak okunabilmeli:

```
splash_viewed
createAccount_viewed
createAccount_tapped_apple
createAccount_completed_signIn
onboarding_viewed
onboarding_completed_step          (stepNumber: 1)
onboarding_completed_step          (stepNumber: 2)
onboarding_completed_all
home_viewed
```

Bu akış, kullanıcının uygulamayı açıp Apple ile giriş yapıp onboarding'i tamamladığını gösterir.

---

## Kurallar

- GA4 event name limiti: **max 40 karakter**
- Boşluk kullanma (GA4 kabul etmez, sanitizer `_` ile değiştirir)
- Event name'ler ViewModel+Event.swift dosyalarında string olarak yazılır
- Parametreler inline `[String: Any]` dictionary olarak geçilir
- Çağrı her zaman provider üzerinden: `eventManager.ga4.sendEvent(name:parameters:)`
