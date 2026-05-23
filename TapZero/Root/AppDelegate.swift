//
//  AppDelegate.swift
//  TapZero
//
//  Created by Burak Gül on 9.03.2026.
//

import FirebaseCore
import Foundation
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
        dependencies = Dependencies(config: config)
        Dependencies.shared = dependencies

        UNUserNotificationCenter.current().delegate = self

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
