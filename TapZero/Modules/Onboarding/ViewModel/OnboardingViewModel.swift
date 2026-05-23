//
//  OnboardingViewModel.swift
//  TapZero
//

import Combine
import PhotosUI
import SwiftfulRouting
import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: OnboardingEntity
    let totalSteps = 6

    // MARK: - Managers
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var keychainManager: KeychainManagerProtocol
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
    @Published var currentStep: Int = 1
    @Published var showPhotoPicker: Bool = false
    @Published var selectedPhotoItem: PhotosPickerItem?
    var selectedPhotoData: Data?

    // MARK: - Step Entities
    @Published var introStepOne: OnboardingScreen.IntroStepOneEntity = .init(
        binding: .init(),
        config: .init(
            title: TextKey.Onboarding.intro1Title,
            subtitle: TextKey.Onboarding.intro1Subtitle
        )
    )
    @Published var introStepTwo: OnboardingScreen.IntroStepTwoEntity = .init(
        binding: .init(),
        config: .init(
            title: TextKey.Onboarding.intro2Title,
            subtitle: TextKey.Onboarding.intro2Subtitle
        )
    )
    @Published var nameStep: OnboardingScreen.NameStepEntity = .init(
        binding: .init(inputText: ""),
        config: .init(
            title: TextKey.Onboarding.nameTitle,
            subtitle: TextKey.Onboarding.nameSubtitle
        )
    )
    @Published var photoStep: OnboardingScreen.PhotoStepEntity = .init(
        binding: .init(initial: ""),
        config: .init(
            title: TextKey.Onboarding.photoTitle,
            subtitle: TextKey.Onboarding.photoSubtitle
        )
    )
    @Published var notificationStep: OnboardingScreen.NotificationStepEntity = .init(
        binding: .init(),
        config: .init(
            title: TextKey.Onboarding.notificationTitle,
            subtitle: TextKey.Onboarding.notificationSubtitle
        )
    )
    @Published var getStartedStep: OnboardingScreen.GetStartedStepEntity = .init(
        binding: .init(),
        config: .init(
            title: TextKey.Onboarding.getStartedTitle,
            subtitle: TextKey.Onboarding.getStartedSubtitle
        )
    )

    // MARK: - Init
    init(
        router: Router,
        entity: OnboardingEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension OnboardingViewModel {
    var isLastStep: Bool {
        currentStep == totalSteps
    }

    var isFirstStep: Bool {
        currentStep == 1
    }

    var isIntroStep: Bool {
        currentStep <= 2
    }

    var dataStepIndex: Int {
        currentStep - 2
    }

    var dataStepCount: Int {
        totalSteps - 2
    }
}
