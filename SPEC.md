# SPEC — Juno (Desktop Robot Pet, macOS)

## Overview
Build a macOS-native virtual pet that lives on the desktop (not in the Dock). It is a floating robot sprite that follows the mouse with a soft delay, providing a delightful ambient presence. Think “pixelated BB-8” drifting after the cursor.

Project name: Juno.

Reference visual: `ref.png` (robot vibe and proportions; pixel art is acceptable).

## Decisions (from Q&A)
- Target macOS: 13+ (Ventura) for broad compatibility; should run on your current Mac.
- Permissions: prefer Input Monitoring only; avoid Accessibility unless required.
- Window interaction: click-through by default, with a temporary drag toggle.
- Art direction: pixel art for MVP.
- MVP “done”: show + follow + idle/follow animations + menu bar Show/Hide/Quit. No preferences panel in MVP.
- Mission Control: prefer visible; if agent-mode hides it, we accept hidden for MVP.
- Window level: stay above normal apps where possible (best-effort; full-screen apps may still cover it).

## Goals
- A lightweight, always-on desktop companion that follows the mouse on a delay.
- A charming robot sprite (pixel art acceptable) with simple idle/follow animations.
- Minimal setup: launch app, robot appears and follows.

## Non-Goals (v1)
- Complex AI behaviors, speech, or chat.
- Multiple pets, customization marketplace, or networked features.
- Deep system integrations (calendar, notifications, etc.).

## User Stories
- As a user, I can launch the app and see a robot on my desktop.
- As I move my mouse, the robot follows with a smooth, delayed drift.
- As a user, I can pause/hide the robot quickly.
- As a user, the robot feels “alive” via subtle animation.

## Requirements
### Functional
- Window stays above normal app windows where possible (best-effort; full-screen apps may still cover it).
- Show a transparent, borderless, always-on-top desktop window with a robot sprite.
- Follow mouse position with configurable lag/smoothing.
- Idle animation when cursor is still; follow animation when moving.
- Quick controls: menu bar icon with Show/Hide and Quit.
- Persist last position and user settings.

### UX / Visual
- Robot sprite can be pixelated; target size ~96–160px tall (configurable).
- Soft floating motion; no jerky snapping.
- Click-through by default so it doesn’t block desktop interactions.
- Optional “grab and drag” mode (toggle) for repositioning.

### Performance
- 60 FPS target; CPU usage minimal (<2–3% idle on modern Mac).
- Memory footprint <150MB for MVP.

### Platform / Permissions
- macOS 13+ target (confirm if you want newer-only).
- Use global mouse tracking via AppKit; avoid key event monitoring.
- Request Input Monitoring permission only if the OS prompts for it.

## Behavior Spec
### Motion Model
- Track global cursor position.
- Maintain robot position `p` and target `t` (cursor).
- Each frame: `p = p + (t - p) * followFactor` (e.g., 0.08–0.15).
- Add small bobbing (sinusoidal) for life-like float.
- If cursor speed is below threshold for N seconds, switch to idle animation.

### States
- Idle: gentle float + idle sprite loop.
- Follow: slightly faster float + follow sprite loop.
- Hidden: no window visible.

### Edge Handling
- Keep robot fully on screen; clamp position to visible area.
- Respect multi-monitor setups; follow across screens.
- If cursor jumps to another display, smoothly migrate.

## Tech Stack (Recommended)
### Core
- **Language**: Swift
- **UI framework**: AppKit (NSApplication + NSWindow/NSPanel)
- **Windowing**: Transparent, borderless `NSPanel` (or `NSWindow`) configured for click-through and floating behavior.

### Rendering / Animation
- Start with a sprite sheet animated in a custom `NSView` or `NSImageView`.
- If animation needs grow, migrate to SpriteKit (`SKView` + `SKSpriteNode`) inside the panel.

### Menu Bar App
- Use `LSUIElement = YES` in `Info.plist` to run as a menu-bar-only app (no Dock icon).
- Provide a minimal menu bar item with Show/Hide/Quit.

### Why this stack
- AppKit gives direct control over transparent, always-on-top windows and mouse event monitoring.
- Native stack avoids cross-platform quirks and allows tighter integration with Spaces and input handling.

## Architecture Notes
- App entry: `NSApplicationDelegate` manages window creation, event monitoring, and menu bar.
- Render loop: `CVDisplayLink` or timer-driven updates at 60 FPS.
- Settings: `UserDefaults` for followFactor, spriteScale, showHidden, lastPosition, dragMode.

## Assets
- Sprite sheet with idle + follow loops (6–12 frames each).
- Pixel art style aligned with the reference robot silhouette.

## MVP Scope
- Single robot sprite, two animations (idle/follow).
- Simple follower motion with smoothing.
- Menu bar controls: Show/Hide/Quit.
- Basic settings persisted (follow speed + size + last position).

## Stretch Ideas
- Multiple robots with different personalities.
- Simple reactions (bounce away from cursor, wave on click).
- Seasonal skins.


## Acceptance Criteria
- Launching the app shows the robot on the desktop within 1s.
- Robot follows cursor smoothly with a noticeable but pleasant delay.
- Robot never blocks clicks unless drag mode is enabled.
- User can hide/show the robot from the menu bar.
