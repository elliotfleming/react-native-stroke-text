// ios/StrokeTextView.swift

import Foundation
import UIKit

class StrokeTextView: RCTView {

    // MARK: - Properties
    weak var bridge: RCTBridge?
    public var label: StrokedTextLabel
    private var fontCache: [String: UIFont] = [:]

    // MARK: - init
    init(bridge: RCTBridge) {
        self.bridge = bridge
        label = StrokedTextLabel()
        super.init(frame: .zero)

        label.textColor = colorStringToUIColor(colorString: color)
        label.outlineColor = colorStringToUIColor(colorString: strokeColor)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // Storyboard/XIB not supported
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Report height to RN
    override func layoutSubviews() {
        super.layoutSubviews()

        // 1. Tell the label the width it must wrap within.
        label.preferredMaxLayoutWidth = bounds.width

        // 2. Measure height with that width constraint.
        let neededHeight = label.sizeThatFits(
            CGSize(
                width: bounds.width,
                height: .greatestFiniteMagnitude)
        ).height

        // 3. If either dimension differs, push the new size to RN.
        if bounds.height != neededHeight || bounds.width == 0 {
            let target = CGSize(
                width: bounds.width == 0 ? neededHeight : bounds.width,
                height: neededHeight)
            bridge?.uiManager.setSize(target, for: self)
        }
    }

    // MARK: - Properties
    @objc var text: String = "" {
        didSet {
            if text != oldValue {
                label.text = text
                label.setNeedsDisplay()
                label.invalidateIntrinsicContentSize()
                setNeedsLayout()
            }
        }
    }

    // MARK: - Font Size
    @objc var fontSize: NSNumber = 14 {
        didSet {
            if fontSize != oldValue {
                label.font = label.font.withSize(CGFloat(truncating: fontSize))
                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Font Weight
    @objc var fontWeight: String = "normal" {
        didSet {
            guard fontWeight != oldValue else { return }

            let weight: UIFont.Weight = {
                switch fontWeight {
                case "100", "thin": return .thin
                case "200", "light": return .light
                case "300", "ultralight": return .ultraLight
                case "400", "regular": return .regular
                case "500", "medium": return .medium
                case "600", "semibold": return .semibold
                case "bold", "700": return .bold
                case "800", "heavy": return .heavy
                case "900", "black": return .black
                default: return .regular
                }
            }()

            label.font = UIFont.systemFont(ofSize: CGFloat(truncating: fontSize), weight: weight)
            label.setNeedsDisplay()
        }
    }

    // MARK: - Color
    @objc var color: String = "#000000" {
        didSet {
            if color != oldValue {
                label.textColor = colorStringToUIColor(colorString: color)
                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Stroke Color
    @objc var strokeColor: String = "#FFFFFF" {
        didSet {
            if strokeColor != oldValue {
                label.outlineColor = colorStringToUIColor(colorString: strokeColor)
                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Stroke Width
    @objc var strokeWidth: NSNumber = 1 {
        didSet {
            if strokeWidth != oldValue {
                label.outlineWidth = CGFloat(truncating: strokeWidth)
                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Font Family
    @objc var fontFamily: String = "Helvetica" {
        didSet {
            if fontFamily != oldValue {
                let cacheKey = "\(fontFamily)-\(fontSize)"
                if let cachedFont = fontCache[cacheKey] {
                    label.font = cachedFont
                } else {
                    let newFont: UIFont?
                    if let reactFont = RCTFont.update(nil, withFamily: fontFamily) {
                        newFont = reactFont.withSize(CGFloat(truncating: fontSize))
                    } else {
                        newFont = UIFont(name: fontFamily, size: CGFloat(truncating: fontSize))
                    }
                    if let validFont = newFont {
                        fontCache[cacheKey] = validFont
                        label.font = validFont
                    }
                }

                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Alignment
    @objc var align: String = "center" {
        didSet {
            if align != oldValue {
                if align == "left" {
                    label.align = .left
                } else if align == "right" {
                    label.align = .right
                } else {
                    label.align = .center
                }

                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Ellipsis
    @objc var ellipsis: Bool = false {
        didSet {
            if ellipsis != oldValue {
                label.ellipsis = ellipsis
                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Number of Lines
    @objc var numberOfLines: NSNumber = 0 {
        didSet {
            if numberOfLines != oldValue {
                label.numberOfLines = Int(truncating: numberOfLines)
                label.setNeedsDisplay()
            }
        }
    }

    // MARK: - Helpers
    private func colorStringToUIColor(colorString: String) -> UIColor {
        var string = colorString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if string.hasPrefix("#") {
            if string.count == 4 {
                string = "#" + string.dropFirst().map { "\($0)\($0)" }.joined()
            }
            if string.count == 7 {
                var rgbValue: UInt64 = 0
                Scanner(string: String(string.dropFirst())).scanHexInt64(&rgbValue)
                return UIColor(
                    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                    alpha: 1.0
                )
            }
        } else if string.hasPrefix("RGBA") {
            let components = string.dropFirst(5).dropLast(1).split(separator: ",").map {
                CGFloat(Double($0.trimmingCharacters(in: .whitespaces)) ?? 0)
            }
            if components.count == 4 {
                return UIColor(
                    red: components[0] / 255.0, green: components[1] / 255.0,
                    blue: components[2] / 255.0, alpha: components[3])
            }
        } else if string.hasPrefix("RGB") {
            let components = string.dropFirst(4).dropLast(1).split(separator: ",").map {
                CGFloat(Double($0.trimmingCharacters(in: .whitespaces)) ?? 0)
            }
            if components.count == 3 {
                return UIColor(
                    red: components[0] / 255.0, green: components[1] / 255.0,
                    blue: components[2] / 255.0, alpha: 1.0)
            }
        }

        return UIColor.gray
    }
}
