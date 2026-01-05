import AppKit

final class RobotPlaceholderView: NSView {
    override var isFlipped: Bool { true }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.setFill()
        dirtyRect.fill()

        let bodyRect = bounds.insetBy(dx: 12, dy: 12)
        let bodyPath = NSBezierPath(ovalIn: bodyRect)
        NSColor(calibratedWhite: 1.0, alpha: 0.12).setFill()
        bodyPath.fill()

        let eyeRect = NSRect(
            x: bodyRect.midX - 12,
            y: bodyRect.minY + 28,
            width: 24,
            height: 14
        )
        let eyePath = NSBezierPath(roundedRect: eyeRect, xRadius: 6, yRadius: 6)
        NSColor(calibratedWhite: 0.1, alpha: 0.7).setFill()
        eyePath.fill()

        let pupilRect = NSRect(
            x: eyeRect.midX - 4,
            y: eyeRect.midY - 3,
            width: 8,
            height: 8
        )
        let pupilPath = NSBezierPath(ovalIn: pupilRect)
        NSColor(calibratedRed: 0.3, green: 0.6, blue: 1.0, alpha: 0.9).setFill()
        pupilPath.fill()
    }
}
