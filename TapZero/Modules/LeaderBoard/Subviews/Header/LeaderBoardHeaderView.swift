//
//  LeaderBoardHeaderView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct LeaderBoardHeaderView: View, Equatable {
        let config: LeaderBoardHeaderEntity.Config
        @Binding var selectedTab: LeaderBoardViewModel.LeaderBoardTab
        let constants: Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(TextKey.LeaderBoard.title)
                    .font(TapZeroTypography.Heading.sectionTitle)
                    .tracking(constants.titleTracking)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                segmentedControl
                    .padding(.top, constants.segmentedTopPadding)
            }
            .padding(.horizontal, constants.headerHorizontalPadding)
            .padding(.top, constants.headerTopPadding)
            .padding(.bottom, constants.headerBottomPadding)
        }

        // MARK: - Segmented Control

        private var segmentedControl: some View {
            HStack(spacing: 0) {
                ForEach(LeaderBoardViewModel.LeaderBoardTab.allCases, id: \.rawValue) { tab in
                    segmentButton(for: tab)
                }
            }
            .padding(constants.segmentedPadding)
            .background(TapZeroDesign.SegmentedControl.background)
            .overlay(
                RoundedRectangle(cornerRadius: constants.segmentedCornerRadius)
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: constants.segmentedCornerRadius))
        }

        private func segmentButton(for tab: LeaderBoardViewModel.LeaderBoardTab) -> some View {
            let isActive = config.selectedTab == tab

            return Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = tab
                }
            } label: {
                Text(tab == .global ? TextKey.LeaderBoard.tabGlobal : TextKey.LeaderBoard.tabDaily)
                    .font(TapZeroTypography.Label.tab)
                    .tracking(constants.segmentedTabTracking)
                    .frame(maxWidth: .infinity)
                    .frame(height: constants.segmentedTabHeight)
                    .foregroundStyle(
                        isActive
                            ? TapZeroDesign.SegmentedControl.activeForeground
                            : TapZeroDesign.SegmentedControl.inactiveForeground
                    )
                    .background(
                        isActive
                            ? TapZeroDesign.SegmentedControl.activeBackground
                            : Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: constants.segmentedTabRadius))
                    .shadow(
                        color: isActive ? .black.opacity(0.12) : .clear,
                        radius: 1,
                        y: 1
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Previews

#Preview("Global Selected") {
    @Previewable @State var tab: LeaderBoardViewModel.LeaderBoardTab = .global
    LeaderBoardScreen.LeaderBoardHeaderView(
        config: .init(selectedTab: .global),
        selectedTab: $tab,
        constants: .init()
    )
    .background(TapZeroDesign.Background.primary)
}

#Preview("Daily Selected") {
    @Previewable @State var tab: LeaderBoardViewModel.LeaderBoardTab = .daily
    LeaderBoardScreen.LeaderBoardHeaderView(
        config: .init(selectedTab: .daily),
        selectedTab: $tab,
        constants: .init()
    )
    .background(TapZeroDesign.Background.primary)
}
