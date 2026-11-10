import SwiftUI

/// One white keypad key.
public struct KeypadKey<Label: View>: View {
    public var enabled: Bool
    public var action: () -> Void
    private let label: Label

    public init(enabled: Bool = true, action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.enabled = enabled
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(action: { if enabled { action() } }) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(colors: enabled ? [.white, Color(hex: 0xF2F3F3), Color(hex: 0xDDDEDF)]
                                                         : [Color(hex: 0xBABCC0), Color(hex: 0xB0B3B7)],
                                         startPoint: .top, endPoint: .bottom))
                RoundedRectangle(cornerRadius: 6).strokeBorder(enabled ? Color(hex: 0x33383E) : Color(hex: 0x8F9398), lineWidth: 1)
                label.opacity(enabled ? 1 : 0.45)
            }
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.black.opacity(0.35)).offset(y: 1.5))
        }
        .buttonStyle(.plain)
    }
}

/// 4×4 keypad: digits, ".", "±", optional "*", backspace, Done, Next.
/// Keys sent to `onKey`: "0"…"9", ".", "±", "*", "⌫", "done", "next".
public struct KeypadGrid: View {
    public var allowsDecimal: Bool
    public var allowsSign: Bool
    public var star: Bool
    public var onKey: (String) -> Void

    private let columns: [CGFloat] = [49, 139, 229, 321.5]
    private let rows: [CGFloat] = [0, 78, 159, 240]

    public init(allowsDecimal: Bool = true, allowsSign: Bool = false, star: Bool = false, onKey: @escaping (String) -> Void) {
        self.allowsDecimal = allowsDecimal
        self.allowsSign = allowsSign
        self.star = star
        self.onKey = onKey
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<9, id: \.self) { i in
                digit("\(i + 1)").at(columns[i % 3], rows[i / 3], w: 59, h: 58)
            }
            KeypadKey(enabled: allowsDecimal, action: { onKey(".") }) {
                Text(".").font(EFB.hnc(30)).foregroundStyle(EFB.slate).offset(y: 6)
            }.at(columns[0], rows[3], w: 59, h: 58)
            digit("0").at(columns[1], rows[3], w: 59, h: 58)
            KeypadKey(enabled: allowsSign, action: { onKey("±") }) { PlusMinusGlyph() }
                .at(columns[2], rows[3], w: 59, h: 58)
            if star {
                KeypadKey(action: { onKey("*") }) { Text("*").font(EFB.hnc(26)).foregroundStyle(EFB.slate).offset(y: 3) }
                    .at(columns[3], rows[0], w: 60, h: 58)
            }
            KeypadKey(action: { onKey("⌫") }) { BackspaceGlyph() }.at(columns[3], rows[1], w: 60, h: 58)
            KeypadKey(action: { onKey("done") }) { Text("Done").font(EFB.hnc(26)).foregroundStyle(EFB.slate) }
                .at(columns[3], rows[2], w: 60, h: 58)
            KeypadKey(action: { onKey("next") }) { Text("Next").font(EFB.hnc(26)).foregroundStyle(EFB.slate) }
                .at(columns[3], rows[3], w: 60, h: 58)
        }
    }

    private func digit(_ d: String) -> some View {
        KeypadKey(action: { onKey(d) }) { Text(d).font(EFB.hnc(30)).foregroundStyle(EFB.slate) }
    }
}

/// Dark entry field with unit caption and a clear button.
public struct EntryField: View {
    public let text: String
    public let unit: String
    public var selected: Bool
    public var onClear: () -> Void

    public init(text: String, unit: String, selected: Bool = false, onClear: @escaping () -> Void) {
        self.text = text
        self.unit = unit
        self.selected = selected
        self.onClear = onClear
    }

