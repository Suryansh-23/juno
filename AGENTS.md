# AGENTS.md

## Agent instructions
- Optimize for correctness and long-term leverage, not agreement.
- Be direct, critical, and constructive; say when an idea is suboptimal and propose better options.
- Assume staff-level technical context unless told otherwise.

## Quality
- Inspect project config (package.json, etc.) for available scripts.
- Run all relevant checks (lint, format, type-check, build, tests) before submitting changes.
- Never claim checks passed unless they were actually run.
- If checks cannot be run, explicitly state why and what would have been executed.

## SCM
- Never use git reset --hard or force-push without explicit permission.
- Prefer safe alternatives (git revert, new commits, temp branches).
- If history rewrite seems necessary, explain and ask first.

## Production safety
- Assume production impact unless stated otherwise.
- Call out risk when touching auth, billing, data, APIs, or build systems.
- Prefer small, reversible changes; avoid silent breaking behavior.

## Self improvement
- Continuously improve agent workflows.
- When a repeated correction or better approach is found, codify it in ~/.codex/AGENTS.md (Agent instructions section only).
- You may modify ~/.codex/AGENTS.md without prior approval if edits stay under Agent instructions.
- If you use a codified instruction in a future session, call it out and say that was the reason.

## Tool-specific memory
- Actively think beyond the immediate task.
- When using or working near a tool the user maintains, note patterns/friction/risks/opportunities.
- Do not interrupt the current task to implement speculative changes.
- Create or update a markdown file named after the tool in:
  - ~/Developer/AGENT/ideas for new concepts or future directions
  - ~/Developer/AGENT/improvements for enhancements to existing behavior
- Notes are informal, forward-looking, and may be partial.

---

# Juno MVP Implementation Plan (Step-by-Step)

## Project summary
Juno is a macOS desktop robot pet that follows the mouse with a gentle delay, renders as a pixel-art sprite, and runs as a menu-bar-only app (no Dock icon). It should stay above normal app windows when possible, be click-through by default, and feel alive via idle/follow animations.

## Key decisions
- Target macOS 13+ (Ventura).
- Swift + AppKit stack.
- Input Monitoring only (no Accessibility if avoidable).
- Pixel art sprite for MVP.
- Menu bar controls only (Show/Hide/Quit).
- Prefer visible in Mission Control if feasible; acceptable to be hidden for MVP if agent mode blocks it.
- Best-effort always-on-top above normal apps (full-screen apps may still cover it).

## Phase 0: Environment readiness
1) Confirm Xcode installed and command line tools available.
2) Confirm macOS 13+ (Ventura) or newer.
3) Decide whether to use GitHub or a local-only repo.

Checkpoint: confirm environment is ready before creating the project.

## Phase 1: Repo setup
1) Initialize git repo in /Users/r2d2/Developer/juno (if not already).
2) Add .gitignore for Xcode/Swift.
3) Add README.md that links to SPEC.md and describes MVP scope.
4) Ensure ref.png is in repo root.

Checkpoint: quick review of repo layout and files.

## Phase 2: Create macOS AppKit project
1) In Xcode, create a new macOS App project:
   - Interface: AppKit
   - Language: Swift
   - Use Storyboards: No (programmatic window)
2) Set bundle identifier (e.g., com.yourname.juno).
3) Add LSUIElement = YES to Info.plist (menu-bar-only app, no Dock icon).

Checkpoint: build and run the empty app to confirm it launches.

## Phase 3: App skeleton and window system
1) Create AppDelegate to own lifecycle, menu bar item, and robot window.
2) Create a transparent NSPanel (or NSWindow) configured for:
   - borderless
   - isOpaque = false
   - backgroundColor = clear
   - ignoresMouseEvents = true (click-through default)
   - level = NSWindow.Level.floating (or higher, best-effort)
   - collectionBehavior includes canJoinAllSpaces (and optionally fullScreenAuxiliary)
3) Ensure the window is visible on launch and can be hidden/shown.

Checkpoint: run app, see transparent window above regular apps.

## Phase 4: Cursor tracking and motion
1) Install global mouse monitor using NSEvent.addGlobalMonitorForEventsMatchingMask (.mouseMoved).
2) Store target cursor position in screen coordinates.
3) Create a render loop (CVDisplayLink or Timer at ~60 FPS).
4) Implement smoothing: p = p + (t - p) * followFactor.
5) Add gentle bobbing (sinusoidal) and speed-based idle detection.

Checkpoint: window follows cursor with smooth delay.

## Phase 5: Sprite rendering and animation
1) Create a simple SpriteView (NSView subclass) that draws current frame.
2) Load sprite sheet frames for idle and follow animations.
3) Switch animation state based on cursor speed/idle timeout.
4) Ensure scaling is crisp for pixel art (no blur).

Checkpoint: sprite animates and switches idle/follow cleanly.

## Phase 6: Multi-monitor behavior
1) Detect active screen based on cursor position.
2) Clamp robot position to the visible frame of that screen.
3) Smoothly migrate between screens on cursor jump.

Checkpoint: robot follows across monitors without jumping off-screen.

## Phase 7: Menu bar controls
1) Add NSStatusBar item with menu:
   - Show/Hide
   - Toggle Drag Mode (temporary ignoresMouseEvents = false)
   - Quit
2) Persist toggle states in UserDefaults.

Checkpoint: menu bar controls work reliably.

## Phase 8: Persistence and polish
1) Save last position, followFactor, spriteScale (if needed), and drag mode.
2) Restore on launch.
3) Verify CPU usage is low while idle.

Checkpoint: app restarts to last state and stays lightweight.

## Phase 9: Mission Control and window layering validation
1) Verify whether LSUIElement app appears in Mission Control.
2) If hidden, document the limitation in README and keep MVP as-is.
3) Validate always-on-top behavior versus normal app windows.

Checkpoint: document the Mission Control behavior and confirm best-effort layering.

## Phase 10: MVP QA and release packaging
1) Manual test matrix:
   - cold launch
   - show/hide
   - idle vs follow animation
   - click-through vs drag mode
   - multi-monitor
   - screen sleep/wake
2) Run build in Release configuration.
3) Optional: code signing/notarization (if distributing outside local use).

Checkpoint: MVP acceptance criteria met.

## Communication cadence (keeping you in the loop)
- I will confirm at each checkpoint before moving to the next phase.
- I will flag any macOS API constraints or permission prompts immediately.
- If behavior deviates from spec, I will propose options and ask for a decision.

## Acceptance criteria (MVP)
- App launches in under 1s and shows the robot.
- Robot follows cursor smoothly with a pleasant delay.
- Idle and follow animations work and feel alive.
- Menu bar Show/Hide/Quit works.
- Robot stays above normal app windows where possible.

