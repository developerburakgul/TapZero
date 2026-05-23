//
//  Injected.swift
//  TapZero
//
//  Created by Burak Gül on 12.03.2026.
//

import Foundation
import DependencyContainer

@MainActor
@propertyWrapper
struct Injected<T> {
    var wrappedValue: T

    init() {
        self.wrappedValue = Dependencies.shared.container.resolve(T.self)!
    }
}
