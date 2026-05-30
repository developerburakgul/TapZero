//
//  ObservedInjected.swift
//  TapZero
//

import Combine
import DependencyContainer
import Foundation

@MainActor
@propertyWrapper
final class ObservedInjected<T: ObservableObject> {
    private var cancellable: AnyCancellable?
    private let value: T

    init() {
        // swiftlint:disable:next force_unwrapping
        self.value = Dependencies.shared.container.resolve(T.self)!
    }

    // MARK: - Direct access (fallback)

    var wrappedValue: T {
        get { value }
        // swiftlint:disable:next unused_setter_value
        set { }
    }

    // MARK: - Enclosing instance access (auto-subscribe)

    static subscript<Owner: ObservableObject>(
        _enclosingInstance instance: Owner,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Owner, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<Owner, ObservedInjected>
    ) -> T {
        get {
            let wrapper = instance[keyPath: storageKeyPath]
            if wrapper.cancellable == nil {
                wrapper.cancellable = wrapper.value.objectWillChange
                    .sink { [weak instance] _ in
                        (instance?.objectWillChange as? ObservableObjectPublisher)?.send()
                    }
            }
            return wrapper.value
        }
        // swiftlint:disable:next unused_setter_value
        set { }
    }
}
