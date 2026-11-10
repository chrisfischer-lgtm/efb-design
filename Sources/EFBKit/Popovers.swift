import SwiftUI

// Custom popovers (no system popovers): a slate panel with a left-pointing arrow
// anchored on the row being edited. Offsets in points, measured from the reference TakeOff app.

// MARK: - Row frame reporting (row → popover anchor)

public struct RowFrameKey: PreferenceKey {
    public static let defaultValue: [AnyHashable: CGRect] = [:]
    public static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

public extension View {
    /// Reports this view's frame in a named coordinate space so a popover can anchor to it.
    func reportFrame(_ id: AnyHashable, in space: String) -> some View {
        background(GeometryReader { g in
            Color.clear.preference(key: RowFrameKey.self, value: [id: g.frame(in: .named(space))])
        })
    }
}

/// Vertical placement for a popover of `height` next to a row whose centre is `rowMidY`.
/// Returns the panel top and the arrow offset inside the panel.
public func popoverPlacement(rowMidY: CGFloat, height: CGFloat, minY: CGFloat = 32.5, maxBottom: CGFloat = 733)
    -> (y: CGFloat, arrow: CGFloat) {
    let y = min(max(minY, rowMidY - height / 2), max(minY, maxBottom - height))
    return (y, rowMidY - y)
}

// MARK: - Panel chrome

public struct PopoverPanel<Content: View>: View {
    public let width: CGFloat
    public let height: CGFloat
    public var arrowY: CGFloat?
    private let content: Content

    public init(width: CGFloat = EFB.popoverWidth, height: CGFloat, arrowY: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.width = width
        self.height = height
        self.arrowY = arrowY
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            if let arrowY {
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 12)); p.addLine(to: CGPoint(x: 13, y: 0)); p.addLine(to: CGPoint(x: 13, y: 24)); p.closeSubpath()
                }
                .fill(Color(hex: 0x666A70))
                .overlay(Path { p in
                    p.move(to: CGPoint(x: 13, y: 0)); p.addLine(to: CGPoint(x: 0, y: 12)); p.addLine(to: CGPoint(x: 13, y: 24))
                }.stroke(EFB.popoverEdge, lineWidth: 1))
                .frame(width: 13, height: 24)
                .offset(x: -12, y: min(max(arrowY, 16), height - 16) - 12)
            }
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(stops: [
                    .init(color: Color(hex: 0xB9BDC2), location: 0),
                    .init(color: Color(hex: 0x8D9095), location: 19.5 / height),
                    .init(color: Color(hex: 0x7E8289), location: 20 / height),
                    .init(color: Color(hex: 0x757A81), location: min(0.5, 80 / height)),
                    .init(color: Color(hex: 0x757A81), location: max(0.5, 1 - 24 / height)),
                    .init(color: Color(hex: 0x696D73), location: 1),
                ], startPoint: .top, endPoint: .bottom))
                .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(EFB.popoverEdge, lineWidth: 1))
                .shadow(color: .black.opacity(0.45), radius: 5, x: 0, y: 2)
            content
        }
        .frame(width: width, height: height, alignment: .topLeading)
    }
}

/// Popover title (white, raised).
public struct PopoverTitle: View {
    public let text: String
    public var size: CGFloat
    public init(text: String, size: CGFloat = 20) { self.text = text; self.size = size }
    public var body: some View {
        Text(text).font(EFB.hnc(size)).foregroundStyle(.white)
            .shadow(color: .black.opacity(0.7), radius: 0, x: 0, y: -1)
            .lineLimit(1)
    }
}

/// Instruction line (format, range, conversion) in Futura Condensed.
public struct PopoverHint: View {
    public let text: String
    public var size: CGFloat
    public init(text: String, size: CGFloat = 20) { self.text = text; self.size = size }
    public var body: some View {
        Text(text).font(EFB.futura(size)).foregroundStyle(.white)
            .shadow(color: .black.opacity(0.35), radius: 0, x: 0, y: -0.5)
            .lineLimit(1).fixedSize()
    }
}

// MARK: - List popover

