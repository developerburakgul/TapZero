//
//  ShareActivityItemSource.swift
//  TapZero
//

import LinkPresentation
import UIKit

final class ShareActivityItemSource: NSObject, UIActivityItemSource {
    private let image: UIImage
    private let shareText: String

    init(image: UIImage, shareText: String) {
        self.image = image
        self.shareText = shareText
    }

    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        image
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        image
    }

    func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = shareText
        metadata.imageProvider = NSItemProvider(object: image)
        return metadata
    }
}
