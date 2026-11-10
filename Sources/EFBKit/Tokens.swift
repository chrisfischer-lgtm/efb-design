import SwiftUI

public extension Color {
    /// sRGB colour from a 0xRRGGBB literal.
    init(hex: UInt32, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }
}

/// Design tokens of the performance EFB family. Mirrors `tokens/tokens.json`.
public enum EFB {
    // MARK: Canvas
    public static let canvas = CGSize(width: 1180, height: 820)

    // MARK: Data colours (meaning, see docs/02-colour.md)
    public static let blue = Color(hex: 0x48CBFF)        // entered by the pilot
    public static let yellow = Color(hex: 0xF5E619)      // preselected by the system
    public static let green = Color(hex: 0x4FF43D)       // computed / fixed by type
    public static let caption = Color(hex: 0xB5B9BF)     // unit captions
    public static let warning = Color(hex: 0xFFA933)     // no solution
    public static let version = Color(hex: 0xFFB01F)

    // MARK: Surfaces
    public static let chrome = Color(hex: 0xC8C8C8)
    public static let slate = Color(hex: 0x53626B)
    public static let card = Color(hex: 0x434343)
    public static let cardEdge = Color(hex: 0x292C32)
    public static let cardBevel = Color(hex: 0xB6B9BF)
    public static let separatorLight = Color(hex: 0xA1A1A1)
    public static let popover = Color(hex: 0x757A81)
    public static let popoverEdge = Color(hex: 0x282C32)
    public static let metalLight = Color(hex: 0x8A8A89)
    public static let metalDark = Color(hex: 0x737372)
    public static let metalHome = Color(hex: 0xA7A7A7)

    // MARK: FMS mirror / graphs
    public static let fmsTitle = Color(hex: 0x1FF21F)
    public static let fmsCyan = Color(hex: 0x2FD6E8)
    public static let fmsGrey = Color(hex: 0x7F7F7F)
    public static let graphPath = Color(hex: 0x1EF0F0)

    // MARK: Fonts (fixed size: an EFB must not reflow with Dynamic Type)
    public static func futura(_ s: CGFloat) -> Font { .custom("Futura-CondensedMedium", fixedSize: s) }
    public static func hnc(_ s: CGFloat) -> Font { .custom("HelveticaNeue-CondensedBold", fixedSize: s) }
    public static func hnb(_ s: CGFloat) -> Font { .custom("HelveticaNeue-Bold", fixedSize: s) }
    public static func hn(_ s: CGFloat) -> Font { .custom("HelveticaNeue", fixedSize: s) }
    public static func mono(_ s: CGFloat) -> Font { .custom("Menlo-Bold", fixedSize: s) }

    // MARK: Metrics
    public static let rowHeight: CGFloat = 44
    public static let rowHeightCompact: CGFloat = 36
    public static let cardRadius: CGFloat = 8
    public static let cardGap: CGFloat = 14
    public static let popoverWidth: CGFloat = 419
    public static let computeMinimumSeconds: Double = 3
}

/// Compatibility with the reference TakeOff app, where the token namespace is called `FS`.
public typealias FS = EFB
