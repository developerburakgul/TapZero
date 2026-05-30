//
//  SharePreviewViewModel+Action.swift
//  TapZero
//

import SwiftUI

// MARK: - Actions
extension SharePreviewViewModel {
    func viewDidLoad() async {
    }

    func viewWillAppear() async {
        sendEvent(type: .pageAppear)
        let name = userManager.currentUser?.displayName ?? ""
        scoreCard.config.userName = name.isEmpty ? nil : name
        if let urlString = userManager.currentUser?.profileImageURL {
            scoreCard.config.profileImageURL = URL(string: urlString)
        }
    }

    func onColorSelected(_ color: Color) {
        selectedColor = color
        scoreCard.config.cardBackground = color
    }

    func onShareTapped(image: UIImage?) {
        sendEvent(type: .shareTapped)
        guard let image else { return }
        let shareText = TextKey.SharePreview.shareText(score: entity.score)
        let itemSource = ShareActivityItemSource(image: image, shareText: shareText)
        let activityVC = UIActivityViewController(
            activityItems: [itemSource],
            applicationActivities: nil
        )
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            var topVC = rootVC
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            topVC.present(activityVC, animated: true)
        }
    }

    func onCloseTapped() {
        router.dismissScreen()
    }
}
