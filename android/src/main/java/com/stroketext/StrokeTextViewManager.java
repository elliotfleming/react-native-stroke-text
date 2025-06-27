package com.stroketext;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

/**
 * View-manager for <StrokeTextView>, exposing all props now available on iOS/TS.
 */
public class StrokeTextViewManager extends SimpleViewManager<StrokeTextView> {

    public static final String REACT_CLASS = "StrokeTextView";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public StrokeTextView createViewInstance(ThemedReactContext reactContext) {
        return new StrokeTextView(reactContext);
    }

    /* -------- Core text props -------- */

    @ReactProp(name = "text")
    public void setText(StrokeTextView view, String value) {
        view.setText(value);
    }

    @ReactProp(name = "fontSize")
    public void setFontSize(StrokeTextView view, float value) {
        view.setFontSize(value);
    }

    @ReactProp(name = "fontWeight")
    public void setFontWeight(StrokeTextView view, String value) {
        view.setFontWeight(value);
    }

    @ReactProp(name = "fontFamily")
    public void setFontFamily(StrokeTextView view, String value) {
        view.setFontFamily(value);
    }

    @ReactProp(name = "fontStyle")
    public void setFontStyle(StrokeTextView view, String value) {
        view.setFontStyle(value);
    }

    /* -------- Colour & stroke -------- */

    @ReactProp(name = "color")
    public void setColor(StrokeTextView view, String value) {
        view.setTextColor(value);
    }

    @ReactProp(name = "strokeColor")
    public void setStrokeColor(StrokeTextView view, String value) {
        view.setStrokeColor(value);
    }

    @ReactProp(name = "strokeWidth")
    public void setStrokeWidth(StrokeTextView view, float value) {
        view.setStrokeWidth(value);
    }

    /* -------- Typography extras -------- */

    @ReactProp(name = "lineHeight")
    public void setLineHeight(StrokeTextView view, float value) {
        view.setLineHeight(value);
    }

    @ReactProp(name = "letterSpacing")
    public void setLetterSpacing(StrokeTextView view, float value) {
        view.setLetterSpacing(value);
    }

    @ReactProp(name = "textAlign")
    public void setTextAlign(StrokeTextView view, String value) {
        view.setTextAlignment(value);
    }

    @ReactProp(name = "textDecorationLine")
    public void setTextDecorationLine(StrokeTextView view, String value) {
        view.setTextDecorationLine(value);
    }

    @ReactProp(name = "textTransform")
    public void setTextTransform(StrokeTextView view, String value) {
        view.setTextTransform(value);
    }

    /* -------- Layout & behaviour -------- */

    @ReactProp(name = "numberOfLines")
    public void setNumberOfLines(StrokeTextView view, int value) {
        view.setNumberOfLines(value);
    }

    @ReactProp(name = "ellipsis")
    public void setEllipsis(StrokeTextView view, boolean value) {
        view.setEllipsis(value);
    }

    @ReactProp(name = "opacity", defaultFloat = 1f)
    public void setOpacity(StrokeTextView view, float value) {
        view.setOpacity(value);
    }

    @ReactProp(name = "maxFontSizeMultiplier")
    public void setMaxFontSizeMultiplier(StrokeTextView view, float value) {
        view.setMaxFontSizeMultiplier(value);
    }

    /* -------- Padding -------- */

    @ReactProp(name = "padding")
    public void setPadding(StrokeTextView view, float value) {
        view.setPadding(value);
    }

    @ReactProp(name = "paddingVertical")
    public void setPaddingVertical(StrokeTextView view, float value) {
        view.setPaddingVertical(value);
    }

    @ReactProp(name = "paddingHorizontal")
    public void setPaddingHorizontal(StrokeTextView view, float value) {
        view.setPaddingHorizontal(value);
    }

    @ReactProp(name = "paddingTop")
    public void setPaddingTop(StrokeTextView view, float value) {
        view.setPaddingTop(value);
    }

    @ReactProp(name = "paddingBottom")
    public void setPaddingBottom(StrokeTextView view, float value) {
        view.setPaddingBottom(value);
    }

    @ReactProp(name = "paddingLeft")
    public void setPaddingLeft(StrokeTextView view, float value) {
        view.setPaddingLeft(value);
    }

    @ReactProp(name = "paddingRight")
    public void setPaddingRight(StrokeTextView view, float value) {
        view.setPaddingRight(value);
    }
}
