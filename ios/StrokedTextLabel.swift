// ios/StrokedTextLabel.m

import UIKit

class StrokedTextLabel: UILabel {
  var outlineColor: UIColor = .clear {
    didSet { setNeedsDisplay() }
  }

  var outlineWidth: CGFloat = 0 {
    didSet { setNeedsDisplay() }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    numberOfLines = 0
    lineBreakMode = .byWordWrapping

    clipsToBounds = false
    layer.masksToBounds = false
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func drawText(in rect: CGRect) {
    // let shadowOffset = self.shadowOffset
    let inset = ceil(outlineWidth)
    let adjustedRect = rect.insetBy(dx: inset, dy: inset)

    guard let ctx = UIGraphicsGetCurrentContext() else {
      super.drawText(in: adjustedRect)
      return
    }

    NSLog("[StrokeTextLabel] drawText outlineWidth: \(outlineWidth)")
    NSLog("[StrokeTextLabel] drawText rect: \(rect)")
    NSLog("[StrokeTextLabel] drawText adjustedRect: \(adjustedRect)")

    if outlineWidth > 0 {
      // Save the original text color
      let textColor = self.textColor

      ctx.setLineWidth(outlineWidth)
      ctx.setLineJoin(.round)

      // Stroke the text
      ctx.setTextDrawingMode(.stroke)
      self.textColor = outlineColor  // Set the outline color
      super.drawText(in: adjustedRect)

      // Fill the text
      ctx.setTextDrawingMode(.fill)
      self.textColor = textColor  // Restore the original text color
      // self.shadowOffset = CGSize(width: 0, height: 0)
      super.drawText(in: adjustedRect)
      // self.shadowOffset = shadowOffset
    } else {
      NSLog("[StrokeTextLabel] No outline width, drawing text normally")
      super.drawText(in: adjustedRect)
    }
  }

  override var intrinsicContentSize: CGSize {
    let s = super.intrinsicContentSize
    let inset = ceil(outlineWidth) * 2
    NSLog("[StrokeTextLabel] intrinsicContentSize: \(s)")
    NSLog("[StrokeTextLabel] intrinsicContentSize inset: \(inset)")
    return CGSize(
      width: s.width + inset,
      height: s.height + inset
    )
  }

}
