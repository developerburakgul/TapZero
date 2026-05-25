//
//  TapZeroDesign.swift
//  TapZero
//

import DynamicColor
import SwiftUI
import UIKit

// Uygulama genelinde kullanılan renk tanımları

enum TapZeroDesign {
    // MARK: - System — iOS sistem renkleri, değiştirilmemeli

    enum System {
        @DynamicColor(systemColor: UIColor.systemBackground)
        static var systemBackground: Color

        @DynamicColor(systemColor: UIColor.secondarySystemBackground)
        static var secondarySystemBackground: Color

        @DynamicColor(systemColor: UIColor.tertiarySystemBackground)
        static var tertiarySystemBackground: Color

        @DynamicColor(systemColor: UIColor.systemGroupedBackground)
        static var systemGroupedBackground: Color

        @DynamicColor(systemColor: UIColor.secondarySystemGroupedBackground)
        static var secondarySystemGroupedBackground: Color

        @DynamicColor(systemColor: UIColor.tertiarySystemGroupedBackground)
        static var tertiarySystemGroupedBackground: Color

        @DynamicColor(systemColor: UIColor.label)
        static var label: Color

        @DynamicColor(systemColor: UIColor.secondaryLabel)
        static var secondaryLabel: Color

        @DynamicColor(systemColor: UIColor.tertiaryLabel)
        static var tertiaryLabel: Color

        @DynamicColor(systemColor: UIColor.quaternaryLabel)
        static var quaternaryLabel: Color

        @DynamicColor(systemColor: UIColor.placeholderText)
        static var placeholderText: Color

        @DynamicColor(systemColor: UIColor.separator)
        static var separator: Color

        @DynamicColor(systemColor: UIColor.opaqueSeparator)
        static var opaqueSeparator: Color

        @DynamicColor(systemColor: UIColor.systemFill)
        static var systemFill: Color

        @DynamicColor(systemColor: UIColor.secondarySystemFill)
        static var secondarySystemFill: Color

        @DynamicColor(systemColor: UIColor.tertiarySystemFill)
        static var tertiarySystemFill: Color

        @DynamicColor(systemColor: UIColor.quaternarySystemFill)
        static var quaternarySystemFill: Color

        @DynamicColor(systemColor: UIColor.link)
        static var link: Color

        @DynamicColor(systemColor: UIColor.systemBlue)
        static var systemBlue: Color

        @DynamicColor(systemColor: UIColor.systemGreen)
        static var systemGreen: Color

        @DynamicColor(systemColor: UIColor.systemRed)
        static var systemRed: Color

        @DynamicColor(systemColor: UIColor.systemOrange)
        static var systemOrange: Color

        @DynamicColor(systemColor: UIColor.systemYellow)
        static var systemYellow: Color

        @DynamicColor(systemColor: UIColor.systemPurple)
        static var systemPurple: Color

        @DynamicColor(systemColor: UIColor.systemPink)
        static var systemPink: Color

        @DynamicColor(systemColor: UIColor.systemTeal)
        static var systemTeal: Color

        @DynamicColor(systemColor: UIColor.systemIndigo)
        static var systemIndigo: Color

        @DynamicColor(systemColor: UIColor.systemMint)
        static var systemMint: Color

        @DynamicColor(systemColor: UIColor.systemCyan)
        static var systemCyan: Color

        @DynamicColor(systemColor: UIColor.systemBrown)
        static var systemBrown: Color

        @DynamicColor(systemColor: UIColor.systemGray)
        static var systemGray: Color

        @DynamicColor(systemColor: UIColor.systemGray2)
        static var systemGray2: Color

        @DynamicColor(systemColor: UIColor.systemGray3)
        static var systemGray3: Color

        @DynamicColor(systemColor: UIColor.systemGray4)
        static var systemGray4: Color

        @DynamicColor(systemColor: UIColor.systemGray5)
        static var systemGray5: Color

        @DynamicColor(systemColor: UIColor.systemGray6)
        static var systemGray6: Color
    }

    // MARK: - Background

