//
//  SettingsViewModel+Configure.swift
//  Created by __Username__ on __Date__
//

import Foundation
import UserNotifications

// MARK: - Configure
extension SettingsViewModel {
    func configure() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        notificationEnabled = settings.authorizationStatus == .authorized
    }
}