    public var body: some View {
        ZStack(alignment: .trailing) {
            EFBCard { Color.clear }
                .overlay {
                    if selected {
                        RoundedRectangle(cornerRadius: EFB.cardRadius)
                            .fill(LinearGradient(colors: [Color(hex: 0x6A8198), Color(hex: 0x456783)], startPoint: .top, endPoint: .bottom))
                            .overlay(RoundedRectangle(cornerRadius: EFB.cardRadius).strokeBorder(Color(hex: 0x33475A), lineWidth: 1))
                    }
                }
            HStack(spacing: 6) {
                Spacer(minLength: 0)
                Text(text).font(EFB.hnc(24)).foregroundStyle(.white).lineLimit(1).minimumScaleFactor(0.6)
                Text(unit).font(EFB.hnc(24)).foregroundStyle(EFB.caption)
            }
            .padding(.trailing, 46)
            Button(action: onClear) { ClearFieldGlyph() }.buttonStyle(.plain).padding(.trailing, 14)
        }
    }
}

/// Single-value numeric entry popover (OAT, QNH, TOW …).
/// `onCommit(text, next)` validates and stores; return false to refuse and keep the popover open.
public struct NumpadPopover: View {
    public let title: String
    public let unit: String
    public let hints: [String]
    public var allowsDecimal: Bool
    public var allowsSign: Bool
    public var star: Bool
    public var initial: String
    public var arrowY: CGFloat?
    public let onCommit: (String, _ next: Bool) -> Bool
    public let onClose: () -> Void

    @State private var text = ""
    @State private var fresh = true

    public init(title: String, unit: String, hints: [String], allowsDecimal: Bool = true, allowsSign: Bool = false,
                star: Bool = false, initial: String = "", arrowY: CGFloat? = nil,
                onCommit: @escaping (String, _ next: Bool) -> Bool, onClose: @escaping () -> Void) {
        self.title = title
        self.unit = unit
        self.hints = hints
        self.allowsDecimal = allowsDecimal
        self.allowsSign = allowsSign
        self.star = star
        self.initial = initial
        self.arrowY = arrowY
        self.onCommit = onCommit
        self.onClose = onClose
    }

    private var keysTop: CGFloat { 246.5 + CGFloat(max(0, hints.count - 3)) * 22.5 }
    public static func height(hintLines: Int) -> CGFloat { 246.5 + CGFloat(max(0, hintLines - 3)) * 22.5 + 238.5 + 58 + 19.5 }

    public var body: some View {
        PopoverPanel(width: EFB.popoverWidth, height: Self.height(hintLines: hints.count), arrowY: arrowY) {
            PopoverTitle(text: title).frame(width: EFB.popoverWidth, height: 30).offset(y: 42 - 15)
            CloseButton(action: onClose).at(345, 21, w: 54, h: 28)
            EntryField(text: text, unit: unit, onClear: { text = ""; fresh = false })
                .at(36, 87, w: 345.5, h: 43.5)
            ForEach(Array(hints.enumerated()), id: \.offset) { i, line in
                PopoverHint(text: line).frame(width: EFB.popoverWidth, height: 28).offset(y: 163.5 + CGFloat(i) * 23.75 - 14)
            }
            KeypadGrid(allowsDecimal: allowsDecimal && !text.isEmpty && text != "-" && text != "*" && !text.contains("."),
                       allowsSign: allowsSign, star: star) { key in handle(key) }
                .offset(y: keysTop)
        }
        .onAppear { text = initial; fresh = true }
    }

    private func handle(_ key: String) {
        switch key {
        case "⌫": if !text.isEmpty { text.removeLast() }; fresh = false
        case "±":
            if text.hasPrefix("-") { text.removeFirst() } else { text = "-" + text }
            fresh = false
        case ".": if fresh { text = "" }; if !text.contains(".") { text += text.isEmpty || text == "-" ? "0." : "." }; fresh = false
        case "*": text = "*"; fresh = false
        case "done": if onCommit(text, false) { onClose() }
        case "next": _ = onCommit(text, true)
        default:
            // The first key press replaces the pre-filled value.
            if fresh || text == "*" { text = "" }
            if text.count < 7 { text += key }
            fresh = false
        }
    }
}
