# React Native Stroke Text

[![npm version](https://badge.fury.io/js/react-native-stroke-text.svg)](https://badge.fury.io/js/react-native-stroke-text) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Add stylish stroked (outlined) text to your React Native apps. Perfect for overlaying readable, high-contrast text on images, videos, or any busy backgrounds.

This is the most comprehensive and actively maintained stroke text library for React Native. It uses native components for optimal performance and supports both iOS and Android (no web support for expo yet).

<table>
  <tr>
    <td>
      <img src="docs/IMG_3495.jpeg" alt="StrokeText preview - multiline display text" height="100" />
    </td>
    <td>
      <img src="docs/IMG_3494.jpeg" alt="StrokeText preview - label" height="100" />
    </td>
  </tr>
</table>

- [Examples 📷](#examples)


## Table of Contents

- [React Native Stroke Text](#react-native-stroke-text)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Installation](#installation)
    - [Expo (Managed)](#expo-managed)
    - [Bare React Native](#bare-react-native)
    - [Android](#android)
  - [Usage](#usage)
  - [Examples](#examples)
  - [API](#api)
    - [Core Props](#core-props)
    - [Text Style Props](#text-style-props)
    - [Layout \& View Props](#layout--view-props)
  - [Ellipsis \& Truncation](#ellipsis--truncation)
  - [Custom Fonts](#custom-fonts)
    - [Expo (expo-font)](#expo-expo-font)
    - [Bare React Native](#bare-react-native-1)
  - [Technical Details](#technical-details)
    - [Underlying Native Components Used:](#underlying-native-components-used)
  - [Troubleshooting](#troubleshooting)
  - [Contributing](#contributing)
  - [License](#license)
  - [Acknowledgements](#acknowledgements)
  - [Roadmap](#roadmap)


## Features

* ✔️ Stroke (outline) + fill for text
* ✔️ Cross-platform (iOS & Android)
* ✔️ Auto-linking support in RN 0.60+
* ✔️ Works in Expo managed workflow
* ✔️ Custom fonts, transforms, decorations, letter spacing, line height, opacity, etc.

## Installation

### Expo (Managed)

```bash
npx expo install react-native-stroke-text
```

### Bare React Native

```bash
# npm
npm install react-native-stroke-text

# or yarn
yarn add react-native-stroke-text
```

After installing the package:

```bash
cd ios && pod install && cd ..
```

### Android

* **Minimum** `compileSdkVersion` 34
* Autolinking should handle everything; no further steps required.


## Usage

```jsx
import React from "react";
import { View } from "react-native";
import { StrokeText } from "react-native-stroke-text";

export default function Example() {
  const commonStyle = {
    width: "100%",
    color: "#000",
    fontFamily: "Helvetica-Black",
    fontSize: 40,
    fontWeight: "400",
    fontStyle: "normal",
    textAlign: "center",
    textTransform: "uppercase",
    textDecorationLine: "underline",
    lineHeight: 50,
    letterSpacing: 2,
    padding: 10,
    paddingHorizontal: 20,
    paddingBottom: 15,
    opacity: 0.9,
  };

  return (
    <View style={{ flex: 1, justifyContent: "center" }}>
      {/* Using `text` prop */}
      <StrokeText
        text="Hello"
        strokeColor="#FFF"
        strokeWidth={8}
        numberOfLines={1}
        ellipsis={true}
        style={commonStyle}
      />

      {/* Using children */}
      <StrokeText
        strokeColor="#0A0"
        strokeWidth={10}
        numberOfLines={1}
        ellipsis={true}
        style={commonStyle}
      >
        World
      </StrokeText>

      {/* Multiline */}
      <StrokeText
        strokeColor="red"
        strokeWidth={5}
        numberOfLines={0}
        style={commonStyle}
      >
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </StrokeText>
    </View>
  );
}
```

## Examples

<table width="100%" max-width="900px">
  <tr valign="top">
    <td width="40%">
      <img src="docs/IMG_3486.PNG" alt="StrokeText preview - label" width="100%" />
    </td>
    <td width="60%">
      <img src="docs/IMG_3495.jpeg" alt="StrokeText preview - multiline display text" width="100%" /><br/>
      <img src="docs/IMG_3494.jpeg" alt="StrokeText preview - label" width="100%" />
    </td>
  </tr>
</table>

## API

### Core Props

| Prop                    | Type      | Default  | Description                                                  |
| ----------------------- | --------- | -------- | ------------------------------------------------------------ |
| `text`                  | `string`  | —        | Text content. Either set via `text` prop or as string child. |
| `color`                 | `string`  | `"#000"` | Text color (any valid CSS color). Can also be set in styles. |
| `strokeColor`           | `string`  | `"#FFF"` | Outline color (any valid CSS color).                         |
| `strokeWidth`           | `number`  | `0`      | Thickness of the outline.                                    |
| `numberOfLines`         | `number`  | `0`      | Maximum number of lines (`0` = unlimited).                   |
| `ellipsis`              | `boolean` | `false`  | Truncate overflow with “…” when exceeding `numberOfLines`.   |
| `maxFontSizeMultiplier` | `number`  | `null`   | Accessibility font scaling limit.                            |

### Text Style Props

Extends React Native’s [`TextStyle`](https://reactnative.dev/docs/text-style):

| Prop                 | Type     | Default        | Description                               |
| -------------------- | -------- | -------------- | ----------------------------------------- |
| `color`              | `string` | `"#000"`       | Fill color of the text.                   |
| `fontSize`           | `number` | System default | Font size (points).                       |
| `fontWeight`         | `string` | `"400"`        | Font weight (e.g. `"400"`, `"bold"`).     |
| `fontFamily`         | `string` | `"System"`     | Font family name.                         |
| `fontStyle`          | `string` | `"normal"`     | `"normal"` or `"italic"`.                 |
| `letterSpacing`      | `number` | `0`            | Spacing between characters.               |
| `lineHeight`         | `number` | `null`         | Line height (points).                     |
| `textAlign`          | `string` | `"left"`       | `"left"`, `"center"`, or `"right"`.       |
| `textDecorationLine` | `string` | `"none"`       | `"underline"`, `"line-through"`, or both. |
| `textTransform`      | `string` | `"none"`       | `"uppercase"`, `"lowercase"`, etc.        |
| `opacity`            | `number` | `1`            | Transparency of text (0–1).               |

### Layout & View Props

| Prop                | Type               | Default | Description           |
| ------------------- | ------------------ | ------- | --------------------- |
| `width`             | `number \| string` | `auto`  | Container width.      |
| `height`            | `number \| string` | `auto`  | Container height.     |
| `padding`           | `number`           | `0`     | All-sides padding.    |
| `paddingVertical`   | `number`           | `0`     | Top & bottom padding. |
| `paddingHorizontal` | `number`           | `0`     | Left & right padding. |
| `paddingTop`        | `number`           | `0`     | Top padding.          |
| `paddingBottom`     | `number`           | `0`     | Bottom padding.       |
| `paddingLeft`       | `number`           | `0`     | Left padding.         |
| `paddingRight`      | `number`           | `0`     | Right padding.        |

## Ellipsis & Truncation

Enable `ellipsis` when you want overflow text to be truncated with an ellipsis:

```jsx
<StrokeText
  text="A very long piece of text that might overflow"
  width={150}
  numberOfLines={1}
  ellipsis
/>
```

## Custom Fonts

### Expo ([expo-font](https://docs.expo.dev/versions/latest/sdk/font/))

```tsx
import { useFonts } from "expo-font";
import { Inter_400Regular } from "@expo-google-fonts/inter";

const [loaded] = useFonts({
  Inter: require("./assets/fonts/Inter-Regular.ttf"),
  "Inter-Regular": Inter_400Regular,
});

if (!loaded) return null;

<StrokeText
  text="Custom Font"
  fontFamily="Inter"
  fontSize={32}
  strokeColor="#FFF"
  strokeWidth={2}
/>;
```

### Bare React Native

1. Create or update `react-native.config.js` in project root:

   ```js
   module.exports = {
     project: {
       ios: {},
       android: {},
     },
     assets: ["./assets/fonts"],
   };
   ```

2. Place your `.ttf` files under `assets/fonts/`, then run:

   ```bash
   npx react-native link
   ```

## Technical Details

This package uses the "old" React Native architecture, which is stable and widely supported (and used by Expo). It leverages native components for rendering text with stroke effects efficiently.

One there is a stable release of the new architecture with wider adoption, we will migrate.

### Underlying Native Components Used:

* **iOS** -> `UILabel` wrapped in `RCTView` (extends `UIView`)
* **Android** -> `View` rendering text on a `Canvas` with `TextPaint`

## Troubleshooting

* **Stroke not visible?**
  Ensure `strokeWidth > 0` and that your `strokeColor` contrasts with the background.

* **Custom font not loading?**
  Verify the font family name matches the file’s internal name and that you’ve added it correctly in Xcode or `react-native.config.js`.

* **Android build errors?**
  Confirm `compileSdkVersion` is at least 34 and that Gradle has picked up the new package.

## Contributing

Contributions are welcome! Please:

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m "Add YourFeature"`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

Please review [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Acknowledgements

Inspired by [charmy/react-native-stroke-text](https://github.com/charmy/react-native-stroke-text). This version provides many improvements, bug fixes, and new features.

Thanks to all contributors and the React Native community!

## Roadmap
- [ ] Migrate to the new RN architecture (Fabric)
- [ ] Add support for web (Expo)
