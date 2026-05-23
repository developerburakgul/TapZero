//
//  TapZeroDesign.swift
//  Created by __Username__ on __Date__
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
        @DynamicColor(systemColor: UIColor.systemBackground)
        static var primary: Color

        @DynamicColor(systemColor: UIColor.secondarySystemBackground)
        static var secondary: Color

        @DynamicColor(systemColor: UIColor.tertiarySystemBackground)
        static var tertiary: Color
    }

    // MARK: - Foreground

    enum Foreground {
        @DynamicColor(systemColor: UIColor.label)
        static var primary: Color

        @DynamicColor(systemColor: UIColor.secondaryLabel)
        static var secondary: Color

        @DynamicColor(systemColor: UIColor.tertiaryLabel)
        static var tertiary: Color
    }

    // MARK: - Accent

    enum Accent {
        @DynamicColor(hexLight: TapZeroPalette.Blue.B500, hexDark: TapZeroPalette.Blue.B400)
        static var primary: Color

        @DynamicColor(hexLight: TapZeroPalette.Indigo.I500, hexDark: TapZeroPalette.Indigo.I400)
        static var secondary: Color
    }

    // MARK: - Force Update

    enum ForceUpdate {
        @DynamicColor(hexLight: TapZeroPalette.Red.R500, hexDark: TapZeroPalette.Orange.O400)
        static var icon: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R300, hexDark: TapZeroPalette.Orange.O900)
        static var iconBackground: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R500, hexDark: TapZeroPalette.Red.R400)
        static var currentVersion: Color

        @DynamicColor(hexLight: TapZeroPalette.Green.G500, hexDark: TapZeroPalette.Green.G400)
        static var requiredVersion: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R200, hexDark: TapZeroPalette.Neutral.N800)
        static var sheetGradientStart: Color

        @DynamicColor(hexLight: TapZeroPalette.Red.R300, hexDark: TapZeroPalette.Orange.O900)
        static var sheetGradientEnd: Color
    }

    // MARK: - Network Status

    enum NetworkStatus {
        @DynamicColor(hexLight: TapZeroPalette.Orange.O500, hexDark: TapZeroPalette.Orange.O400)
        static var icon: Color

        @DynamicColor(hexLight: TapZeroPalette.Orange.O100, hexDark: TapZeroPalette.Orange.O900)
        static var iconBackground: Color

        @DynamicColor(hexLight: TapZeroPalette.Orange.O50, hexDark: TapZeroPalette.Neutral.N800)
        static var sheetGradientStart: Color

        @DynamicColor(hexLight: TapZeroPalette.Orange.O300, hexDark: TapZeroPalette.Orange.O900)
        static var sheetGradientEnd: Color
    }

    // MARK: - Splash

    enum Splash {
        @DynamicColor(hex: TapZeroPalette.Neutral.N900)
        static var gradientStart: Color

        @DynamicColor(hex: TapZeroPalette.Neutral.N800)
        static var gradientMid: Color

        @DynamicColor(hex: TapZeroPalette.Neutral.N700)
        static var gradientEnd: Color
    }
}
