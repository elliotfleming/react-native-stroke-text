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
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += outlineWidth * 2
        size.height += outlineWidth * 2
        return size
    }
}
