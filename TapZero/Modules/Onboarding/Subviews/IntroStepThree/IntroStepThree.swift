//
//  IntroStepThree.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    private struct PreviewUser: Identifiable {
        let id: Int
        let name: String
        let pts: Int
        let color: String
        let imageURL: URL?

        var rank: Int { id }
    }

    struct IntroStepThree: View, @MainActor Equatable {
        @Binding var binding: IntroStepThreeEntity.Binding
        let config: IntroStepThreeEntity.Config

        private static var podiumUsers: [PreviewUser] {
            let lp = localeProfiles
            return [
                makeUser(id: 2, profile: lp[0], pts: 971, color: TapZeroPalette.Pastel.PS2),
                makeUser(id: 1, profile: lp[1], pts: 984, color: TapZeroPalette.Pastel.PS1),
                makeUser(id: 3, profile: lp[2], pts: 958, color: TapZeroPalette.Pastel.PS3)
            ]
        }

        private static var listUsers: [PreviewUser] {
            let lp = localeProfiles
            return [
                makeUser(id: 4, profile: lp[3], pts: 942, color: TapZeroPalette.Pastel.PS4),
                makeUser(id: 5, profile: lp[4], pts: 934, color: TapZeroPalette.Pastel.PS5)
            ]
        }

        private static func makeUser(
            id: Int,
            profile: (name: String, url: URL?),
            pts: Int,
            color: String
        ) -> PreviewUser {
            .init(id: id, name: profile.name, pts: pts, color: color, imageURL: profile.url)
        }

        // MARK: - Locale Profiles

        private static var localeProfiles: [(name: String, url: URL?)] {
            let lang = Bundle.main.preferredLocalizations.first ?? "en"
            switch lang {
            case "tr": return trProfiles
            case "ar": return arProfiles
            case "de": return deProfiles
            case "es": return esProfiles
            case "fr": return frProfiles
            case "it": return itProfiles
            case "ja": return jaProfiles
            case "ko": return koProfiles
            case "pt-BR": return ptBRProfiles
            default: return enProfiles
            }
        }

        private static func men(_ id: Int) -> URL? {
            URL(string: "https://randomuser.me/api/portraits/men/\(id).jpg")
        }

        private static func women(_ id: Int) -> URL? {
            URL(string: "https://randomuser.me/api/portraits/women/\(id).jpg")
        }

        // Order: silver, gold, bronze, 4th, 5th
        // Portrait IDs sourced from randomuser.me API with nat= filter
        private static let enProfiles: [(name: String, url: URL?)] = [
            ("Aaron", men(64)), ("Ashley", women(89)), ("Teresa", women(87)),
            ("Ricky", men(11)), ("Sophie", women(88))
        ]
        private static let trProfiles: [(name: String, url: URL?)] = [
            ("Elif", women(75)), ("Ahmet", men(49)), ("Zeynep", women(21)),
            ("Burak", men(56)), ("Ayşe", women(82))
        ]
        private static let arProfiles: [(name: String, url: URL?)] = [
            ("Omar", men(63)), ("Sara", women(72)), ("Layla", women(84)),
            ("Hassan", men(10)), ("Noor", women(59))
        ]
        private static let deProfiles: [(name: String, url: URL?)] = [
            ("Lukas", men(77)), ("Lena", women(20)), ("Sophie", women(93)),
            ("Max", men(85)), ("Anna", women(61))
        ]
        private static let esProfiles: [(name: String, url: URL?)] = [
            ("Carlos", men(72)), ("María", women(41)), ("Lucía", women(56)),
            ("Diego", men(82)), ("Ana", women(93))
        ]
        private static let frProfiles: [(name: String, url: URL?)] = [
            ("Lucas", men(42)), ("Léa", women(18)), ("Chloé", women(47)),
            ("Antoine", men(30)), ("Camille", women(94))
        ]
        private static let itProfiles: [(name: String, url: URL?)] = [
            ("Marco", men(59)), ("Giulia", women(24)), ("Sofia", women(70)),
            ("Luca", men(30)), ("Elena", women(36))
        ]
        private static let jaProfiles: [(name: String, url: URL?)] = [
            ("Kenji", men(32)), ("Sakura", women(44)), ("Yuna", women(68)),
            ("Takeshi", men(75)), ("Hana", women(90))
        ]
        private static let koProfiles: [(name: String, url: URL?)] = [
            ("Minjun", men(32)), ("Jisu", women(44)), ("Soyeon", women(68)),
            ("Hyunwoo", men(75)), ("Yuna", women(90))
        ]
        private static let ptBRProfiles: [(name: String, url: URL?)] = [
            ("Pedro", men(61)), ("Ana", women(54)), ("Beatriz", women(18)),
            ("Lucas", men(36)), ("Julia", women(70))
        ]

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                podiumSection
                listSection
                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 12)
        }

        // MARK: - Header

        private var headerSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(config.title)
                    .font(TapZeroTypography.Heading.pageHeader)
                    .tracking(-0.9)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.primary)
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
        }

        // MARK: - Podium

        private var podiumSection: some View {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(Self.podiumUsers) { user in
                    podiumItem(user: user)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 24)
        }

        private func podiumItem(user: PreviewUser) -> some View {
            let isBig = user.rank == 1
            let size: CGFloat = isBig ? 64 : 50

            return VStack(spacing: 0) {
                if isBig {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(TapZeroDesign.Medal.gold)
                        .padding(.bottom, 4)
                }

                podiumAvatar(user: user, size: size, isBig: isBig)
                podiumLabel(user: user, isBig: isBig)
            }
        }

        private func podiumAvatar(
            user: PreviewUser,
            size: CGFloat,
            isBig: Bool
        ) -> some View {
            AsyncImage(url: user.imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Color(hex: user.color))
                    .overlay(
                        Text(String(user.name.prefix(1)))
                            .font(.system(size: isBig ? 22 : 17, weight: .bold))
                            .foregroundStyle(TapZeroDesign.Foreground.primary)
                    )
            }
            .frame(width: size - 6, height: size - 6)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(medalColor(for: user.rank), lineWidth: 2)
                    .frame(width: size, height: size)
            )
            .padding(.top, isBig ? 0 : 20)
        }

        private func podiumLabel(user: PreviewUser, isBig: Bool) -> some View {
            let ringColor = medalColor(for: user.rank)
            let badgeFg = user.rank == 3
                ? TapZeroDesign.Background.primary
                : TapZeroDesign.Foreground.primary

            return VStack(spacing: 0) {
                Text(rankLabel(user.rank))
                    .font(TapZeroTypography.Caption.rankBadge)
                    .tracking(-0.1)
                    .foregroundStyle(badgeFg)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(ringColor)
                    .clipShape(Capsule())
                    .offset(y: -6)

                Text(user.name)
                    .font(.system(size: isBig ? 13 : 12, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(formattedPoints(user.pts))
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .monospacedDigit()
            }
        }

        // MARK: - List

        private var listSection: some View {
            VStack(spacing: 0) {
                ForEach(Self.listUsers) { user in
                    listRow(user: user)
                }

                yourSpotRow
            }
            .padding(.top, 6)
        }

        private func listRow(user: PreviewUser) -> some View {
            HStack(spacing: 12) {
                Text(TextKey.number(user.rank))
                    .font(.system(size: 13, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    .frame(width: 22)

                AsyncImage(url: user.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color(hex: user.color))
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())

                Text(user.name)
                    .font(.system(size: 14, weight: .medium))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Spacer()

                Text(formattedPoints(user.pts))
                    .font(.system(size: 14, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .monospacedDigit()
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 4)
        }

        private var yourSpotRow: some View {
            HStack(spacing: 12) {
                Text("?")
                    .font(.system(size: 13, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    .frame(width: 22)

                Circle()
                    .strokeBorder(
                        TapZeroDesign.Foreground.tertiary,
                        style: StrokeStyle(lineWidth: 1, dash: [3, 3])
                    )
                    .frame(width: 30, height: 30)

                Text(TextKey.Onboarding.yourSpotWaiting)
                    .font(.system(size: 14, weight: .medium))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .italic()

                Spacer()

                Text("—")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 4)
            .opacity(0.5)
        }

        // MARK: - Helpers

        private func medalColor(for rank: Int) -> Color {
            switch rank {
            case 1: TapZeroDesign.Medal.gold
            case 2: TapZeroDesign.Medal.silver
            default: TapZeroDesign.Medal.bronze
            }
        }

        private func rankLabel(_ rank: Int) -> LocalizedStringKey {
            switch rank {
            case 1: TextKey.Onboarding.rankFirst
            case 2: TextKey.Onboarding.rankSecond
            case 3: TextKey.Onboarding.rankThird
            default: TextKey.Onboarding.rankOther(rank)
            }
        }

        private func formattedPoints(_ pts: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: pts)) ?? "\(pts)"
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding && lhs.config == rhs.config
        }
    }
}
