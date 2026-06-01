//
//  PhoneMockupView.swift
//  TapZero
//

import SwiftUI

struct PhoneMockupView<Content: View>: View {
    let width: CGFloat
    let content: () -> Content

    init(width: CGFloat = 280, @ViewBuilder content: @escaping () -> Content) {
        self.width = width
        self.content = content
    }

    private var cornerRadius: CGFloat { width * 0.094 }

    var body: some View {
        ZStack(alignment: .top) {
            // Phone background
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(.systemBackground).opacity(0.06))

            // Phone border
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.systemGray3).opacity(0.5), lineWidth: 1.5)

            // Status bar
            statusBar

            // Screen content
            content()
        }
        .frame(width: width)
        .mask {
            LinearGradient(
                stops: [
                    .init(color: .white, location: 0),
                    .init(color: .clear, location: 0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .padding(-1)
        }
    }

    private var statusBar: some View {
        HStack(spacing: 4) {
            Text("9:41")
                .fontWeight(.bold)

            Spacer()

            Image(systemName: "cellularbars")
            Image(systemName: "wifi")
            Image(systemName: "battery.75percent")
        }
        .font(.caption2)
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
}

// MARK: - Mock App Grid

struct MockAppGridView: View {
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 20)
                RoundedRectangle(cornerRadius: 20)
            }
            .frame(height: 110)

            LazyVGrid(
                columns: Array(repeating: GridItem(spacing: 15), count: 4),
                spacing: 15
            ) {
                ForEach(1...8, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 48)
                }
            }
        }
        .foregroundStyle(Color(.label).opacity(0.06))
        .padding(20)
        .padding(.top, 20)
    }
}

// MARK: - Notification Banner

struct NotificationBannerView<Logo: View>: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let logo: () -> Logo

    init(
        title: LocalizedStringKey = "",
        subtitle: LocalizedStringKey = "",
        @ViewBuilder logo: @escaping () -> Logo
    ) {
        self.title = title
        self.subtitle = subtitle
        self.logo = logo
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            logo()

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.medium)
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    Text(TextKey.Common.notificationNow)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                }

                Text(subtitle)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .gray.opacity(0.5), radius: 1.5)
    }
}

// MARK: - Convenience Init (Icon-based)

extension NotificationBannerView where Logo == NotificationIconView {
    init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        icon: String = "bell.fill",
        iconColor: Color = .blue
    ) {
        self.title = title
        self.subtitle = subtitle
        self.logo = { NotificationIconView(icon: icon, color: iconColor) }
    }
}

struct NotificationIconView: View {
    let icon: String
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(width: 34, height: 34)
            .overlay {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
            }
    }
}

// MARK: - Previews

#Preview("Phone Mockup") {
    PhoneMockupView(width: 280) {
        MockAppGridView()

        NotificationBannerView(
            title: "TapZero",
            subtitle: "You have a new message!",
            icon: "bell.fill",
            iconColor: .blue
        )
        .padding(.horizontal, 12)
        .padding(.top, 40)
    }
    .padding()
}
