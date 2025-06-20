# Publish a new version of the package with a pre-release tag.

## Workflow

````bash
git add -A
git commit -am 'message'
git push origin main
npm run build
npm version prerelease --preid lp
git push origin main --follow-tags
npm publish --access public
```