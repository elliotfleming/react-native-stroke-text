// StrokeTextView+TextStyles.swift

import UIKit

extension StrokeTextView {
  @objc var color: String {
    get { objc_getAssociatedObject(self, &AssociatedKeys.color) as? String ?? "#000000" }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.color, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      label.textColor = StrokeTextView.colorStringToUIColor(colorString: newValue)
      updateAttributedText()
    }
  }

  @objc var lineHeight: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.lineHeight) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.lineHeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updateAttributedText()
    }
  }

  @objc var letterSpacing: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.letterSpacing) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.letterSpacing, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updateAttributedText()
    }
  }

  @objc var textAlign: String {
    get { objc_getAssociatedObject(self, &AssociatedKeys.textAlign) as? String ?? "center" }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.textAlign, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      switch newValue.lowercased() {
      case "left": label.textAlignment = .left
      case "right": label.textAlignment = .right
      case "center": label.textAlignment = .center
      default: label.textAlignment = .left
      }
      updateAttributedText()
    }
  }

  @objc var textTransform: String {
    get { objc_getAssociatedObject(self, &AssociatedKeys.textTransform) as? String ?? "none" }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.textTransform, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updateAttributedText()
    }
  }

  @objc var textDecorationLine: String {
    get { objc_getAssociatedObject(self, &AssociatedKeys.textDecorationLine) as? String ?? "none" }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.textDecorationLine, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updateAttributedText()
    }
  }

  private struct AssociatedKeys {
    static var color = "color"
    static var letterSpacing = "letterSpacing"
    static var lineHeight = "lineHeight"
    static var textAlign = "textAlign"
    static var textDecorationLine = "textDecorationLine"
    static var textTransform = "textTransform"
  }

  internal func updateAttributedText() {
    let transformed = applyTextTransform(to: text)
    let style = NSMutableParagraphStyle()

    if let lh = lineHeight {
      let height = CGFloat(truncating: lh)
      style.minimumLineHeight = height
      style.maximumLineHeight = height
    }

    style.alignment = label.textAlignment

    var attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .kern: CGFloat(truncating: letterSpacing ?? 0),
      .font: label.font,
      .foregroundColor: label.textColor ?? UIColor.black,
    ]

    switch textDecorationLine.lowercased() {
    case "underline":
      attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
    case "line-through":
      attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
    case "underline line-through", "line-through underline", "underlinelinethrough",
      "linethroughunderline":
      attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
      attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
    default:
      break
    }

    // Don't do this - it looks like hot garbage!
    // compared to using drawText(in:)
    // if label.outlineWidth > 0 {
    //   attributes[.strokeWidth] = -label.outlineWidth
    //   attributes[.strokeColor] = label.outlineColor
    // }

    label.attributedText = NSAttributedString(string: transformed, attributes: attributes)

    label.setNeedsDisplay()
  }

  private func applyTextTransform(to input: String) -> String {
    switch textTransform.lowercased() {
    case "uppercase": return input.uppercased()
    case "lowercase": return input.lowercased()
    case "capitalize": return input.capitalized
    default: return input
    }
  }

  internal static func colorStringToUIColor(colorString: String) -> UIColor {
    let trimmed = colorString.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmed.hasPrefix("#") {
      var hex = String(trimmed.dropFirst())

      // Expand shorthand #RGB to #RRGGBB
      if hex.count == 3 {
        hex = hex.map { "\($0)\($0)" }.joined()
      }

      guard hex.count == 6 else {
        print("Invalid hex color format: \(colorString)")
        return .gray
      }

      var rgbValue: UInt64 = 0
      let scanner = Scanner(string: hex)
      guard scanner.scanHexInt64(&rgbValue) else {
        print("Unable to scan hex color: \(colorString)")
        return .gray
      }

      return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: 1.0
      )
    }

    if trimmed.lowercased().hasPrefix("rgba(") {
      let components = trimmed.dropFirst(5).dropLast(1).split(separator: ",").map {
        CGFloat(Double($0.trimmingCharacters(in: .whitespaces)) ?? 0)
      }

      if components.count == 4 {
        return UIColor(
          red: components[0] / 255.0,
          green: components[1] / 255.0,
          blue: components[2] / 255.0,
          alpha: components[3]
        )
      }
    }

    if trimmed.lowercased().hasPrefix("rgb(") {
      let components = trimmed.dropFirst(4).dropLast(1).split(separator: ",").map {
        CGFloat(Double($0.trimmingCharacters(in: .whitespaces)) ?? 0)
      }

      if components.count == 3 {
        return UIColor(
          red: components[0] / 255.0,
          green: components[1] / 255.0,
          blue: components[2] / 255.0,
          alpha: 1.0
        )
      }
    }

    print("Unrecognized color format: \(colorString)")
    return .gray
  }
}
