import Foundation
import UIKit

@objc(StrokeTextViewManager)
class StrokeTextViewManager: RCTViewManager {

    override func view() -> UIView! {
        // StrokeTextView no longer needs a bridge parameter
        return StrokeTextView(frame: .zero)
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
