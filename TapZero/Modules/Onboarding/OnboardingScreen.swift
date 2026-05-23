//
//  OnboardingScreen.swift
//  TapZero
//

import PhotosUI
import SwiftfulRouting
import SwiftUI

struct OnboardingScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        contentView
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
            .photosPicker(
                isPresented: $viewModel.showPhotoPicker,
                selection: $viewModel.selectedPhotoItem,
                matching: .images
            )
            .onChange(of: viewModel.selectedPhotoItem) { _, _ in
                viewModel.onPhotoSelected()
            }
    }

    private var contentView: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                if !viewModel.isIntroStep {
                    StepHeader(
                        currentStep: viewModel.dataStepIndex,
                        totalSteps: viewModel.dataStepCount,
                        showBack: viewModel.dataStepIndex > 1,
                        onBack: viewModel.onBackPressed
                    )
                }

                stepContent
                    .frame(maxHeight: .infinity)
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case 1:
            IntroStepOne(
                binding: $viewModel.introStepOne.binding,
                config: viewModel.introStepOne.config,
                onAction: viewModel.onIntroStepOneAction
            )
        case 2:
            IntroStepTwo(
                binding: $viewModel.introStepTwo.binding,
                config: viewModel.introStepTwo.config,
                onAction: viewModel.onIntroStepTwoAction
            )
        case 3:
            NameStep(
                binding: $viewModel.nameStep.binding,
                config: viewModel.nameStep.config,
                onAction: viewModel.onStepOneAction
            )
        case 4:
            PhotoStep(
                binding: $viewModel.photoStep.binding,
                config: viewModel.photoStep.config,
                onAction: viewModel.onStepTwoAction
            )
        case 5:
            NotificationStep(
                binding: $viewModel.notificationStep.binding,
                config: viewModel.notificationStep.config,
                onAction: viewModel.onStepThreeAction
            )
        case 6:
            GetStartedStep(
                binding: $viewModel.getStartedStep.binding,
                config: viewModel.getStartedStep.config,
                onAction: viewModel.onStepFourAction
            )
        default:
            EmptyView()
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "onboarding", addModuleSupport: true) { router in
        OnboardingBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
