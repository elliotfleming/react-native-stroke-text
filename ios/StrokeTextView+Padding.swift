// StrokeTextView+Padding.swift

import UIKit

extension StrokeTextView {
  @objc var padding: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.padding) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.padding, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updatePaddingConstraints()
    }
  }

  @objc var paddingVertical: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.paddingVertical) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.paddingVertical, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updatePaddingConstraints()
    }
  }

  @objc var paddingHorizontal: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.paddingHorizontal) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.paddingHorizontal, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updatePaddingConstraints()
    }
  }

  @objc var paddingTop: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.paddingTop) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.paddingTop, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updatePaddingConstraints()
    }
  }

  @objc var paddingBottom: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.paddingBottom) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.paddingBottom, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updatePaddingConstraints()
    }
  }

  @objc var paddingLeft: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.paddingLeft) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.paddingLeft, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updatePaddingConstraints()
    }
  }

  @objc var paddingRight: NSNumber? {
    get { objc_getAssociatedObject(self, &AssociatedKeys.paddingRight) as? NSNumber }
    set {
      objc_setAssociatedObject(
        self, &AssociatedKeys.paddingRight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      updatePaddingConstraints()
    }
  }

  private struct AssociatedKeys {
    static var padding = "padding"
    static var paddingVertical = "paddingVertical"
    static var paddingHorizontal = "paddingHorizontal"
    static var paddingTop = "paddingTop"
    static var paddingBottom = "paddingBottom"
    static var paddingLeft = "paddingLeft"
    static var paddingRight = "paddingRight"
  }

  internal func updatePaddingConstraints() {
    func value(_ n: NSNumber?) -> CGFloat {
      return n.map { CGFloat(truncating: $0) } ?? 0
    }

    let base = value(padding)
    let vertical = value(paddingVertical)
    let horizontal = value(paddingHorizontal)

    let top = value(paddingTop) != 0 ? value(paddingTop) : (vertical != 0 ? vertical : base)
    let bottom =
      value(paddingBottom) != 0 ? value(paddingBottom) : (vertical != 0 ? vertical : base)
    let left = value(paddingLeft) != 0 ? value(paddingLeft) : (horizontal != 0 ? horizontal : base)
    let right =
      value(paddingRight) != 0 ? value(paddingRight) : (horizontal != 0 ? horizontal : base)

    paddingInsets = UIEdgeInsets(
      top: top,
      left: left,
      bottom: bottom,
      right: right
    )

    invalidateLayout()
  }
}
