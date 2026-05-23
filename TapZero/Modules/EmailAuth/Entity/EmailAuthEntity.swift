//
//  EmailAuthEntity.swift
//  TapZero
//

import Foundation

struct EmailAuthEntity: Sendable {
    let isSignIn: Bool

    init(isSignIn: Bool = false) {
        self.isSignIn = isSignIn
    }
}
