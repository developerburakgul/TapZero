//
//  OnboardingViewModel+Action.swift
//  TapZero
//

import Foundation
import SwiftfulRouting
import SwiftUI
import UserNotifications

// MARK: - Actions
extension OnboardingViewModel {
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    func sendInitialRequests() async {
        await withTaskGroup { group in
            group.addTask {
                await self.fetchData()
            }
        }
    }

    // MARK: - Navigation

    func onBackPressed() {
        guard !isFirstStep else { return }
        currentStep -= 1
    }

    func onIntroStepOneAction(_ action: OnboardingScreen.IntroStepOne.Action) {
        switch action {
        case .didTapContinue:
            sendEvent(type: .completedStep(step: 1))
            currentStep = 2
        }
    }

    func onIntroStepTwoAction(_ action: OnboardingScreen.IntroStepTwo.Action) {
        switch action {
        case .didTapContinue:
            sendEvent(type: .completedStep(step: 2))
            currentStep = 3
        }
    }

    func onStepOneAction(_ action: OnboardingScreen.NameStep.Action) {
        switch action {
        case .didTapContinue:
            sendEvent(type: .completedStep(step: 3))
            let name = nameStep.binding.inputText.trimmingCharacters(in: .whitespaces)
            photoStep.binding.initial = String(name.prefix(1)).uppercased()
            currentStep = 4
        }
    }

    func onStepTwoAction(_ action: OnboardingScreen.PhotoStep.Action) {
        switch action {
        case .didTapContinue:
            sendEvent(type: .completedStep(step: 4))
            Task { await moveToNotificationStep() }
        case .didTapSkip:
            sendEvent(type: .tappedSkipPhoto)
            sendEvent(type: .completedStep(step: 4))
            Task { await moveToNotificationStep() }
        case .didTapCamera:
            showPhotoPicker = true
        case .didTapRemovePhoto:
            onPhotoRemoved()
        }
    }

    func onStepThreeAction(_ action: OnboardingScreen.NotificationStep.Action) {
        switch action {
        case .didTapEnable:
            sendEvent(type: .tappedEnableNotification)
            Task {
                let granted = await requestNotificationPermission()
                notificationStep.binding.permissionGranted = granted
                sendEvent(type: .completedNotificationPermission(granted: granted))
                sendEvent(type: .completedStep(step: 5))
                currentStep = 6
            }
        case .didTapSkip:
            sendEvent(type: .tappedSkipNotification)
            sendEvent(type: .completedStep(step: 5))
            currentStep = 6
        case .didTapContinue:
            sendEvent(type: .completedStep(step: 5))
            currentStep = 6
        }
    }

    func onStepFourAction(_ action: OnboardingScreen.GetStartedStep.Action) {
        switch action {
        case .didTapStart:
            sendEvent(type: .tappedGetStarted)
            sendEvent(type: .completedStep(step: 6))
            sendEvent(type: .completedAll)
            completeOnboarding()
        }
    }

    private func moveToNotificationStep() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        notificationStep.binding.permissionGranted = settings.authorizationStatus == .authorized
        currentStep = 5
    }

    private func requestNotificationPermission() async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            crashReporter.record(error: error)
            return false
        }
    }

    func onPhotoSelected() {
        guard let item = selectedPhotoItem else { return }
        sendEvent(type: .selectedPhoto)
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedPhotoData = uiImage.jpegData(compressionQuality: 0.7)
                photoStep.binding.selectedImage = Image(uiImage: uiImage)
                photoStep.binding.imageVersion += 1
            }
        }
    }

    func onPhotoRemoved() {
        selectedPhotoItem = nil
        selectedPhotoData = nil
        photoStep.binding.selectedImage = nil
        photoStep.binding.imageVersion += 1
    }

    private func completeOnboarding() {
        let name = nameStep.binding.inputText.trimmingCharacters(in: .whitespaces)

        let config = ResizableSheetConfig(
            detents: [.fraction(0.45)],
            dragIndicator: .visible
        )
        router.showScreen(.sheetConfig(config: config)) { [weak self] router in
            CreateAccountBuilder.build(
                router: router,
                entity: CreateAccountEntity(showGuestOption: true, displayName: name)
            ) {
                self?.navigateToTabbar()
            }
        }
    }

    private func navigateToTabbar() {
        Task {
            await uploadProfilePhotoIfNeeded()
        }
        let entity = TabbarEntity(initialTab: userManager.lastSelectedTab())
        router.showModule(.identity, id: "tabbar") { _ in
            RouterView(addNavigationStack: false) { router in
                TabbarBuilder.build(router: router, entity: entity)
            }
        }
    }
}
