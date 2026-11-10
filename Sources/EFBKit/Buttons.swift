import SwiftUI

/// White = primary, grey = secondary. Dimmed instead of hidden when unavailable.
public enum GlossStyle: Sendable {
    case white
    case whiteDimmed
    case grey
    case greyDimmed

    var colors: [Color] {
        switch self {
        case .white: return [.white, Color(hex: 0xFBFBFB), Color(hex: 0xD5D7D8)]
        case .whiteDimmed: return [Color(hex: 0xBCBFC2), Color(hex: 0xADB0B4), Color(hex: 0x95999E)]
        case .grey: return [Color(hex: 0xA1A5A9), Color(hex: 0x8A8F95), Color(hex: 0x6C7379)]
        case .greyDimmed: return [Color(hex: 0xC6C9CD), Color(hex: 0xB7BABF), Color(hex: 0xA3A7AC)]
        }
    }
    var text: Color {
        switch self {
        case .white: return Color(hex: 0x5E5E5E)
        case .whiteDimmed: return Color(hex: 0x6C6E70)
        case .grey, .greyDimmed: return .white
        }
    }
    var border: Color {
        switch self {
        case .white: return Color(hex: 0x8D9197)
        case .whiteDimmed: return Color(hex: 0xA6A9AD)
        case .grey: return Color(hex: 0x666A70)
        case .greyDimmed: return Color(hex: 0x9A9EA3)
        }
    }
    var isDimmed: Bool { self == .whiteDimmed || self == .greyDimmed }
}

/// Glossy gradient button with an embossed label.
public struct GlossButton: View {
    public let title: String
    public var style: GlossStyle
    public var font: Font
    public var radius: CGFloat
    public var textColor: Color?
    public var action: () -> Void

    public init(title: String, style: GlossStyle = .white, font: Font = EFB.hnc(21), radius: CGFloat = 5,
                textColor: Color? = nil, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = style
        self.font = font
        self.radius = radius
        self.textColor = textColor
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: radius)
                    .fill(LinearGradient(colors: style.colors, startPoint: .top, endPoint: .bottom))
                RoundedRectangle(cornerRadius: radius).strokeBorder(style.border, lineWidth: 1)
                Text(title)
                    .font(font)
                    .foregroundStyle(textColor ?? style.text)
                    .shadow(color: style == .grey ? .black.opacity(0.75) : (style == .greyDimmed ? .black.opacity(0.3) : .white.opacity(0.8)),
                            radius: 0, x: 0, y: style == .grey || style == .greyDimmed ? -1 : 1)
            }
            .background(RoundedRectangle(cornerRadius: radius).fill(Color.white.opacity(0.55)).offset(y: 1))
        }
        .buttonStyle(.plain)
        .disabled(style.isDimmed)
    }
}

/// Grey "Close" button used in popover headers.
public struct CloseButton: View {
    public var title: String
    public var action: () -> Void
    public init(title: String = "Close", action: @escaping () -> Void) { self.title = title; self.action = action }
    public var body: some View {
        GlossButton(title: title, style: .grey, font: EFB.hnc(16), radius: 4, action: action)
    }
}
