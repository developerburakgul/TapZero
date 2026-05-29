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
    }

    func onColorSelected(_ color: Color) {
        selectedColor = color
    }

    func onShareTapped(image: UIImage?) {
        sendEvent(type: .shareTapped)
        guard let image else { return }
        let activityVC = UIActivityViewController(
            activityItems: [image],
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
