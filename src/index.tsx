import React from "react";
import { requireNativeComponent, StyleProp, ViewStyle } from "react-native";

const ComponentName = "StrokeTextView";

type TextAlign = "center" | "left" | "right";

export interface StrokeTextProps {
  text: string;
  fontSize?: number;
  fontWeight?: string;
  color?: string;
  strokeColor?: string;
  strokeWidth?: number;
  fontFamily?: string;
  align?: TextAlign;
  numberOfLines?: number;
  ellipsis?: boolean;
  style?: StyleProp<ViewStyle>;
}

const NativeStrokeText = requireNativeComponent<StrokeTextProps>(ComponentName);

export const StrokeText = (props: StrokeTextProps) => {
  return <NativeStrokeText {...props} />;
};
