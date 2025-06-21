// ios/StrokeTextViewManager.swift

import Foundation
import UIKit

@objc(StrokeTextViewManager)
class StrokeTextViewManager: RCTViewManager {

    override func view() -> UIView! {
        return StrokeTextView(bridge: self.bridge)
    }

    override func shadowView() -> RCTShadowView! {
        return StrokeTextShadowView()
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
