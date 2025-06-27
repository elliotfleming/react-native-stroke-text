// src/index.tsx

import React from "react";
import { requireNativeComponent, StyleProp, TextStyle } from "react-native";

const ComponentName = "StrokeTextView";

export interface StrokeTextProps {
  // Component props
  children?: React.ReactNode;
  text?: string;
  strokeColor?: string;
  strokeWidth?: number;
  numberOfLines?: number;
  ellipsis?: boolean;
  maxFontSizeMultiplier?: number;

  // Text style props
  style?: StyleProp<TextStyle>;
  fontSize?: TextStyle["fontSize"];
  fontWeight?: TextStyle["fontWeight"];
  fontFamily?: TextStyle["fontFamily"];
  fontStyle?: TextStyle["fontStyle"];
  color?: TextStyle["color"];
  lineHeight?: TextStyle["lineHeight"];
  letterSpacing?: TextStyle["letterSpacing"];
  textAlign?: TextStyle["textAlign"];
  textDecorationLine?: TextStyle["textDecorationLine"];
  textTransform?: TextStyle["textTransform"];
  opacity?: TextStyle["opacity"];

  // View style props
  padding?: number;
  paddingVertical?: number;
  paddingHorizontal?: number;
  paddingTop?: number;
  paddingBottom?: number;
  paddingLeft?: number;
  paddingRight?: number;
}

const NativeStrokeText = requireNativeComponent<StrokeTextProps>(ComponentName);

export const StrokeText = ({ children, text, ...rest }: StrokeTextProps) => {
  const resolvedText = text ?? (typeof children === "string" ? children : undefined);

  // Dev warning if children are passed but are not a string
  if (__DEV__ && children && typeof children !== "string") {
    console.warn("[StrokeText] Children must be a string. Use the `text` prop instead for non-string content.");
  }

  return <NativeStrokeText {...rest} text={resolvedText ?? ""} />;
};
