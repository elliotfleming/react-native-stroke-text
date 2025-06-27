# Publish a new version of the package

## Release Workflow

### Prerelease

Prereleases are published manually (not from the CI workflow). 

```bash
git commit -am 'progress'
git push origin main
npm version prerelease --preid lp
npm run build
git push origin main --follow-tags
npm publish --access public
```

**NOTE**: This line in the workflow prevents the workflow from running on prerelease commits:
```yaml
if: github.event.release.prerelease == false
```

### Prerelease (shorthand)

This is a shorthand for the above steps, which can be used when you are working on a feature and need to publish a new prerelease version.

```bash
git commit -am 'progress' && git push origin main
npm version prerelease --preid lp && npm run build
git push origin main --follow-tags
npm publish --access public
```

### Major Release

Uses `.github/workflows/npm-publish.yml` to create a release.
Note that we still run build first even though the workflow does it too.
This is to support local testing of the release process.

```bash
npm run build
npm version 1.0.0 -m "chore(release): %s"
git push origin main --follow-tags
gh release create v1.0.0 \
  --repo elliotfleming/react-native-stroke-text \
  --title "v1.0.0" \
  --notes "Initial stable release"
```

### Patch Release
```bash
npm run build
npm version patch -m "chore(release): %s"
git push origin main --follow-tags
gh release create v1.0.1 \
  --repo elliotfleming/react-native-stroke-text \
  --title "v1.0.1" \
  --notes "🔧 Patch release"
```

## Release Cleanup

### Unpublish a Version

Only works for ~72 hours after publishing.

```bash
npm unpublish @elliotfleming/react-native-stroke-text@1.0.0-lp.0
```

### Deprecate a Version
```bash
npm deprecate @elliotfleming/react-native-stroke-text@1.0.0-lp.0 "This version is no longer supported, please use the latest version."
```

### Deprecate all previous prerelease versions

The wildcard will cover any release tag matching 1.0.0-lp.*

```bash
npm deprecate @elliotfleming/react-native-stroke-text@"*_lp.*" \
  "⚠️ This prerelease is obsolete—please upgrade to >=1.0.0"
```

## Migrate to new unscoped package name

```bash
npm deprecate @elliotfleming/react-native-stroke-text@"*" \
  "⚠️ This package has moved to react-native-stroke-text. Please upgrade."
```