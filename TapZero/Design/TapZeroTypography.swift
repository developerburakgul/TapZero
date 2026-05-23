//
//  TapZeroTypography.swift
//  TapZero
//

import SwiftUI

enum TapZeroTypography {
    // MARK: - Display — Hero sections, splash screen

    enum Display {
        static let large = Font.system(size: 34, weight: .bold, design: .default)
        static let medium = Font.system(size: 28, weight: .bold, design: .default)
        static let small = Font.system(size: 24, weight: .bold, design: .default)
    }

    // MARK: - Heading — Section titles, screen headers

    enum Heading {
        static let h1 = Font.system(size: 22, weight: .bold, design: .default)
        static let h2 = Font.system(size: 20, weight: .semibold, design: .default)
        static let h3 = Font.system(size: 17, weight: .semibold, design: .default)
    }

    // MARK: - Body — Primary content text

    enum Body {
        static let large = Font.system(size: 17, weight: .regular, design: .default)
        static let medium = Font.system(size: 15, weight: .regular, design: .default)
        static let small = Font.system(size: 13, weight: .regular, design: .default)
    }

    // MARK: - Label — Buttons, tags, form labels

    enum Label {
        static let large = Font.system(size: 17, weight: .semibold, design: .default)
        static let medium = Font.system(size: 15, weight: .medium, design: .default)
        static let small = Font.system(size: 13, weight: .medium, design: .default)
    }

    // MARK: - Caption — Metadata, timestamps, hints

    enum Caption {
        static let regular = Font.system(size: 12, weight: .regular, design: .default)
        static let medium = Font.system(size: 11, weight: .medium, design: .default)
    }
}
