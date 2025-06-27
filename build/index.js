// src/index.tsx
import React from "react";
import { requireNativeComponent } from "react-native";
const ComponentName = "StrokeTextView";
const NativeStrokeText = requireNativeComponent(ComponentName);
export const StrokeText = ({ children, text, ...rest }) => {
    const resolvedText = text ?? (typeof children === "string" ? children : undefined);
    // Dev warning if children are passed but are not a string
    if (__DEV__ && children && typeof children !== "string") {
        console.warn("[StrokeText] Children must be a string. Use the `text` prop instead for non-string content.");
    }
    return <NativeStrokeText {...rest} text={resolvedText ?? ""}/>;
};
//# sourceMappingURL=index.js.map