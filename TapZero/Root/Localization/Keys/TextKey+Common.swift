//
//  TextKey+Common.swift
//  TapZero
//

import SwiftUI

extension TextKey {
    enum Common {
        static var errorTitle: String { TextKey.localized("common.error.title") }
        static var ok: String { TextKey.localized("common.ok") }
        static let okKey: LocalizedStringKey = "common.ok"
    }
}
