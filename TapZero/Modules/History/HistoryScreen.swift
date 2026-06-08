//
//  HistoryScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct HistoryScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: HistoryViewModel

    var body: some View {
        contentView
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
            .onChange(of: viewModel.headerEntity.binding.selectedTab) { newTab in
                viewModel.onTabChanged(newTab)
            }
            .onChange(of: viewModel.selectedTab) { newTab in
                viewModel.headerEntity.binding.selectedTab = newTab
                viewModel.headerEntity.config = .init(selectedTab: newTab)
            }
    }

    private var contentView: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            historyContent
        }
    }
}

// MARK: - History Content

extension HistoryScreen {
    private var historyContent: some View {
        VStack(spacing: 0) {
            HistoryHeaderView(
                binding: $viewModel.headerEntity.binding,
                config: viewModel.headerEntity.config
            )

            TabView(selection: $viewModel.headerEntity.binding.selectedTab) {
                scoresPage.tag(HistoryViewModel.HistoryTab.scores)
                statsPage.tag(HistoryViewModel.HistoryTab.stats)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.25), value: viewModel.headerEntity.binding.selectedTab)
        }
    }
}

// MARK: - Scores Page

extension HistoryScreen {
    private var scoresPage: some View {
        ZStack {
            scoresScrollContent
                .blur(radius: viewModel.isEmpty ? 8 : 0)
                .opacity(viewModel.isEmpty ? 0.55 : 1)
                .disabled(viewModel.isEmpty)

            if viewModel.isEmpty {
                EmptyOverlayView(
                    binding: $viewModel.emptyOverlayEntity.binding,
                    config: viewModel.emptyOverlayEntity.config
                ) { action in
                    switch action {
                    case .didTapPlayGame:
                        viewModel.onPlayGameTapped()
                    }
                }
            }
        }
        .opacity(viewModel.isLoading ? 0 : 1)
    }

    private var scoresScrollContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                ScoreChartView(
                    binding: $viewModel.scoreChartEntity.binding,
                    config: viewModel.scoreChartEntity.config
                )

                FilterSortView(
                    binding: $viewModel.filterSortEntity.binding,
                    config: viewModel.filterSortEntity.config
                ) { action in
                    switch action {
                    case .filterChanged(let target):
                        viewModel.onFilterTargetChanged(target)
                    case .sortChanged(let order):
                        viewModel.onSortOrderChanged(order)
                    }
                }

                scoreList
            }
        }
    }

    private var scoreList: some View {
        LazyVStack(spacing: 6) {
            ForEach(viewModel.scoreRows) { row in
                ScoreRowView(
                    binding: .constant(.init()),
                    config: row
                )
            }
        }
        .padding(.horizontal, constants.horizontalPadding)
    }
}

// MARK: - Stats Page

extension HistoryScreen {
    private var statsPage: some View {
        ZStack {
            statsScrollContent
                .blur(radius: viewModel.isEmpty ? 8 : 0)
                .opacity(viewModel.isEmpty ? 0.55 : 1)
                .disabled(viewModel.isEmpty)

            if viewModel.isEmpty {
                EmptyOverlayView(
                    binding: $viewModel.emptyOverlayEntity.binding,
                    config: viewModel.emptyOverlayEntity.config
                ) { action in
                    switch action {
                    case .didTapPlayGame:
                        viewModel.onPlayGameTapped()
                    }
                }
            }
        }
        .opacity(viewModel.isLoading ? 0 : 1)
    }

    private var statsScrollContent: some View {
        ScrollView {
            VStack(spacing: constants.statsSpacing) {
                HeroStatView(
                    binding: $viewModel.heroStatEntity.binding,
                    config: viewModel.heroStatEntity.config
                )

                KPIGridView(
                    binding: $viewModel.kpiGridEntity.binding,
                    config: viewModel.kpiGridEntity.config
                )

                DistributionView(
                    binding: $viewModel.distributionEntity.binding,
                    config: viewModel.distributionEntity.config
                )

                TargetsPlayedView(
                    binding: $viewModel.targetsPlayedEntity.binding,
                    config: viewModel.targetsPlayedEntity.config
                )

                StreakHeatmapView(
                    binding: $viewModel.streakHeatmapEntity.binding,
                    config: viewModel.streakHeatmapEntity.config
                )
            }
            .padding(.horizontal, constants.horizontalPadding)
            .padding(.bottom, constants.bottomPadding)
        }
    }
}
