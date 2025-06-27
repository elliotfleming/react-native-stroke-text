// ios/StrokeTextViewManager.m

#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE (StrokeTextViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(text, NSString)

// Only maps props.color, not style.color!
// RCT_EXPORT_VIEW_PROPERTY(color, NSString)
// Maps both props.color and style.color
RCT_REMAP_VIEW_PROPERTY(color, color, NSString)

// Style-related
RCT_EXPORT_VIEW_PROPERTY(fontSize, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(fontWeight, NSString)
RCT_EXPORT_VIEW_PROPERTY(fontFamily, NSString)
RCT_EXPORT_VIEW_PROPERTY(fontStyle, NSString)
RCT_EXPORT_VIEW_PROPERTY(letterSpacing, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(lineHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(textAlign, NSString)
RCT_EXPORT_VIEW_PROPERTY(textDecorationLine, NSString)
RCT_EXPORT_VIEW_PROPERTY(textTransform, NSString)
RCT_EXPORT_VIEW_PROPERTY(opacity, NSNumber)

// Stroke
RCT_EXPORT_VIEW_PROPERTY(strokeColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(strokeWidth, NSNumber)

// Layout
RCT_EXPORT_VIEW_PROPERTY(numberOfLines, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(ellipsis, BOOL)

// Padding support
RCT_EXPORT_VIEW_PROPERTY(padding, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(paddingVertical, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(paddingHorizontal, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(paddingTop, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(paddingBottom, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(paddingLeft, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(paddingRight, NSNumber)

// Accessibility (optional for later)
RCT_EXPORT_VIEW_PROPERTY(maxFontSizeMultiplier, NSNumber)

@end
