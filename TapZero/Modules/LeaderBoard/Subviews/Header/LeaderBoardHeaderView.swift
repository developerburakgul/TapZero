//
//  LeaderBoardHeaderView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct LeaderBoardHeaderView: View, Equatable {
        @Binding var binding: LeaderBoardHeaderEntity.Binding
        let config: LeaderBoardHeaderEntity.Config
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
                    binding.selectedTab = tab
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

private struct HeaderPreview: View {
    @State private var entity: LeaderBoardScreen.LeaderBoardHeaderEntity

    init(tab: LeaderBoardViewModel.LeaderBoardTab = .global) {
        _entity = State(initialValue: .init(
            binding: .init(selectedTab: tab),
            config: .init(selectedTab: tab)
        ))
    }

    var body: some View {
        LeaderBoardScreen.LeaderBoardHeaderView(
            binding: $entity.binding,
            config: entity.config,
            constants: .init()
        )
        .onChange(of: entity.binding.selectedTab) { newTab in
            entity.config = .init(selectedTab: newTab)
        }
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("Global Selected") {
    HeaderPreview(tab: .global)
}

#Preview("Daily Selected") {
    HeaderPreview(tab: .daily)
}
