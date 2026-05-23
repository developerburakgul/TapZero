//
//  CreateAccountEntity.swift
//  TapZero
//

import Foundation

struct CreateAccountEntity: Sendable {
    let showGuestOption: Bool
    let dismissOnComplete: Bool
    let isSignIn: Bool

    let displayName: String

    init(
        showGuestOption: Bool = true,
        dismissOnComplete: Bool = false,
        isSignIn: Bool = false,
        displayName: String = ""
    ) {
        self.showGuestOption = showGuestOption
        self.dismissOnComplete = dismissOnComplete
        self.isSignIn = isSignIn
        self.displayName = displayName
    }
}
