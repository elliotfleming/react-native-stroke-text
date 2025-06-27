// StrokeTextView+Font.swift

import UIKit

extension StrokeTextView {
  @objc var fontFamily: String {
    get { return _fontFamily }
    set {
      _fontFamily = newValue
      updateFont()
      invalidateLayout()
    }
  }

  @objc var fontSize: NSNumber {
    get { return _fontSize }
    set {
      _fontSize = newValue
      updateFont()
      invalidateLayout()
    }
  }

  @objc var fontStyle: String {
    get { return _fontStyle }
    set {
      _fontStyle = newValue
      updateFont()
      updateAttributedText()
      invalidateLayout()
    }
  }

  @objc var fontWeight: String {
    get { return _fontWeight }
    set {
      _fontWeight = newValue
      updateFont()
      invalidateLayout()
    }
  }

  // MARK: - Vars

  private static let defaultFontSize = NSNumber(value: Float(UIFont.labelFontSize))

  private var _fontFamily: String {
    get { objc_getAssociatedObject(self, &AssociatedKeys.fontFamily) as? String ?? "System" }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.fontFamily, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  private var _fontSize: NSNumber {
    get {
      objc_getAssociatedObject(self, &AssociatedKeys.fontSize) as? NSNumber ?? Self.defaultFontSize
    }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.fontSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  private var _fontWeight: String {
    get { objc_getAssociatedObject(self, &AssociatedKeys.fontWeight) as? String ?? "regular" }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.fontWeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  private var _fontStyle: String {
    get { objc_getAssociatedObject(self, &AssociatedKeys.fontStyle) as? String ?? "normal" }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.fontStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  private struct AssociatedKeys {
    static var fontFamily = "fontFamily"
    static var fontSize = "fontSize"
    static var fontWeight = "fontWeight"
    static var fontStyle = "fontStyle"
  }

  // MARK: - Helpers

  internal func updateFont() {
    let size = CGFloat(truncating: fontSize)
    let weight = parsedWeight(fontWeight)
    let family = fontFamily
    let isItalic = fontStyle.lowercased() == "italic"
    let key = "\(family)-\(fontSize.stringValue)-\(weight.rawValue)-\(isItalic)"

    if let cached = fontCache[key] {
      label.font = cached
      return
    }

    var baseFont: UIFont?

    if family.lowercased() == "system" {
      baseFont = UIFont.systemFont(ofSize: size, weight: weight)
    } else {
      let weightedName = "\(family)-\(weightSuffix(for: weight))"
      baseFont =
        UIFont(name: weightedName, size: size)
        ?? UIFont(name: family, size: size)
    }

    if baseFont == nil {
      baseFont = UIFont.systemFont(ofSize: size, weight: weight)
    }

    if isItalic, let descriptor = baseFont?.fontDescriptor.withSymbolicTraits(.traitItalic) {
      baseFont = UIFont(descriptor: descriptor, size: size)
    }

    if let finalFont = baseFont {
      label.font = finalFont
      fontCache[key] = finalFont
    }
  }

  private func parsedWeight(_ weightString: String) -> UIFont.Weight {
    switch weightString.lowercased() {
    case "thin", "100": return .thin
    case "ultralight", "200": return .ultraLight
    case "light", "300": return .light
    case "regular", "400": return .regular
    case "medium", "500": return .medium
    case "semibold", "600": return .semibold
    case "bold", "700": return .bold
    case "heavy", "800": return .heavy
    case "black", "900": return .black
    default: return .regular
    }
  }

  private func weightSuffix(for weight: UIFont.Weight) -> String {
    switch weight {
    case .ultraLight: return "UltraLight"
    case .thin: return "Thin"
    case .light: return "Light"
    case .regular: return "Regular"
    case .medium: return "Medium"
    case .semibold: return "Semibold"
    case .bold: return "Bold"
    case .heavy: return "Heavy"
    case .black: return "Black"
    default: return "Regular"
    }
  }
}
