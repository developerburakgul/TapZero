//
//  AppVersion.swift
//  TapZero
//
//  Created by Burak Gül on 18.03.2026.
//

import Foundation

/// Version format: `YY.M.V`
/// - `YY`: Last two digits of the year (e.g., 26 for 2026)
/// - `M`: Month number (e.g., 3 for March)
/// - `V`: Version index within that month (starts at 0)
/// Example: `26.3.0` → 2026, March, first version
struct AppVersion: Comparable, Equatable {
    let year: Int
    let month: Int
    let patch: Int

    var versionString: String {
        "\(year).\(month).\(patch)"
    }

    init?(versionString: String) {
        let components = versionString.split(separator: ".").compactMap { Int($0) }
        guard components.count == 3 else { return nil }
        self.year = components[0]
        self.month = components[1]
        self.patch = components[2]
    }

    static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.year != rhs.year { return lhs.year < rhs.year }
        if lhs.month != rhs.month { return lhs.month < rhs.month }
        return lhs.patch < rhs.patch
    }
}
