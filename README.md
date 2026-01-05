# Juno

A macOS desktop robot pet that follows the mouse with a gentle delay. See `SPEC.md` for the full requirements and MVP scope.

## Project layout
- `project.yml` — XcodeGen project definition
- `Juno.xcodeproj` — generated Xcode project (run `xcodegen` to regenerate)
- `Sources/` — app source code + Info.plist
- `ref.png` — visual reference

## Build
Open `Juno.xcodeproj` in Xcode and run the `Juno` scheme.

CLI build (optional):
```
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild -project Juno.xcodeproj -scheme Juno -configuration Debug -sdk macosx build
```

## Notes
- This is a menu-bar-only app (LSUIElement = true). If Mission Control visibility is required, we may need to revisit that setting.
