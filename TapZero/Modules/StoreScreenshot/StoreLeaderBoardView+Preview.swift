//
//  StoreLeaderBoardView+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - LeaderBoard Showcase

private struct StoreLeaderBoardShowcase: View {
    let localeData: StoreLocaleData

    @State private var selectedTab: LeaderBoardViewModel.LeaderBoardTab = .global
    private let constants = LeaderBoardScreen.Constants()

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                scrollContent
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        LeaderBoardScreen.LeaderBoardHeaderView(
            binding: .constant(.init(selectedTab: selectedTab)),
            config: .init(selectedTab: selectedTab)
        )
    }

    // MARK: - Content

    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                podium
                list
            }
        }
    }

    // MARK: - Podium

    private var podium: some View {
        LeaderBoardScreen.PodiumView(
            binding: .constant(.init()),
            config: .init(entries: podiumEntries)
        )
    }

    private func makePodiumEntry(
        rank: Int, name: String, score: Int
    ) -> LeaderBoardScreen.PodiumEntity.PodiumEntry {
        let medal: Color = switch rank {
        case 1: TapZeroDesign.Medal.gold
        case 2: TapZeroDesign.Medal.silver
        default: TapZeroDesign.Medal.bronze
        }
        let ribbon: Color = rank == 3
            ? Color(hex: TapZeroPalette.Neutral.N50)
            : TapZeroDesign.Foreground.primary
        let pastel = TapZeroPalette.Pastel.all[
            rank % TapZeroPalette.Pastel.all.count
        ]
        return .init(
            rank: rank, name: name, score: score,
            avatarURL: nil, avatarColor: Color(hex: pastel),
            medalColor: medal, ribbonTextColor: ribbon
        )
    }

    private var podiumEntries: [LeaderBoardScreen.PodiumEntity.PodiumEntry] {
        [
            makePodiumEntry(rank: 1, name: "Mira Stone", score: 984),
            makePodiumEntry(rank: 2, name: "Kenji Park", score: 971),
            makePodiumEntry(rank: 3, name: "Yuna Choi", score: 958)
        ]
    }

    // MARK: - List

    private func makeRowConfig(
        rank: Int, name: String, score: Int, isUser: Bool
    ) -> LeaderBoardScreen.LeaderBoardRowEntity.Config {
        .init(
            rank: rank, name: name, score: score,
            avatarURL: nil,
            avatarColor: isUser
                ? Color(hex: "#007AFF")
                : TapZeroDesign.Foreground.tertiary,
            isCurrentUser: isUser,
            isDense: false
        )
    }

    private var listRows: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        [
            makeRowConfig(rank: 4, name: "Liam Carter", score: 932, isUser: false),
            makeRowConfig(rank: 5, name: "Sofia Rossi", score: 918, isUser: false),
            makeRowConfig(rank: 6, name: "Noah Kim", score: 904, isUser: false),
            makeRowConfig(rank: 7, name: localeData.userName, score: 891, isUser: true),
            makeRowConfig(rank: 8, name: "Emma Liu", score: 876, isUser: false),
            makeRowConfig(rank: 9, name: "Raj Patel", score: 854, isUser: false),
            makeRowConfig(rank: 10, name: "Ava Chen", score: 837, isUser: false)
        ]
    }

    private var list: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(listRows) { entry in
                LeaderBoardScreen.LeaderBoardRowView(
                    binding: .constant(.init()),
                    config: entry
                )
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }
}

// MARK: - Previews (10 Locales)

#Preview("Store LeaderBoard — EN") {
    StoreLocalePreview(storeLocales[0]) { StoreLeaderBoardShowcase(localeData: storeLocales[0]) }
}
#Preview("Store LeaderBoard — TR") {
    StoreLocalePreview(storeLocales[1]) { StoreLeaderBoardShowcase(localeData: storeLocales[1]) }
}
#Preview("Store LeaderBoard — AR") {
    StoreLocalePreview(storeLocales[2]) { StoreLeaderBoardShowcase(localeData: storeLocales[2]) }
}
#Preview("Store LeaderBoard — DE") {
    StoreLocalePreview(storeLocales[3]) { StoreLeaderBoardShowcase(localeData: storeLocales[3]) }
}
#Preview("Store LeaderBoard — ES") {
    StoreLocalePreview(storeLocales[4]) { StoreLeaderBoardShowcase(localeData: storeLocales[4]) }
}
#Preview("Store LeaderBoard — FR") {
    StoreLocalePreview(storeLocales[5]) { StoreLeaderBoardShowcase(localeData: storeLocales[5]) }
}
#Preview("Store LeaderBoard — IT") {
    StoreLocalePreview(storeLocales[6]) { StoreLeaderBoardShowcase(localeData: storeLocales[6]) }
}
#Preview("Store LeaderBoard — JA") {
    StoreLocalePreview(storeLocales[7]) { StoreLeaderBoardShowcase(localeData: storeLocales[7]) }
}
#Preview("Store LeaderBoard — KO") {
    StoreLocalePreview(storeLocales[8]) { StoreLeaderBoardShowcase(localeData: storeLocales[8]) }
}
#Preview("Store LeaderBoard — PT-BR") {
    StoreLocalePreview(storeLocales[9]) { StoreLeaderBoardShowcase(localeData: storeLocales[9]) }
}
