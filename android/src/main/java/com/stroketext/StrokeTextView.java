package com.stroketext;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.View;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.UIManagerModule;

import java.util.HashMap;
import java.util.Map;

class StrokeTextView extends View {
    /* -------- core state -------- */
    private String text = "";
    private float fontSize = 14;
    private String fontWeight = "400";
    private String fontStyle = "normal";
    private int textColor = 0xFF000000;
    private int strokeColor = 0xFFFFFFFF;
    private float strokeWidth = 1;
    private float letterSpacing = 0;
    private float lineHeight = 0;
    private String textDecorationLine = "none";
    private String textTransform = "none";
    private String fontFamily = "sans-serif";
    private int numberOfLines = 0;
    private boolean ellipsis = false;
    private float opacity = 1f;
    private Float maxFontSizeMultiplier = null;

    /* padding props */
    private Float padding, paddingVertical, paddingHorizontal,
            paddingTop, paddingBottom, paddingLeft, paddingRight;

    /* internals */
    private final TextPaint textPaint;
    private final TextPaint strokePaint;
    private Layout.Alignment alignment = Layout.Alignment.ALIGN_NORMAL;
    private StaticLayout textLayout;
    private StaticLayout strokeLayout;
    private boolean layoutDirty = true;
    private final Map<String, Typeface> fontCache = new HashMap<>();

    public StrokeTextView(ThemedReactContext context) {
        super(context);
        textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
        strokePaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
    }

    /* -------- layout helpers -------- */

    private float resolved(Float specific, Float axis, Float all) {
        return specific != null ? specific
                : axis != null ? axis
                : all != null ? all : 0f;
    }

    private float padLeft()   { return resolved(paddingLeft,  paddingHorizontal, padding); }
    private float padRight()  { return resolved(paddingRight, paddingHorizontal, padding); }
    private float padTop()    { return resolved(paddingTop,   paddingVertical,   padding); }
    private float padBottom() { return resolved(paddingBottom,paddingVertical,   padding); }

    private void ensureLayout() {
        if (!layoutDirty) return;

        /* typeface */
        boolean bold = false;
        if ("bold".equalsIgnoreCase(fontWeight)) {
            bold = true;
        } else {
            // numeric weight? interpret ≥600 as bold
            try {
                int w = Integer.parseInt(fontWeight);
                if (w >= 600) bold = true;
            } catch (NumberFormatException ignored) { /* keep false */ }
        }

        boolean italic = "italic".equalsIgnoreCase(fontStyle);

        int style = (bold ? Typeface.BOLD : Typeface.NORMAL) |
            (italic ? Typeface.ITALIC : Typeface.NORMAL);

        Typeface tf = Typeface.create(base, style);

        /* text paint */
        textPaint.setTypeface(tf);
        textPaint.setTextSize(fontSize);
        textPaint.setColor(textColor);
        textPaint.setLetterSpacing(letterSpacing / fontSize);

        textPaint.setUnderlineText(textDecorationLine.contains("underline"));
        textPaint.setStrikeThruText(textDecorationLine.contains("line-through"));

        /* stroke paint mirrors text paint */
        strokePaint.setStyle(Paint.Style.STROKE);
        strokePaint.setStrokeJoin(Paint.Join.ROUND);
        strokePaint.setStrokeCap(Paint.Cap.ROUND);
        strokePaint.setStrokeWidth(strokeWidth);
        strokePaint.setColor(strokeColor);
        strokePaint.setTypeface(tf);
        strokePaint.setTextSize(fontSize);

        /* width calculation */
        int avail = getWidth() > 0
                ? Math.max(getWidth() - Math.round(padLeft() + padRight()), 0)
                : (int) measureTextWidth();

        /* apply text transform & ellipsis */
        CharSequence src = applyTextTransform(text);
        CharSequence el = ellipsis ? TextUtils.ellipsize(src, textPaint, avail, TextUtils.TruncateAt.END) : src;

        textLayout   = new StaticLayout(el, textPaint,   avail, alignment, 1.0f, 0.0f, false);
        strokeLayout = new StaticLayout(el, strokePaint, avail, alignment, 1.0f, 0.0f, false);

        if (numberOfLines > 0 && numberOfLines < textLayout.getLineCount()) {
            int end = textLayout.getLineEnd(numberOfLines - 1);
            el = el.subSequence(0, end);
            textLayout   = new StaticLayout(el, textPaint,   avail, alignment, 1.0f, 0.0f, false);
            strokeLayout = new StaticLayout(el, strokePaint, avail, alignment, 1.0f, 0.0f, false);
        }

        layoutDirty = false;
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        layoutDirty = true;
        ensureLayout();
    }

    private float measureTextWidth() {
        float max = 0f;
        for (String line : text.split("\n")) {
            max = Math.max(max, textPaint.measureText(line));
        }
        return max + strokeWidth / 2f;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        ensureLayout();
        canvas.save();
        canvas.translate(padLeft(), padTop());
        strokeLayout.draw(canvas);
        textLayout.draw(canvas);
        canvas.restore();
        updateSize(
                (int) (textLayout.getWidth() + padLeft() + padRight()),
                (int) (textLayout.getHeight() + padTop() + padBottom())
        );
    }

