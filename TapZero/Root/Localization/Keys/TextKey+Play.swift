//
//  TextKey+Play.swift
//  TapZero
//

import SwiftUI

extension TextKey {
    enum Play {
        static let title: LocalizedStringKey = "play.title"
        static let greeting: LocalizedStringKey = "play.greeting"
        static let bestLabel: LocalizedStringKey = "play.best.label"
        static let target: LocalizedStringKey = "play.target"
        static let seconds: LocalizedStringKey = "play.seconds"

        static func secondsLabel(count: Int) -> String {
            count == 1
                ? TextKey.localized("play.seconds.one")
                : TextKey.localized("play.seconds.other")
        }
        static let swipeToSelect: LocalizedStringKey = "play.swipeToSelect"
        static let playButton: LocalizedStringKey = "play.button"
    }
}
