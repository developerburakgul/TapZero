//
//  HistoryHeaderView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct HistoryHeaderView: View, Equatable {
        @Binding var binding: HistoryHeaderEntity.Binding
        let config: HistoryHeaderEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(TextKey.History.title)
                    .font(TapZeroTypography.Heading.sectionTitle)
                    .tracking(constants.titleTracking)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                segmentedControl
                    .padding(.top, constants.segmentedTopPadding)
            }
            .padding(.horizontal, constants.horizontalPadding)
            .padding(.top, constants.topPadding)
            .padding(.bottom, constants.bottomPadding)
        }

        // MARK: - Segmented Control

        private var segmentedControl: some View {
            HStack(spacing: 0) {
                ForEach(HistoryViewModel.HistoryTab.allCases, id: \.rawValue) { tab in
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

        private func segmentButton(for tab: HistoryViewModel.HistoryTab) -> some View {
            let isActive = config.selectedTab == tab

            return Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    binding.selectedTab = tab
                }
            } label: {
                Text(tab == .scores ? TextKey.History.tabScores : TextKey.History.tabStats)
                    .font(TapZeroTypography.Label.tab)
                    .tracking(constants.tabTracking)
                    .frame(maxWidth: .infinity)
                    .frame(height: constants.tabHeight)
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
                    .clipShape(RoundedRectangle(cornerRadius: constants.tabRadius))
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
    @State private var entity: HistoryScreen.HistoryHeaderEntity

    init(tab: HistoryViewModel.HistoryTab = .scores) {
        _entity = State(initialValue: .init(
            binding: .init(selectedTab: tab),
            config: .init(selectedTab: tab)
        ))
    }

    var body: some View {
        HistoryScreen.HistoryHeaderView(
            binding: $entity.binding,
            config: entity.config
        )
        .onChange(of: entity.binding.selectedTab) { newTab in
            entity.config = .init(selectedTab: newTab)
        }
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("Scores Selected") {
    HeaderPreview(tab: .scores)
}

#Preview("Stats Selected") {
    HeaderPreview(tab: .stats)
}
