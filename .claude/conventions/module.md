# Module Convention

> Yeni ekran/modül eklerken izlenecek MVVM yapısı.

---

## Klasör Yapısı

```
Modules/[Name]/
├── [Name]Screen.swift
├── [Name]Builder.swift
├── Entity/
│   └── [Name]Entity.swift
├── ViewModel/
│   ├── [Name]ViewModel.swift
│   ├── [Name]ViewModel+Action.swift
│   ├── [Name]ViewModel+Service.swift
│   ├── [Name]ViewModel+Configure.swift
│   ├── [Name]ViewModel+Event.swift
│   └── [Name]ViewModel+Validator.swift   (opsiyonel)
└── Subviews/                              (opsiyonel)
```

---

## Screen

- `@StateObject` ile ViewModel tutar
- `.task` modifier ile lifecycle yönetimi: `viewDidLoad` (ilk appear) + `viewWillAppear` (her appear)
- `Constants()` struct'ı screen-specific sabitler için
- Background: `TapZeroDesign.Background.primary.ignoresSafeArea()`
- Text: `TextKey.[Module].[key]` ile localized string

```swift
struct [Name]Screen: View {
    private let constants = Constants()
    @StateObject var viewModel: [Name]ViewModel

    var body: some View {
        contentView
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
    }
}
```

---

## Builder

- `@MainActor enum` — instance oluşturulamaz
- `Router` ve opsiyonel `Entity` alır
- ViewModel'i oluşturup Screen'e inject eder

```swift
@MainActor
enum [Name]Builder {
    static func build(
        router: Router,
        entity: [Name]Entity = [Name]Entity()
    ) -> some View {
        [Name]Screen(
            viewModel: [Name]ViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
```

---

## ViewModel

- `@MainActor final class`, `ObservableObject`
- MARK bölümleri: Non-Published → Managers → Published → Subview Entities → Init
- Manager'lar `@Injected private(set)` ile inject edilir
- `router` ve `entity` constructor'dan gelir

```swift
@MainActor
final class [Name]ViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: [Name]Entity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties

    // MARK: - Subview Entities

    // MARK: - Init
    init(router: Router, entity: [Name]Entity) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension [Name]ViewModel {
}
```

---

## ViewModel Extension'ları

### +Action — Lifecycle ve kullanıcı etkileşimleri

```swift
extension [Name]ViewModel {
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    func sendInitialRequests() async {
        await withTaskGroup { group in
            group.addTask { await self.fetchData() }
        }
    }
}
```

### +Service — API/data çağrıları

```swift
extension [Name]ViewModel {
    func fetchData() async { }
}
```

### +Configure — Her appear'da çalışan setup

```swift
extension [Name]ViewModel {
    func configure() { }
}
```

### +Event — Analytics

```swift
extension [Name]ViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "[name]_viewed", parameters: [:])
        }
    }
}
```

---

## Entity ve Constants

```swift
struct [Name]Entity: Sendable { }

extension [Name]Screen {
    struct Constants { }
}
```

---

## Preview

```swift
#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "[name]", addModuleSupport: true) { router in
        [Name]Builder.build(router: router)
    }
}
```
