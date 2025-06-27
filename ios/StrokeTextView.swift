// ios/StrokeTextView.swift

import React
import UIKit

@objc(StrokeTextView)
class StrokeTextView: RCTView {
  // MARK: Config
  private weak var bridge: RCTBridge?

  private var needsLayoutUpdate = false

  let label = StrokedTextLabel()
  var fontCache = [String: UIFont]()
  var paddingInsets: UIEdgeInsets = .zero

  // MARK: - Init
  @objc init(bridge: RCTBridge) {
    self.bridge = bridge
    super.init(frame: .zero)
    label.textColor = StrokeTextView.colorStringToUIColor(colorString: color)
    label.outlineColor = StrokeTextView.colorStringToUIColor(colorString: strokeColor)
    addSubview(label)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  @objc override func reactSetFrame(_ frame: CGRect) {
    NSLog("[StrokeText] reactSetFrame(frame): \(frame)")
    super.reactSetFrame(frame)

    // Update label frame to match the view's bounds
    let innerFrame = bounds.inset(by: paddingInsets)
    label.frame = innerFrame

    // Invalidate layout to ensure proper sizing
    invalidateLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    NSLog("[StrokeText] layoutSubviews(): \(bounds)")

    let innerFrame = bounds.inset(by: paddingInsets)
    label.frame = innerFrame

    let hasExplicitWidth =
      bounds.width.isFinite && bounds.width > 0 && bounds.width < CGFloat.greatestFiniteMagnitude
    // let hasExplicitHeight =
    //   size.height.isFinite && size.height > 0 && size.height < CGFloat.greatestFiniteMagnitude
    NSLog("[StrokeText] hasExplicitWidth: \(hasExplicitWidth)")

    // let containerWidth = resolvedContainerWidth(from: bounds.width)
    let containerWidth = bounds.width
    let availableLabelWidth =
      containerWidth
      - paddingInsets.left
      - paddingInsets.right
    let measured = measuredLabelSize(for: availableLabelWidth)

    let width =
      hasExplicitWidth
      ? containerWidth
      : (measured.width + paddingInsets.left + paddingInsets.right)
    let height = measured.height + paddingInsets.top + paddingInsets.bottom

    let newSize = CGSize(width: width, height: height)
    NSLog("[StrokeText] newSize: \(newSize)")

    if bounds.size.height != height {
      NSLog("[StrokeText] Updating size in bridge")
      bridge?.uiManager.setSize(newSize, for: self)
    }
  }

  // MARK: - Props

  @objc var text: String = "" {
    didSet {
      if text != oldValue {
        NSLog("[StrokeText] text changed: \(text)")
        updateAttributedText()
        invalidateLayout()
      }
    }
  }

  @objc var ellipsis: Bool = false {
    didSet {
      if ellipsis != oldValue {
        label.lineBreakMode = ellipsis ? .byTruncatingTail : .byWordWrapping
        invalidateLayout()
      }
    }
  }

  @objc var numberOfLines: NSNumber = 0 {
    didSet {
      if numberOfLines != oldValue {
        label.numberOfLines = Int(truncating: numberOfLines)
        invalidateLayout()
      }
    }
  }

  @objc var strokeColor: String = "#FFFFFF" {
    didSet {
      label.outlineColor = StrokeTextView.colorStringToUIColor(colorString: strokeColor)
      label.setNeedsDisplay()
    }
  }

  @objc var strokeWidth: NSNumber = 0 {
    didSet {
      if strokeWidth != oldValue {
        label.outlineWidth = CGFloat(truncating: strokeWidth)
        invalidateLayout()
      }
    }
  }

  @objc var opacity: NSNumber = 1 {
    didSet {
      if opacity != oldValue {
        alpha = CGFloat(truncating: opacity)
      }
    }
  }

  // MARK: - Helpers

  func invalidateLayout() {
    // NSLog("[StrokeText] invalidateLayout()")

    guard !needsLayoutUpdate else {
      // NSLog("[StrokeText] already scheduled, skipping")
      return
    }

    needsLayoutUpdate = true

    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
      self.needsLayoutUpdate = false
      NSLog("[StrokeText] layout invalidated")
    }
  }

  // private func resolvedContainerWidth(from candidate: CGFloat) -> CGFloat {
  //   let fallbackWidth = window?.bounds.width ?? UIScreen.main.bounds.width
  //   return candidate > 0 ? candidate : fallbackWidth
  // }

  private func measuredLabelSize(for containerWidth: CGFloat) -> CGSize {
    let availableWidth = max(containerWidth - label.outlineWidth * 2, 0)
    NSLog("[StrokeText] measuredLabelSize(availableWidth): \(availableWidth)")

    label.preferredMaxLayoutWidth = availableWidth
    label.setNeedsLayout()
    label.layoutIfNeeded()

    let labelSize = label.intrinsicContentSize
    NSLog("[StrokeText] measuredLabelSize(label.intrinsicContentSize): \(labelSize)")

    return CGSize(
      width: labelSize.width,
      height: labelSize.height
    )
  }
}
