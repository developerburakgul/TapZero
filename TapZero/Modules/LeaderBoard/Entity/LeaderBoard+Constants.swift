//
//  LeaderBoard+Constants.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct Constants {
        // MARK: - Header
        let headerHorizontalPadding: CGFloat = 20
        let headerTopPadding: CGFloat = 12
        let headerBottomPadding: CGFloat = 12
        let titleTracking: CGFloat = -0.8
        let segmentedTopPadding: CGFloat = 14
        let segmentedCornerRadius: CGFloat = 14
        let segmentedPadding: CGFloat = 4
        let segmentedTabHeight: CGFloat = 36
        let segmentedTabRadius: CGFloat = 11
        let segmentedTabTracking: CGFloat = -0.2

        // MARK: - Podium
        let podiumHorizontalPadding: CGFloat = 8
        let podiumTopPadding: CGFloat = 6
        let podiumBottomPadding: CGFloat = 18
        let podiumInnerPaddingH: CGFloat = 8
        let podiumInnerPaddingV: CGFloat = 14
        let podiumFirstAvatarSize: CGFloat = 84
        let podiumOtherAvatarSize: CGFloat = 64
        let podiumOtherTopOffset: CGFloat = 28
        let podiumAvatarBorderWidth: CGFloat = 2
        let podiumCrownWidth: CGFloat = 32
        let podiumCrownHeight: CGFloat = 25
        let podiumRibbonWidth: CGFloat = 46
        let podiumRibbonHeight: CGFloat = 26
        let podiumRibbonOverlap: CGFloat = -12
        let podiumNameMaxWidth: CGFloat = 100
        let podiumFirstNameSize: CGFloat = 14
        let podiumOtherNameSize: CGFloat = 13
        let podiumPointsSize: CGFloat = 13
        let podiumNameToPointsSpacing: CGFloat = 1
        let podiumAvatarToNameSpacing: CGFloat = 8
        let podiumMonogramFontRatio: CGFloat = 0.38

        // MARK: - Row
        let rowGap: CGFloat = 12
        let rowPaddingH: CGFloat = 12
        let rowPaddingV: CGFloat = 11
        let rowDensePaddingV: CGFloat = 9
        let rowCornerRadius: CGFloat = 14
        let rowMarginBottom: CGFloat = 6
        let rowRankWidth: CGFloat = 24
        let rowAvatarSize: CGFloat = 38
        let rowUserBorderWidth: CGFloat = 1.5
        let rowNameTracking: CGFloat = -0.2
        let rowScoreTracking: CGFloat = -0.3

        // MARK: - Sticky Bar
        let stickyPaddingH: CGFloat = 16
        let stickyPaddingTop: CGFloat = 12
        let stickyPaddingBottom: CGFloat = 14
        let stickyHeaderTracking: CGFloat = 1.4
        let stickyHeaderBottomSpacing: CGFloat = 8

        // MARK: - Locked Overlay
        let lockedCardRadius: CGFloat = 22
        let lockedCardPaddingH: CGFloat = 22
        let lockedCardPaddingV: CGFloat = 24
        let lockedProgressSize: CGFloat = 56
        let lockedProgressStrokeWidth: CGFloat = 3
        let lockedDividerMarginH: CGFloat = -22
        let lockedCtaHeight: CGFloat = 50
        let lockedCtaRadius: CGFloat = 14

        // MARK: - Daily Timer
        let dailyClockSize: CGFloat = 12

        // MARK: - Misc
        let listHorizontalPadding: CGFloat = 8
        let unlockRequiredGames: Int = 10
        let leaderboardListLimit: Int = 50
    }
}
