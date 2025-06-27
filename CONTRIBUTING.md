# Contributing to React Native Stroke Text

Thank you for your interest in contributing! We welcome issues, feature requests, and pull requests that help improve this library for everyone.

## Table of Contents

- [Contributing to React Native Stroke Text](#contributing-to-react-native-stroke-text)
  - [Table of Contents](#table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [How to Report a Bug](#how-to-report-a-bug)
  - [How to Suggest a Feature](#how-to-suggest-a-feature)
  - [How to Submit a Pull Request](#how-to-submit-a-pull-request)
  - [Development Setup](#development-setup)
  - [Branching \& Workflow](#branching--workflow)
  - [Commit Message Guidelines](#commit-message-guidelines)
  - [License](#license)

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you agree to abide by its terms. Please report unacceptable behavior to the maintainers.

## How to Report a Bug

1. Search existing [issues](https://github.com/elliotfleming/react-native-stroke-text/issues) to see if it’s already reported.
2. If not, open a new issue with the following details:

   * **Reproduction steps**: How to reproduce the bug (code snippets, screenshots, device info).
   * **Expected behavior** vs. **actual behavior**.
   * **Version information**: React Native version, library version, iOS version, etc.

## How to Suggest a Feature

1. Search existing issues to ensure your idea hasn’t been discussed.
2. Open a feature request issue, clearly describing:

   * The problem you’re trying to solve.
   * The proposed API or usage examples.
   * Any potential edge cases or considerations.

## How to Submit a Pull Request

1. Fork the repository and clone your fork:

   ```bash
   git clone https://github.com/your-username/react-native-stroke-text.git
   cd react-native-stroke-text
   ```
2. Create a new branch for your change:

   ```bash
   git checkout -b feature/YourFeatureName
   ```
3. Install dependencies and set up iOS:

   ```bash
   npm install
   cd ios && pod install && cd ..
   ```
4. Make your changes, ensuring:

   * Code follows existing style (2-space indentation, double quotes).
   * New features include unit tests where applicable.
   * All existing tests pass.
5. Run tests & lint:

   ```bash
   npm test
   npm run lint
   ```
6. Commit your changes, following the [Commit Message Guidelines](#commit-message-guidelines).
7. Push to your branch and open a pull request against the `main` branch.

Please describe your changes clearly in the PR description and reference relevant issues.

## Development Setup

To get the project running locally:

1. Clone the repo and install dependencies:

   ```bash
   npm install
   ```
2. Install CocoaPods (for iOS):

   ```bash
   cd ios && pod install && cd ..
   ```
3. Start Metro and run the example app:

   ```bash
   npm run start
   npm run ios
   ```

You can modify code in `index.tsx` and `ios/` files; changes should hot-reload in the example app.

## Branching & Workflow

* **main**: Stable, production-ready code. All PRs should target `main`.
* **feature/**: New features or enhancements.
* **fix/**: Bug fixes.
* **docs/**: Documentation only changes.

Before merging, ensure your branch is up-to-date with `main`:

```bash
git fetch origin
git rebase origin/main
```

## Commit Message Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/) style:

```
<type>(<scope>): <subject>

<body>

<footer>
```

* **type**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
* **scope**: Optional area (e.g., `ios`, `android`, `example`)
* **subject**: Brief summary (max 50 chars)
* **body**: More detailed explanation.
* **footer**: Issue references or breaking changes.

Example:

```
feat(ios): support dynamic stroke width

Users can now pass a function to `strokeWidth` that returns different widths based on props.

Closes #42
```

## License

By contributing, you agree that your contributions will be licensed under the project’s MIT License.