public enum PopoverHeaderVariant: Sendable {
    case tall, short
    var titleY: CGFloat { self == .tall ? 41 : 29.5 }
    var hintY: CGFloat { self == .tall ? 72.5 : 57 }
    var bottomPad: CGFloat { self == .tall ? 28 : 14.5 }
    func closeFrame(width: CGFloat) -> CGRect {
        self == .tall ? CGRect(x: width - 80, y: 27.5, width: 59.5, height: 27)
                      : CGRect(x: width - 68.5, y: 15, width: 54, height: 29)
    }
}

/// Title + Close, hint lines, a card of 44 pt rows; blue check mark on the current value.
public struct ListPopover: View {
    public let title: String
    public let hints: [String]
    public let items: [String]
    public var trailing: [Int: String]
    public let selected: Int?
    public var variant: PopoverHeaderVariant
    public var width: CGFloat
    public var rowHeight: CGFloat
    public var visibleRows: Int?
    public var showsChevron: Bool
    public var arrowY: CGFloat?
    public let onSelect: (Int) -> Void
    public let onClose: () -> Void

    public init(title: String, hints: [String], items: [String], trailing: [Int: String] = [:], selected: Int?,
                variant: PopoverHeaderVariant = .tall, width: CGFloat = EFB.popoverWidth, rowHeight: CGFloat = 44,
                visibleRows: Int? = nil, showsChevron: Bool = false, arrowY: CGFloat? = nil,
                onSelect: @escaping (Int) -> Void, onClose: @escaping () -> Void) {
        self.title = title
        self.hints = hints
        self.items = items
        self.trailing = trailing
        self.selected = selected
        self.variant = variant
        self.width = width
        self.rowHeight = rowHeight
        self.visibleRows = visibleRows
        self.showsChevron = showsChevron
        self.arrowY = arrowY
        self.onSelect = onSelect
        self.onClose = onClose
    }

    private var listTop: CGFloat { variant.hintY + CGFloat(hints.count - 1) * 24.5 + (variant == .tall ? 30 : 31.5) }
    private var shownRows: Int { min(items.count, visibleRows ?? items.count) }
    private var listHeight: CGFloat { CGFloat(shownRows) * rowHeight - 1 }
    public var height: CGFloat { listTop + listHeight + variant.bottomPad }

    public static func height(hints: Int, rows: Int, variant: PopoverHeaderVariant, rowHeight: CGFloat = 44) -> CGFloat {
        variant.hintY + CGFloat(hints - 1) * 24.5 + (variant == .tall ? 30 : 31.5) + CGFloat(rows) * rowHeight - 1 + variant.bottomPad
    }

    public var body: some View {
        let close = variant.closeFrame(width: width)
        PopoverPanel(width: width, height: height, arrowY: arrowY) {
            PopoverTitle(text: title)
                .frame(width: close.minX, height: 30)
                .offset(x: 0, y: variant.titleY - 15)
            CloseButton(action: onClose).at(close.minX, close.minY, w: close.width, h: close.height)
            ForEach(Array(hints.enumerated()), id: \.offset) { i, line in
                PopoverHint(text: line)
                    .frame(height: 28)
                    .offset(x: 30, y: variant.hintY + CGFloat(i) * 24.5 - 14)
            }
            EFBCard {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(Array(items.enumerated()), id: \.offset) { i, item in
                            Button { onSelect(i) } label: {
                                HStack(spacing: 0) {
                                    Text(item).fsValue(.white).offset(y: 1.4)
                                    Spacer(minLength: 4)
                                    if let t = trailing[i] { Text(t).fsValue(.white).offset(y: 1.4).padding(.trailing, 14) }
                                    if selected == i { CheckMark().padding(.trailing, 6) }
                                    if showsChevron { Chevron().padding(.trailing, 2) }
                                }
                                .padding(.leading, 16).padding(.trailing, 15.5)
                                .fsRow(height: rowHeight, separator: i > 0)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollDisabled(shownRows == items.count)
                .frame(height: listHeight)
            }
            .at(10, listTop, w: width - 20, h: listHeight)
        }
    }
}
