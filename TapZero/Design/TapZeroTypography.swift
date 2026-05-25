//
//  TapZeroTypography.swift
//  TapZero
//

import SwiftUI

enum TapZeroTypography {
    // MARK: - Display — Hero, countdown, scores

    enum Display {
        static let large = Font.system(size: 34, weight: .bold)
        static let medium = Font.system(size: 28, weight: .bold)
        static let small = Font.system(size: 24, weight: .bold)

        static let countdown = Font.system(size: 220, weight: .medium)
        static let countdownGo = Font.system(size: 92, weight: .semibold)
        static let score = Font.system(size: 136, weight: .bold)
        static let scoreCompact = Font.system(size: 88, weight: .bold)
        static let numberPicker = Font.system(size: 132, weight: .bold)
        static let numberPickerNear = Font.system(size: 72, weight: .bold)
        static let numberPickerMid = Font.system(size: 48, weight: .bold)
        static let numberPickerFar = Font.system(size: 36, weight: .bold)
        static let profileStat = Font.system(size: 48, weight: .bold)
        static let brandLogo = Font.system(size: 42, weight: .bold)
        static let avatarLetter = Font.system(size: 84, weight: .regular)
    }

    // MARK: - Heading — Page headers, section titles

    enum Heading {
        static let h1 = Font.system(size: 22, weight: .bold)
        static let h2 = Font.system(size: 20, weight: .semibold)
        static let h3 = Font.system(size: 17, weight: .semibold)

        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let pageHeader = Font.system(size: 30, weight: .bold)
        static let sectionTitle = Font.system(size: 28, weight: .bold)
    }

    // MARK: - Body — Content text, list rows

    enum Body {
        static let large = Font.system(size: 17, weight: .regular)
        static let medium = Font.system(size: 15, weight: .regular)
        static let small = Font.system(size: 13, weight: .regular)

        static let nav = Font.system(size: 17, weight: .regular)
        static let primary = Font.system(size: 16, weight: .regular)
        static let listRow = Font.system(size: 15, weight: .medium)
        static let listRowBold = Font.system(size: 15, weight: .bold)
        static let cardLabel = Font.system(size: 15, weight: .medium)
        static let hint = Font.system(size: 14, weight: .medium)
    }

    // MARK: - Label — Buttons, chips, tabs

    enum Label {
        static let large = Font.system(size: 17, weight: .semibold)
        static let medium = Font.system(size: 15, weight: .medium)
        static let small = Font.system(size: 13, weight: .medium)

        static let button = Font.system(size: 16, weight: .semibold)
        static let smallAction = Font.system(size: 14, weight: .semibold)
        static let tab = Font.system(size: 14, weight: .semibold)
        static let chip = Font.system(size: 13, weight: .semibold)
    }

    // MARK: - Caption — Metadata, timestamps, headers

    enum Caption {
        static let regular = Font.system(size: 12, weight: .regular)
        static let medium = Font.system(size: 11, weight: .medium)

        static let subtitle = Font.system(size: 13, weight: .medium)
        static let small = Font.system(size: 12, weight: .medium)
        static let appName = Font.system(size: 12, weight: .bold)
        static let timestamp = Font.system(size: 11, weight: .medium)
        static let rankBadge = Font.system(size: 11, weight: .heavy)
        static let sectionHeader = Font.system(size: 10, weight: .bold)
        static let columnHeader = Font.system(size: 10, weight: .semibold)
        static let helper = Font.system(size: 10, weight: .semibold)
        static let tabBar = Font.system(size: 10, weight: .medium)
    }
}
