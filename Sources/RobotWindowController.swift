import AppKit

final class RobotWindowController {
    private(set) var window: NSPanel

    init() {
        let size: CGFloat = 160
        let contentRect = NSRect(x: 200, y: 200, width: size, height: size)
        window = NSPanel(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.level = .floating
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isMovableByWindowBackground = false

        let view = RobotPlaceholderView(frame: NSRect(origin: .zero, size: contentRect.size))
        view.wantsLayer = true
        window.contentView = view
    }

    func show() {
        window.makeKeyAndOrderFront(nil)
    }

    func hide() {
        window.orderOut(nil)
    }

    var isVisible: Bool {
        window.isVisible
    }
}