    enum Background {
        @DynamicColor(hexLight: TapZeroPalette.Neutral.N50, hexDark: TapZeroPalette.Neutral.N900)
        static var primary: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N250, hexDark: TapZeroPalette.Neutral.N820)
        static var secondary: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N150, hexDark: TapZeroPalette.Neutral.N800)
        static var tertiary: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N0, hexDark: TapZeroPalette.Neutral.N840)
        static var card: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N100, hexDark: TapZeroPalette.Neutral.N860)
        static var surface: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N300, hexDark: TapZeroPalette.Neutral.N750)
        static var disabled: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N0, hexDark: TapZeroPalette.Neutral.N880)
        static var settings: Color
    }

    // MARK: - Foreground

    enum Foreground {
        @DynamicColor(hexLight: TapZeroPalette.Neutral.N900, hexDark: TapZeroPalette.Neutral.N50)
        static var primary: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N600),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.6)
        )
        static var secondary: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N500),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.35)
        )
        static var tertiary: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N700),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.7)
        )
        static var muted: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N400, hexDark: TapZeroPalette.Neutral.N600)
        static var disabled: Color
    }

    // MARK: - Accent

    enum Accent {
        @DynamicColor(hexLight: TapZeroPalette.Neutral.N900, hexDark: TapZeroPalette.Neutral.N50)
        static var primary: Color

        @DynamicColor(hexLight: TapZeroPalette.Green.G600, hexDark: TapZeroPalette.Green.G600)
        static var secondary: Color
    }

    // MARK: - Hairline

    enum Hairline {
        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N900).withAlphaComponent(0.08),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.08)
        )
        static var `default`: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N900).withAlphaComponent(0.05),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.05)
        )
        static var subtle: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N900).withAlphaComponent(0.10),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.10)
        )
        static var medium: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N900).withAlphaComponent(0.15),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.15)
        )
        static var strong: Color
    }

    // MARK: - Button

    enum Button {
        @DynamicColor(hexLight: TapZeroPalette.Neutral.N900, hexDark: TapZeroPalette.Neutral.N50)
        static var primaryBackground: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N50, hexDark: TapZeroPalette.Neutral.N900)
        static var primaryForeground: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N300, hexDark: TapZeroPalette.Neutral.N750)
        static var disabledBackground: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N400, hexDark: TapZeroPalette.Neutral.N600)
        static var disabledForeground: Color
    }

    // MARK: - SegmentedControl

    enum SegmentedControl {
        @DynamicColor(hexLight: TapZeroPalette.Neutral.N250, hexDark: TapZeroPalette.Neutral.N820)
        static var background: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N900, hexDark: TapZeroPalette.Neutral.N50)
        static var activeBackground: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N50, hexDark: TapZeroPalette.Neutral.N900)
        static var activeForeground: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N600),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.6)
        )
        static var inactiveForeground: Color
    }

    // MARK: - Glass

    enum Glass {
        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N0).withAlphaComponent(0.5),
            uiColorDark: UIColor(hex: "#787880").withAlphaComponent(0.28)
        )
        static var pill: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.92),
            uiColorDark: UIColor(hex: "#141416").withAlphaComponent(0.78)
        )
        static var tabBar: Color
    }

    // MARK: - Status

    enum Status {
        @DynamicColor(hex: TapZeroPalette.Green.G600)
        static var good: Color

        @DynamicColor(hex: TapZeroPalette.Yellow.Y500)
        static var warn: Color

        @DynamicColor(hex: TapZeroPalette.Red.R500)
        static var bad: Color

        @DynamicColor(hexLight: TapZeroPalette.Green.G50, hexDark: TapZeroPalette.Green.G900)
        static var goodSoft: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R50, hexDark: TapZeroPalette.Red.R900)
        static var badSoft: Color
    }

    // MARK: - Medal

    enum Medal {
        @DynamicColor(hex: TapZeroPalette.Yellow.Y400)
        static var gold: Color

        @DynamicColor(hex: TapZeroPalette.Yellow.Y600)
        static var goldAccent: Color

        @DynamicColor(hex: TapZeroPalette.Silver.SV400)
        static var silver: Color

        @DynamicColor(hex: TapZeroPalette.Bronze.BZ500)
        static var bronze: Color
    }

    // MARK: - Score

    enum Score {
        @DynamicColor(hexLight: TapZeroPalette.Neutral.N0, hexDark: TapZeroPalette.Neutral.N840)
        static var cardBackground: Color

        @DynamicColor(hex: TapZeroPalette.Green.G600)
        static var perfectAccent: Color

        @DynamicColor(hexLight: TapZeroPalette.Green.G50, hexDark: TapZeroPalette.Green.G900)
        static var goodBackground: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R50, hexDark: TapZeroPalette.Red.R900)
        static var badBackground: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N900).withAlphaComponent(0.06),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.06)
        )
        static var neutralBackground: Color
    }

    // MARK: - Toggle

    enum Toggle {
        @DynamicColor(hex: TapZeroPalette.Green.G600)
        static var on: Color

        @DynamicColor(
            uiColorLight: UIColor(hex: TapZeroPalette.Neutral.N900).withAlphaComponent(0.15),
            uiColorDark: UIColor(hex: TapZeroPalette.Neutral.N50).withAlphaComponent(0.18)
        )
        static var offTrack: Color

        @DynamicColor(hex: TapZeroPalette.Neutral.N0)
        static var thumb: Color
    }

    // MARK: - Force Update

    enum ForceUpdate {
        @DynamicColor(hexLight: TapZeroPalette.Red.R500, hexDark: TapZeroPalette.Red.R500)
        static var icon: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R50, hexDark: TapZeroPalette.Red.R900)
        static var iconBackground: Color

        @DynamicColor(hex: TapZeroPalette.Red.R500)
        static var currentVersion: Color

        @DynamicColor(hex: TapZeroPalette.Green.G600)
        static var requiredVersion: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R50, hexDark: TapZeroPalette.Neutral.N800)
        static var sheetGradientStart: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R50, hexDark: TapZeroPalette.Red.R900)
        static var sheetGradientEnd: Color
    }

    // MARK: - Network Status

    enum NetworkStatus {
        @DynamicColor(hex: TapZeroPalette.Yellow.Y500)
        static var icon: Color

        @DynamicColor(hexLight: TapZeroPalette.Yellow.Y400, hexDark: TapZeroPalette.Yellow.Y600)
        static var iconBackground: Color

        @DynamicColor(hexLight: TapZeroPalette.Neutral.N100, hexDark: TapZeroPalette.Neutral.N800)
        static var sheetGradientStart: Color

        @DynamicColor(hexLight: TapZeroPalette.Yellow.Y400, hexDark: TapZeroPalette.Yellow.Y600)
        static var sheetGradientEnd: Color
    }

    // MARK: - Splash

    enum Splash {
        @DynamicColor(hex: TapZeroPalette.Neutral.N900)
        static var gradientStart: Color

        @DynamicColor(hex: TapZeroPalette.Neutral.N840)
        static var gradientMid: Color

        @DynamicColor(hex: TapZeroPalette.Neutral.N800)
        static var gradientEnd: Color
    }
}
