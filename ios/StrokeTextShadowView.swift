import Foundation
import React

class StrokeTextShadowView: RCTShadowView {
  @objc var text: String = ""
  @objc var fontSize: NSNumber = 14

  override func measure(
    with layoutContext: RCTLayoutContext,
    layoutConstraints: RCTLayoutConstraints
  ) -> CGSize {
    let maxWidth = layoutConstraints.maximumSize.width

    let font = UIFont.systemFont(ofSize: CGFloat(truncating: fontSize))

    let label = UILabel()
    label.font = font
    label.numberOfLines = 0
    label.text = text

    let size = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))

    return size
  }
}
