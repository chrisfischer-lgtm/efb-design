import SwiftUI

/// Bold ">" disclosure glyph: the value is picked from a list.
public struct Chevron: View {
    public var color: Color
    public init(color: Color = .white) { self.color = color }
    public var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 0.5, y: 0.5))
            p.addLine(to: CGPoint(x: 8.5, y: 5.5))
            p.addLine(to: CGPoint(x: 0.5, y: 10.5))
        }
        .stroke(color, style: StrokeStyle(lineWidth: 2.6, lineCap: .butt, lineJoin: .miter))
        .frame(width: 9, height: 11)
    }
}

/// Orange "required input" pencil badge; light blue while its popover is open.
public struct PencilBadge: View {
    public var selected: Bool
    public init(selected: Bool = false) { self.selected = selected }
    public var body: some View {
        ZStack {
            Circle().fill(selected ? Color(hex: 0x8FB6CC) : Color(hex: 0x70747A)).offset(y: 0.75)
            Circle().fill(selected ? Color(hex: 0xD9EEF8) : Color(hex: 0x666A70))
            Circle()
                .fill(LinearGradient(colors: selected ? [.white, Color(hex: 0xB8E0F4)] : [Color(hex: 0xFFBB2B), Color(hex: 0xFF9A2C)],
                                     startPoint: .top, endPoint: .bottom))
                .padding(1)
            PencilGlyph()
                .fill(selected ? Color(hex: 0x2D98C9) : Color(hex: 0x595E66))
                .frame(width: 17, height: 7.5)
                .rotationEffect(.degrees(-45))
                .offset(x: 0.25, y: 0.25)
        }
        .frame(width: 23, height: 23)
    }
}

/// Pencil lying on its side, tip to the left.
public struct PencilGlyph: Shape {
    public init() {}
    public func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: 0, y: h / 2))
        p.addLine(to: CGPoint(x: w * 0.20, y: h * 0.08))
        p.addLine(to: CGPoint(x: w * 0.20, y: h * 0.92))
        p.closeSubpath()
        p.addRect(CGRect(x: w * 0.26, y: 0, width: w * 0.50, height: h))
        p.addRoundedRect(in: CGRect(x: w * 0.80, y: 0, width: w * 0.20, height: h), cornerSize: CGSize(width: 1, height: 1))
        return p
    }
}

/// Blue check mark on the selected list entry.
public struct CheckMark: View {
    public init() {}
    public var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 1, y: 10))
            p.addLine(to: CGPoint(x: 6, y: 16))
            p.addLine(to: CGPoint(x: 17, y: 1))
        }
        .stroke(Color(hex: 0x4A9BD8), style: StrokeStyle(lineWidth: 3.2, lineCap: .butt, lineJoin: .miter))
        .frame(width: 18, height: 17)
    }
}

/// Keypad backspace legend.
public struct BackspaceGlyph: View {
    public var color: Color
    public init(color: Color = EFB.slate) { self.color = color }
    public var body: some View {
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: 0, y: 7)); p.addLine(to: CGPoint(x: 7, y: 0)); p.addLine(to: CGPoint(x: 22, y: 0))
                p.addLine(to: CGPoint(x: 22, y: 14)); p.addLine(to: CGPoint(x: 7, y: 14)); p.closeSubpath()
            }
            .fill(color)
            Path { p in
                p.move(to: CGPoint(x: 10.5, y: 3.5)); p.addLine(to: CGPoint(x: 17.5, y: 10.5))
                p.move(to: CGPoint(x: 17.5, y: 3.5)); p.addLine(to: CGPoint(x: 10.5, y: 10.5))
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: 2.4, lineCap: .butt))
        }
        .frame(width: 22, height: 14)
    }
}

/// "+/−" keypad legend.
public struct PlusMinusGlyph: View {
    public var color: Color
    public init(color: Color = EFB.slate) { self.color = color }
    public var body: some View {
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: 6, y: 1)); p.addLine(to: CGPoint(x: 6, y: 11))
                p.move(to: CGPoint(x: 1, y: 6)); p.addLine(to: CGPoint(x: 11, y: 6))
                p.move(to: CGPoint(x: 20, y: 24)); p.addLine(to: CGPoint(x: 31, y: 24))
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2.6, lineCap: .butt))
            Path { p in
                p.move(to: CGPoint(x: 5, y: 28)); p.addLine(to: CGPoint(x: 29, y: 2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .butt))
        }
        .frame(width: 32, height: 30)
    }
}

/// White round "clear field" button with a dark cross.
public struct ClearFieldGlyph: View {
    public init() {}
    public var body: some View {
        ZStack {
            Circle().fill(Color(hex: 0x8E9296)).offset(y: 1)
            Circle().fill(.white)
            Path { p in
                p.move(to: CGPoint(x: 6, y: 6)); p.addLine(to: CGPoint(x: 14, y: 14))
                p.move(to: CGPoint(x: 14, y: 6)); p.addLine(to: CGPoint(x: 6, y: 14))
            }
            .stroke(Color(hex: 0x4A4F55), style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
        }
        .frame(width: 20, height: 20)
    }
}
