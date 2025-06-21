// ios/StrokeTextViewManager.swift

import Foundation
import UIKit

@objc(StrokeTextViewManager)
class StrokeTextViewManager: RCTViewManager {

    override func view() -> UIView! {
        return StrokeTextView(bridge: self.bridge)
    }

    override func sizeThatFits(_ size: CGSize, for view: UIView!) -> CGSize {
        guard let strokeView = view as? StrokeTextView else { return .zero }
        return strokeView.label.intrinsicContentSize
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
