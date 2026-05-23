//
//  TextKey+Splash.swift
//  Created by __Username__ on __Date__
//

import SwiftUI

extension TextKey {
    enum Splash {
        static let forceUpdateTitle: LocalizedStringKey = "splash.forceUpdate.title"
        static let forceUpdateMessage: LocalizedStringKey = "splash.forceUpdate.message"
        static let forceUpdateButton: LocalizedStringKey = "splash.forceUpdate.button"

        static var forceUpdateTitleValue: String { TextKey.localized("splash.forceUpdate.title") }
        static var forceUpdateMessageValue: String { TextKey.localized("splash.forceUpdate.message") }
        static var forceUpdateButtonValue: String { TextKey.localized("splash.forceUpdate.button") }
    }
}
