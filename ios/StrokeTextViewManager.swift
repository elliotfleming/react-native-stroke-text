// ios/StrokeTextViewManager.swift

import Foundation
import React

@objc(StrokeTextViewManager)
class StrokeTextViewManager: RCTViewManager {
  override static func requiresMainQueueSetup() -> Bool { true }

  override func view() -> UIView! {
    return StrokeTextView(bridge: self.bridge)
  }
}
