import Foundation
import UIKit

@objc(StrokeTextViewManager)
class StrokeTextViewManager: RCTViewManager {

    override func view() -> UIView! {
        return StrokeTextView(bridge: self.bridge)
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
