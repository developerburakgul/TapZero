//
//  FilterSortView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct FilterSortView: View, Equatable {
        @Binding var binding: FilterSortEntity.Binding
        let config: FilterSortEntity.Config
        var onAction: ((Action) -> Void)?
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            HStack(spacing: constants.chipSpacing) {
                targetChip
                sortChip
                Spacer()
                gameCountLabel
            }
            .padding(.horizontal, constants.horizontalPadding)
            .padding(.top, constants.topPadding)
            .padding(.bottom, constants.bottomPadding)
        }

        // MARK: - Target Chip

        private var targetChip: some View {
            let isActive = binding.selectedTarget != nil
            return Menu {
                Button {
                    onAction?(.filterChanged(nil))
                } label: {
                    HStack {
                        Text(String(localized: "history.filter.all"))
                        if binding.selectedTarget == nil {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                ForEach(config.availableTargets, id: \.self) { target in
                    Button {
                        onAction?(.filterChanged(target))
                    } label: {
                        HStack {
                            Text("\(target)s")
                            if binding.selectedTarget == target {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                chipLabel(
                    icon: "scope",
                    text: targetChipText,
                    showChevron: true,
                    isActive: isActive
                )
            }
        }

        private var targetChipText: String {
            if let target = binding.selectedTarget {
                return "\(target)s"
            }
            return String(localized: "history.label.target")
        }

        // MARK: - Sort Chip

        private var sortChip: some View {
            Button {
                let newOrder: FilterSortEntity.SortOrder =
                    binding.sortOrder == .newest ? .best : .newest
                onAction?(.sortChanged(newOrder))
            } label: {
                chipLabel(
                    icon: "arrow.up.arrow.down",
                    text: sortChipText,
                    showChevron: false,
                    isActive: false
                )
            }
            .buttonStyle(.plain)
        }

        private var sortChipText: String {
            binding.sortOrder == .newest
                ? String(localized: "history.sort.newest")
                : String(localized: "history.sort.best")
        }

        // MARK: - Game Count

        private var gameCountLabel: some View {
            Text(TextKey.History.gameCount(config.gameCount))
                .font(.system(size: 12, weight: .semibold))
                .tracking(-0.1)
                .monospacedDigit()
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
        }

        // MARK: - Chip Label

        private func chipLabel(
            icon: String,
            text: String,
            showChevron: Bool,
            isActive: Bool
        ) -> some View {
            HStack(spacing: constants.chipGap) {
                Image(systemName: icon)
                    .font(.system(size: constants.chipIconSize))
                    .opacity(isActive ? 0.75 : 0.55)

                Text(text)
                    .font(.system(size: 13, weight: isActive ? .semibold : .medium))
                    .tracking(-0.1)

                if showChevron {
                    Image(systemName: "chevron.down")
                        .font(.system(size: constants.chevronSize, weight: .medium))
                        .opacity(0.6)
                }
            }
            .foregroundStyle(
                isActive
                    ? Color(hex: TapZeroPalette.Neutral.N50)
                    : TapZeroDesign.Foreground.primary
            )
            .frame(height: constants.chipHeight)
            .padding(.leading, constants.chipHorizontalPadding)
            .padding(
                .trailing,
                showChevron ? constants.chipTrailingPadding : constants.chipHorizontalPadding
            )
            .background(
                isActive
                    ? TapZeroDesign.Foreground.primary
                    : TapZeroDesign.Background.card
            )
            .clipShape(RoundedRectangle(cornerRadius: constants.chipCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.chipCornerRadius)
                    .stroke(
                        isActive ? Color.clear : TapZeroDesign.Hairline.default,
                        lineWidth: 0.5
                    )
            )
        }
    }
}

// MARK: - Action

extension HistoryScreen.FilterSortView {
    enum Action {
        case filterChanged(Int?)
        case sortChanged(HistoryScreen.FilterSortEntity.SortOrder)
    }
}

// MARK: - Previews

private struct FilterSortPreview: View {
    @State private var entity: HistoryScreen.FilterSortEntity

    init(
        selectedTarget: Int? = nil,
        sortOrder: HistoryScreen.FilterSortEntity.SortOrder = .newest
    ) {
        _entity = State(initialValue: .init(
            binding: .init(selectedTarget: selectedTarget, sortOrder: sortOrder),
            config: .init(availableTargets: [3, 5, 7, 10, 15, 20, 30], gameCount: 60)
        ))
    }

    var body: some View {
        HistoryScreen.FilterSortView(
            binding: $entity.binding,
            config: entity.config
        ) { action in
            switch action {
            case .filterChanged(let target):
                entity.binding.selectedTarget = target
            case .sortChanged(let order):
                entity.binding.sortOrder = order
            }
        }
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("FilterSort — Default") {
    FilterSortPreview()
}

#Preview("FilterSort — Active Filter") {
    FilterSortPreview(selectedTarget: 5, sortOrder: .best)
}
