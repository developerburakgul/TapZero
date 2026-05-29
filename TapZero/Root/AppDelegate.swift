//
//  AppDelegate.swift
//  TapZero
//
//  Created by Burak Gül on 9.03.2026.
//

import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn
import KeychainAccess
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies! // swiftlint:disable:this implicitly_unwrapped_optional

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        var config: BuildConfiguration

        #if MOCK
        config = .mock(isSignedIn: true)
        #elseif DEV
        config = .dev
        #else
        config = .prod
        #endif

        config.configure()

        switch config {
        case .dev, .prod:
            Self.clearStateIfReinstalled()
            if let clientID = FirebaseApp.app()?.options.clientID {
                GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            }
        case .mock:
            break
        }

        dependencies = Dependencies(config: config)
        Dependencies.shared = dependencies

        UNUserNotificationCenter.current().delegate = self

        return true
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }
        Dependencies.shared.container.resolve(DeepLinkManager.self)?.handleURL(url)
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // FCM geldiğinde: Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    /// Uygulama foreground'dayken gelen bildirimi banner olarak gösterir.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .badge, .sound]
    }

    /// Kullanıcı bildirime tıkladığında deep link varsa ilgili ekrana yönlendirir.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        if let urlString = userInfo["deep_link"] as? String,
           let url = URL(string: urlString) {
            Dependencies.shared.container.resolve(DeepLinkManager.self)?.handleURL(url)
        }
    }
}

// MARK: - Reinstall Detection
extension AppDelegate {
    /// iOS Keychain persists across app deletion. On first launch after reinstall,
    /// clear stale Firebase Auth tokens and app keychain data.
    static func clearStateIfReinstalled() {
        let defaults = UserDefaults.standard
        let key = AppConstants.hasLaunchedBeforeKey

        guard !defaults.bool(forKey: key) else { return }

        try? Auth.auth().signOut()
        try? Keychain(service: AppConstants.keychainService).removeAll()
        defaults.set(true, forKey: key)
    }
}

enum BuildConfiguration {
    case mock(isSignedIn: Bool), dev, prod

    func configure() {
        switch self {
        case .mock:
            // Mock build does NOT run Firebase
            return
        case .dev:
            guard let plist = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist"),
                  let options = FirebaseOptions(contentsOfFile: plist) else {
                // swiftlint:disable:next no_print
                print("GoogleService-Info-Dev.plist not found, Firebase not configured")
                return
            }
            FirebaseApp.configure(options: options)
        case .prod:
            guard let plist = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist"),
                  let options = FirebaseOptions(contentsOfFile: plist) else {
                // swiftlint:disable:next no_print
                print("GoogleService-Info-Prod.plist not found, Firebase not configured")
                return
            }
            FirebaseApp.configure(options: options)
        }
    }
}
