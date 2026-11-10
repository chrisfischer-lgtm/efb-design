import SwiftUI
import UIKit

/// Dark rounded data card with the etched outline, inner shadow and bottom bevel.
public struct EFBCard<Content: View>: View {
    public var radius: CGFloat
    public var squareTop: Bool
    private let content: Content

    public init(radius: CGFloat = EFB.cardRadius, squareTop: Bool = false, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.squareTop = squareTop
        self.content = content()
    }

    public var body: some View {
        let shape = UnevenRoundedRectangle(topLeadingRadius: squareTop ? 0 : radius, bottomLeadingRadius: radius,
                                           bottomTrailingRadius: radius, topTrailingRadius: squareTop ? 0 : radius)
        VStack(spacing: 0) { content }
            .background(EFB.card)
            .overlay(
                shape.stroke(Color.black.opacity(0.42), lineWidth: 6)
                    .blur(radius: 3)
                    .allowsHitTesting(false)
            )
            .clipShape(shape)
            .overlay(shape.strokeBorder(EFB.cardEdge, lineWidth: 1))
            .background(shape.fill(EFB.cardBevel).offset(y: 1))
    }
}

/// Name used in the reference TakeOff app.
public typealias FSCard = EFBCard

/// Etched two-tone separator drawn at the top edge of a row.
public struct RowSeparator: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EFB.cardEdge).frame(height: 1)
            Rectangle().fill(EFB.separatorLight).frame(height: 1)
        }
    }
}

public extension View {
    /// Standard row frame with an optional etched separator above it and the "editing" highlight.
    func fsRow(height: CGFloat = EFB.rowHeight, separator: Bool = true, selected: Bool = false) -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: separator ? height : height - 1)
            .background(
                selected
                ? AnyView(LinearGradient(colors: [Color(hex: 0x6F879F), Color(hex: 0x527694)], startPoint: .top, endPoint: .bottom))
                : AnyView(Color.clear)
            )
            .overlay(alignment: .top) { if separator { RowSeparator() } }
    }
}

public extension Text {
    /// Row label in Futura Condensed (white).
    func fsLabel(_ size: CGFloat = 20) -> some View {
        self.font(EFB.futura(size)).foregroundStyle(.white).lineLimit(1).offset(y: -0.75)
    }
    /// Row value in Helvetica Neue Condensed Bold.
    func fsValue(_ color: Color = .white, _ size: CGFloat = 20) -> some View {
        self.font(EFB.hnc(size)).foregroundStyle(color).lineLimit(1)
    }
}

/// Character-level tail truncation ("BRUSSELS NA…"): never wrap, never shrink.
public func fsTruncated(_ text: String, fontName: String, size: CGFloat, width: CGFloat) -> String {
    guard let font = UIFont(name: fontName, size: size) else { return text }
    func w(_ s: String) -> CGFloat { (s as NSString).size(withAttributes: [.font: font]).width }
    if w(text) <= width { return text }
    var chars = Array(text)
    while !chars.isEmpty && w(String(chars) + "…") > width { chars.removeLast() }
    while let last = chars.last, last == " " { chars.removeLast() }
    return String(chars) + "…"
}

// MARK: - Note box and page dots

/// Card with free operational text, top-left aligned.
public struct NoteBox: View {
    public let text: String
    public init(text: String) { self.text = text }
    public var body: some View {
        EFBCard {
            Text(text)
                .font(EFB.hnc(20)).foregroundStyle(.white)
                .lineSpacing(-1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 5).padding(.top, 9)
        }
    }
}

/// Page indicator for swipeable result pages.
public struct PageDots: View {
    public let count: Int
    public let current: Int
    public init(count: Int, current: Int) { self.count = count; self.current = current }
    public var body: some View {
        ZStack {
            Capsule().fill(Color(hex: 0x888C92))
            Capsule().strokeBorder(Color(hex: 0x676A70), lineWidth: 0.5)
            HStack(spacing: 10.5) {
                ForEach(0..<count, id: \.self) { i in
                    Circle().fill(i == current ? Color(hex: 0xFCFCFC) : Color(hex: 0xBCBFC2)).frame(width: 7.5, height: 7.5)
                }
            }
        }
    }
}
