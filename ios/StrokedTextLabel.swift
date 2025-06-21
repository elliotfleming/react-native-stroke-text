// ios/StrokedTextLabel.swift

import UIKit

class StrokedTextLabel: UILabel {

    // MARK: - Init
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
    }

    // MARK: - Internal stroke padding
    private var textInsets: UIEdgeInsets = .zero
    private func updateTextInsets() {
        textInsets = UIEdgeInsets(
            top: outlineWidth,
            left: outlineWidth,
            bottom: outlineWidth,
            right: outlineWidth
        )
    }

    // MARK: - Public knobs
    var outlineWidth: CGFloat = 0 { didSet { updateTextInsets() } }
    var outlineColor: UIColor = .clear
    var align: NSTextAlignment = .center
    var ellipsis: Bool = false

    // MARK: - Drawing
    override func drawText(in rect: CGRect) {
        let savedShadowOffset = self.shadowOffset  // rename to avoid shadowing
        let originalColor = textColor

        lineBreakMode = ellipsis ? .byTruncatingTail : .byWordWrapping
        let insetRect = rect.inset(by: textInsets)

        guard let ctx = UIGraphicsGetCurrentContext() else {
            super.drawText(in: insetRect)
            return
        }

        ctx.setLineWidth(outlineWidth)
        ctx.setLineJoin(.round)

        // Stroke
        ctx.setTextDrawingMode(.stroke)
        textAlignment = align
        textColor = outlineColor
        super.drawText(in: insetRect)

        // Fill
        ctx.setTextDrawingMode(.fill)
        textColor = originalColor
        self.shadowOffset = .zero
        super.drawText(in: insetRect)

        self.shadowOffset = savedShadowOffset  // restore
    }

    // MARK: - Size
    /// If > 0, wrap lines at this width when computing intrinsic size.
    var wrapWidth: CGFloat = 0 { didSet { invalidateIntrinsicContentSize() } }

    override var intrinsicContentSize: CGSize {
        // 1. Ask UILabel for its normal size first
        var size: CGSize

        if wrapWidth > 0 {
            // Constrain width, let UIKit compute height
            let rect =
                text?.boundingRect(
                    with: CGSize(width: wrapWidth, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: [.font: font as Any],
                    context: nil) ?? .zero
            size = CGSize(width: ceil(rect.width), height: ceil(rect.height))
        } else {
            size = super.intrinsicContentSize
        }

        // 2. Add one outline padding *once* (top+bottom, left+right)
        size.width += outlineWidth * 2
        size.height += outlineWidth * 2
        return size
    }
}
