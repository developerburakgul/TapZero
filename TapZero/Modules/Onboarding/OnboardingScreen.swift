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

            if viewModel.isIntroStep {
                introPageView
            } else {
                dataStepView
            }
        }
    }

    // MARK: - Intro Pager

    private var introPageBinding: Binding<Int> {
        Binding(
            get: { viewModel.introPageIndex },
            set: {
                viewModel.introPageIndex = $0
                viewModel.resetIntroCards()
            }
        )
    }

    private var introPageView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 58)

            TabView(selection: introPageBinding) {
                introPages
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            IntroFooter(
                index: viewModel.introPageIndex,
                ctaLabel: viewModel.introCtaLabel
            ) {
                viewModel.onIntroContinue()
            }
        }
    }

    @ViewBuilder
    private var introPages: some View {
        IntroStepOne(
            binding: $viewModel.introStepOne.binding,
            config: viewModel.introStepOne.config
        )
        .tag(0)

        IntroStepTwo(
            binding: $viewModel.introStepTwo.binding,
            config: viewModel.introStepTwo.config
        )
        .tag(1)

        IntroStepThree(
            binding: $viewModel.introStepThree.binding,
            config: viewModel.introStepThree.config
        )
        .tag(2)
    }

    // MARK: - Data Steps

    private var dataStepView: some View {
        VStack(spacing: 0) {
            StepHeader(
                currentStep: viewModel.dataStepIndex,
                totalSteps: viewModel.dataStepCount,
                showBack: viewModel.dataStepIndex > 1,
                onBack: viewModel.onBackPressed
            )

            dataStepContent
                .frame(maxHeight: .infinity)
        }
    }

    @ViewBuilder
    private var dataStepContent: some View {
        switch viewModel.currentStep {
        case 4:
            NameStep(
                binding: $viewModel.nameStep.binding,
                config: viewModel.nameStep.config,
                onAction: viewModel.onStepOneAction
            )
        case 5:
            PhotoStep(
                binding: $viewModel.photoStep.binding,
                config: viewModel.photoStep.config,
                onAction: viewModel.onStepTwoAction
            )
        case 6:
            NotificationStep(
                binding: $viewModel.notificationStep.binding,
                config: viewModel.notificationStep.config,
                onAction: viewModel.onStepThreeAction
            )
        case 7:
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
