//
//  LeaderBoardScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct LeaderBoardScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: LeaderBoardViewModel

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
            leaderboardContent
        }
    }
}

// MARK: - Leaderboard Content

extension LeaderBoardScreen {
    private var leaderboardContent: some View {
        VStack(spacing: 0) {
            LeaderBoardHeaderView(
                binding: $viewModel.headerEntity.binding,
                config: viewModel.headerEntity.config
            )

            TabView(selection: $viewModel.headerEntity.binding.selectedTab) {
                globalPage.tag(LeaderBoardViewModel.LeaderBoardTab.global)
                dailyPage.tag(LeaderBoardViewModel.LeaderBoardTab.daily)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.25), value: viewModel.headerEntity.binding.selectedTab)
        }
        .overlay(alignment: .bottom) {
            if viewModel.showStickyBar {
                StickyBarView(
                    binding: $viewModel.stickyBarEntity.binding,
                    config: viewModel.stickyBarEntity.config
                )
            }
        }
    }
}

// MARK: - Pages

extension LeaderBoardScreen {
    private var globalPage: some View {
        ZStack {
            if viewModel.isGlobalEmpty && !viewModel.isLocked {
                globalEmptyView
            } else {
                globalScrollContent
            }

            if viewModel.isLocked {
                LockedOverlayView(
                    binding: $viewModel.lockedOverlayEntity.binding,
                    config: viewModel.lockedOverlayEntity.config
                ) { action in
                    switch action {
                    case .didTapPlayGame:
                        viewModel.onPlayGameTapped()
                    }
                }
            }
        }
    }

    private var globalScrollContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                globalPodium
                if viewModel.showYourSpotRow {
                    YourSpotRowView(
                        binding: $viewModel.yourSpotEntity.binding,
                        config: viewModel.yourSpotEntity.config
                    )
                }
                globalList
            }
            .padding(.bottom, viewModel.showStickyBar ? 100 : 0)
        }
        .blur(radius: viewModel.isLocked ? 8 : 0)
        .opacity(viewModel.isLocked ? 0.55 : 1)
        .disabled(viewModel.isLocked)
    }

    private var globalEmptyView: some View {
        EmptyStateView(
            binding: $viewModel.globalEmptyEntity.binding,
            config: viewModel.globalEmptyEntity.config
        ) { action in
            switch action {
            case .didTapPlayGame:
                viewModel.onPlayGameTapped()
            }
        }
    }

    @ViewBuilder
    private var dailyPage: some View {
        if viewModel.isDailyEmpty {
            VStack(spacing: 0) {
                dailyResetTimer
                EmptyStateView(
                    binding: $viewModel.dailyEmptyEntity.binding,
                    config: viewModel.dailyEmptyEntity.config
                ) { action in
                    switch action {
                    case .didTapPlayGame:
                        viewModel.onPlayGameTapped()
                    }
                }
            }
        } else {
            ScrollView {
                VStack(spacing: 0) {
                    dailyResetTimer
                    dailyPodiumSection
                    if viewModel.showYourSpotRow {
                        YourSpotRowView(
                            binding: $viewModel.yourSpotEntity.binding,
                            config: viewModel.yourSpotEntity.config
                        )
                    }
                    dailyList
                }
            }
        }
    }
}

// MARK: - Global Content

extension LeaderBoardScreen {
    private var globalPodium: some View {
        PodiumView(
            binding: $viewModel.globalPodiumEntity.binding,
            config: viewModel.globalPodiumEntity.config
        )
    }

    private var globalList: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(viewModel.globalList) { entry in
                globalRow(entry: entry)
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private func globalRow(entry: GlobalLeaderboardEntry) -> some View {
        LeaderBoardRowView(
            binding: .constant(.init()),
            config: .init(
                rank: entry.rank,
                name: entry.name,
                score: entry.top10Average,
                avatarURL: entry.avatar,
                avatarColor: viewModel.avatarColor(colorHex: nil),
                isCurrentUser: entry.userId == viewModel.currentUserId,
                isDense: false
            )
        )
    }
}

// MARK: - Daily Content

extension LeaderBoardScreen {
    private var dailyPodiumSection: some View {
        PodiumView(
            binding: $viewModel.dailyPodiumEntity.binding,
            config: viewModel.dailyPodiumEntity.config
        )
    }

    private var dailyList: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(viewModel.dailyList) { entry in
                dailyRow(entry: entry)
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private func dailyRow(entry: DailyLeaderboardEntry) -> some View {
        LeaderBoardRowView(
            binding: .constant(.init()),
            config: .init(
                rank: entry.rank,
                name: entry.name,
                score: entry.bestScore,
                avatarURL: entry.avatar,
                avatarColor: viewModel.avatarColor(colorHex: nil),
                isCurrentUser: entry.userId == viewModel.currentUserId,
                isDense: false
            )
        )
    }
}

// MARK: - Daily Reset Timer

extension LeaderBoardScreen {
    private var dailyResetTimer: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.system(size: constants.dailyClockSize))
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)

            Text(dailyTimerText)
                .font(TapZeroTypography.Caption.regular)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    private var dailyTimerText: String {
        let remaining = viewModel.dailyResetTimeRemaining
        let resetsAt = TextKey.LeaderBoard.dailyResetsAt
        let timeLeft = TextKey.LeaderBoard.dailyTimeLeft(
            hours: remaining.hours,
            minutes: remaining.minutes
        )
        return "\(resetsAt) · \(timeLeft)"
    }
}
