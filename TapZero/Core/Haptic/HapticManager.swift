//
//  HapticManager.swift
//  TapZero
//

import AudioToolbox
import UIKit

enum HapticManager {
    static func pickerTick() {
        AudioServicesPlaySystemSound(1157)
        selection()
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