    private float getScaledSize(float size) {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, size, getResources().getDisplayMetrics());
    }

    private void updateSize(int width, int height) {
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.runOnNativeModulesQueueThread(() -> {
            UIManagerModule uiManager = reactContext.getNativeModule(UIManagerModule.class);
            if (uiManager != null) {
                uiManager.updateNodeSize(getId(), width, height);
            }
        });
    }

    /* -------- setters -------- */

    public void setText(String value) {
        if (!text.equals(value)) {
            text = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setFontSize(float value) {
        float px = getScaledSize(value);
        if (fontSize != px) {
            fontSize = px;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setFontWeight(String value) {
        if (!fontWeight.equals(value)) {
            fontWeight = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setTextColor(String color) {
        int parsed = parseColor(color);
        if (textColor != parsed) {
            textColor = parsed;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setStrokeColor(String color) {
        int parsed = parseColor(color);
        if (strokeColor != parsed) {
            strokeColor = parsed;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setStrokeWidth(float value) {
        float px = getScaledSize(value);
        if (strokeWidth != px) {
            strokeWidth = px;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setFontFamily(String value) {
        if (!fontFamily.equals(value)) {
            fontFamily = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setTextAlignment(String align) {
        Layout.Alignment newAlign = alignment;
        if ("left".equals(align)) {
            newAlign = Layout.Alignment.ALIGN_NORMAL;
        } else if ("right".equals(align)) {
            newAlign = Layout.Alignment.ALIGN_OPPOSITE;
        } else if ("center".equals(align)) {
            newAlign = Layout.Alignment.ALIGN_CENTER;
        }

        if (alignment != newAlign) {
            alignment = newAlign;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setNumberOfLines(int value) {
        if (numberOfLines != value) {
            numberOfLines = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setEllipsis(boolean value) {
        if (ellipsis != value) {
            ellipsis = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setFontStyle(String value) {
        if (!fontStyle.equals(value)) {
            fontStyle = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setLetterSpacing(float value) {
        float px = getScaledSize(value);
        if (letterSpacing != px) {
            letterSpacing = px;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setLineHeight(float value) {
        float px = getScaledSize(value);
        if (lineHeight != px) {
            lineHeight = px;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setTextDecorationLine(String value) {
        if (!textDecorationLine.equals(value)) {
            textDecorationLine = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setTextTransform(String value) {
        if (!textTransform.equals(value)) {
            textTransform = value;
            layoutDirty = true;
            invalidate();
        }
    }

    public void setOpacity(float value) {
        if (opacity != value) {
            opacity = value;
            setAlpha(value);
        }
    }

    public void setMaxFontSizeMultiplier(float value) {
        maxFontSizeMultiplier = value; // parity field; no-op
    }

    public void setPadding(float value) {
        padding = getScaledSize(value);
        layoutDirty = true;
        invalidate();
    }

    public void setPaddingVertical(float value) {
        paddingVertical = getScaledSize(value);
        layoutDirty = true;
        invalidate();
    }

    public void setPaddingHorizontal(float value) {
        paddingHorizontal = getScaledSize(value);
        layoutDirty = true;
        invalidate();
    }

    public void setPaddingTop(float value) {
        paddingTop = getScaledSize(value);
        layoutDirty = true;
        invalidate();
    }

    public void setPaddingBottom(float value) {
        paddingBottom = getScaledSize(value);
        layoutDirty = true;
        invalidate();
    }

    public void setPaddingLeft(float value) {
        paddingLeft = getScaledSize(value);
        layoutDirty = true;
        invalidate();
    }

    public void setPaddingRight(float value) {
        paddingRight = getScaledSize(value);
        layoutDirty = true;
        invalidate();
    }

    /* -------- helpers -------- */

    private CharSequence applyTextTransform(String input) {
        switch (textTransform.toLowerCase()) {
            case "uppercase": return input.toUpperCase();
            case "lowercase": return input.toLowerCase();
            case "capitalize": return capitalizeWords(input);
            default: return input;
        }
    }

    private static String capitalizeWords(String input) {
        StringBuilder sb = new StringBuilder(input.length());
        boolean cap = true;
        for (char c : input.toCharArray()) {
            if (Character.isWhitespace(c)) {
                cap = true;
                sb.append(c);
            } else {
                sb.append(cap ? Character.toTitleCase(c) : c);
                cap = false;
            }
        }
        return sb.toString();
    }

    private int parseColor(String color) {
        if (color.startsWith("#")) return Color.parseColor(color);
        if (color.startsWith("rgb")) return parseRgbColor(color);
        return 0xFF000000;
    }

    private int parseRgbColor(String color) {
        String[] parts = color.replaceAll("[rgba()\\s]", "").split(",");
        int r = Integer.parseInt(parts[0]);
        int g = Integer.parseInt(parts[1]);
        int b = Integer.parseInt(parts[2]);
        int a = parts.length > 3 ? (int) (Float.parseFloat(parts[3]) * 255) : 255;
        return Color.argb(a, r, g, b);
    }

    private Typeface getFont(String family) {
        if (fontCache.containsKey(family)) return fontCache.get(family);
        Typeface tf = FontUtil.getFont(getContext(), family);
        fontCache.put(family, tf);
        return tf;
    }
}
