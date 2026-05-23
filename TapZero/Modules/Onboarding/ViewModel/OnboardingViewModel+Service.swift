//
//  OnboardingViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension OnboardingViewModel {
    func fetchData() async {
    }

    func uploadProfilePhotoIfNeeded() async {
        guard let data = selectedPhotoData else { return }
        do {
            try await userManager.uploadProfileImage(data: data)
        } catch {
            crashReporter.record(error: error)
        }
    }
}
