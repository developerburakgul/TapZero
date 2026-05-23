//
//  NotificationPermissionScreen.swift
//  TapZero
//

import SwiftUI
import UserNotifications

/// Standalone sheet wrapper for the notification permission UI.
/// Reuses the same phone mockup and animation from onboarding.
/// Checks permission status internally and shows the appropriate UI.
struct NotificationPermissionScreen: View {
    let onDismiss: () -> Void

    @State private var animateNotification: Bool = false
    @State private var loopActive: Bool = true
    @State private var authorizationStatus: UNAuthorizationStatus = .notDetermined

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            mockupSection
            Spacer()
            buttonSection
        }
        .padding(.horizontal, 24)
        .task { await checkPermission() }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await checkPermission() }
        }
        .onAppear {
            loopActive = true
            animateNotification = false
        }
        .onDisappear { loopActive = false }
    }

    // MARK: - Permission

    private func checkPermission() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(TextKey.Onboarding.notificationTitle)
                .font(TapZeroTypography.Display.large)
                .foregroundStyle(TapZeroDesign.Foreground.primary)

            Text(TextKey.Onboarding.notificationSubtitle)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
        }
        .padding(.top, 24)
    }

    // MARK: - Mockup

    private var mockupSection: some View {
        PhoneMockupView(width: 280) {
            MockAppGridView()
            notificationOverlay
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }

    private var notificationOverlay: some View {
        NotificationBannerView(
            title: TextKey.Onboarding.notificationMockTitle,
            subtitle: TextKey.Onboarding.notificationMockSubtitle,
            icon: "bell.fill",
            iconColor: TapZeroDesign.Accent.primary
        )
        .padding(.horizontal, 12)
        .padding(.top, 40)
        .offset(y: animateNotification ? 0 : -200)
        .clipped()
        .task { await loopAnimation() }
    }

    // MARK: - Animation

    private func loopAnimation() async {
        try? await Task.sleep(for: .seconds(0.5))
        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
            animateNotification = true
        }

        try? await Task.sleep(for: .seconds(3.5))
        withAnimation(.easeIn(duration: 0.3)) {
            animateNotification = false
        }

        guard loopActive else { return }
        try? await Task.sleep(for: .seconds(1))
        await loopAnimation()
    }

    // MARK: - Buttons

    @ViewBuilder
    private var buttonSection: some View {
        switch authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            enabledView
            doneButton
        case .notDetermined:
            enableButton
        default:
            settingsPathHint
            goToSettingsButton
            askLaterButton
        }
    }

    private var enableButton: some View {
        Button {
            Task {
                let granted = (try? await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound])) ?? false
                await checkPermission()
                if granted { onDismiss() }
            }
        } label: {
            Text(TextKey.Onboarding.enableNotifications)
                .font(TapZeroTypography.Label.large)
                .frame(maxWidth: .infinity)
                .padding()
                .background(TapZeroDesign.Foreground.primary)
                .foregroundStyle(TapZeroDesign.Background.primary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.bottom, 16)
    }

    private var settingsPathHint: some View {
        Text(TextKey.Settings.notificationSettingsPath)
            .font(TapZeroTypography.Body.small)
            .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)
    }

    private var goToSettingsButton: some View {
        Button {
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                UIApplication.shared.open(url)
            }
        } label: {
            Text(TextKey.Settings.notificationGoToSettings)
                .font(TapZeroTypography.Label.large)
                .frame(maxWidth: .infinity)
                .padding()
                .background(TapZeroDesign.Foreground.primary)
                .foregroundStyle(TapZeroDesign.Background.primary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var askLaterButton: some View {
        Button {
            onDismiss()
        } label: {
            Text(TextKey.Settings.notificationAskLater)
                .font(TapZeroTypography.Label.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .padding(.bottom, 4)
    }

    private var enabledView: some View {
        VStack(spacing: 8) {
            Image(systemName: "bell.badge.checkmark.fill")
                .font(.system(size: 36))
                .foregroundStyle(TapZeroDesign.System.systemGreen)

            Text(TextKey.Onboarding.notificationsEnabled)
                .font(TapZeroTypography.Heading.h2)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 12)
    }

    private var doneButton: some View {
        Button {
            onDismiss()
        } label: {
            Text(TextKey.Common.okKey)
                .font(TapZeroTypography.Label.large)
                .frame(maxWidth: .infinity)
                .padding()
                .background(TapZeroDesign.Foreground.primary)
                .foregroundStyle(TapZeroDesign.Background.primary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    NotificationPermissionScreen { }
        .background(TapZeroDesign.Background.primary)
        .environment(\.locale, DevPreview.shared.locale)
}
