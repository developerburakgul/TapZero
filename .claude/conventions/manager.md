# Manager Convention

> Yeni manager/service eklerken izlenecek yapı.

---

## Klasör Yapısı

```
Core/[Name]/
├── [Name]Manager.swift
├── Service/
│   ├── [Name]ServiceProtocol.swift
│   ├── Firebase[Name]Service.swift
│   └── Mock[Name]Service.swift
└── Model/                              (opsiyonel)
    └── [Name]Model.swift
```

---

## Manager

- `@MainActor final class`, `ObservableObject`
- Service'i constructor'dan protocol olarak alır
- Diğer manager'lara `@Injected` ile erişir
- State property'ler `@Published private(set)`

```swift
@MainActor
final class [Name]Manager: ObservableObject {
    private let service: [Name]ServiceProtocol
    @Injected private var crashReporter: CrashReporterProtocol

    @Published private(set) var someState: SomeType?

    init(service: [Name]ServiceProtocol) {
        self.service = service
    }

    func doSomething() async throws {
        let result = try await service.fetchSomething()
        self.someState = result
    }
}
```

---

## Service Protocol

- `@MainActor protocol`, `Sendable`
- Tüm async metodlar `async throws`

```swift
@MainActor
protocol [Name]ServiceProtocol: Sendable {
    func fetchSomething() async throws -> SomeType
    func saveSomething(_ item: SomeType) async throws
}
```

---

## Service Implementations

### Firebase

```swift
@MainActor
final class Firebase[Name]Service: [Name]ServiceProtocol {
    func fetchSomething() async throws -> SomeType {
        // Firebase çağrısı
    }
}
```

### Mock

```swift
@MainActor
final class Mock[Name]Service: [Name]ServiceProtocol {
    var mockData: SomeType?

    init(data: SomeType? = nil) {
        self.mockData = data
    }

    func fetchSomething() async throws -> SomeType {
        guard let data = mockData else { throw MockError.noData }
        return data
    }
}
```

---

## DI Kaydı

`Root/Dependencies.swift` dosyasında her iki metoda da eklenir:

```swift
// registerMockServices
container.register([Name]Manager.self, service: [Name]Manager(
    service: Mock[Name]Service(data: .mock)
))

// registerFirebaseServices
container.register([Name]Manager.self, service: [Name]Manager(
    service: Firebase[Name]Service()
))
```

---

## ViewModel'da Kullanım

```swift
@Injected private(set) var [name]Manager: [Name]Manager
```

---

## Kurallar

- Manager state'i her zaman `@Published private(set)` — dışarıdan sadece okunur
- ViewModel'larda manager state'ini duplicate etme, computed property kullan
- Basit manager'lar (LanguageManager gibi) service layer'ı olmadan da yazılabilir
- Hata yönetimi: `try/catch` + `crashReporter.record(error:)`
