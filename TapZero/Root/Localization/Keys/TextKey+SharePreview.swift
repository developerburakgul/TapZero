//
//  TextKey+SharePreview.swift
//  TapZero
//

import SwiftUI

extension TextKey {
    enum SharePreview {
        static func shareText(score: Int) -> String {
            String(format: TextKey.localized("sharePreview.shareText"), score)
        }
    }
}
