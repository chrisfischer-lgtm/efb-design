import SwiftUI

/// Where a field value came from. Drives colour and trailing affordance (docs/06-interaction.md).
public enum FieldState: Equatable, Sendable {
    /// Required and still empty: orange pencil.
    case missing
    /// Operator standard, shown in white with "(STD)" in the value text.
    case standard(String)
    /// Suggested by the system (e.g. from My Flight): yellow.
    case preselected(String)
    /// Entered or changed by the pilot: blue.
    case entered(String)
    /// Fixed by the aircraft type: green, not tappable.
    case fixed(String)
    /// Inputs frozen after COMPUTE: white, compact, no affordance.
    case locked(String)

    public var value: String? {
        switch self {
        case .missing: return nil
        case .standard(let v), .preselected(let v), .entered(let v), .fixed(let v), .locked(let v): return v
        }
    }

    public var color: Color {
        switch self {
        case .missing, .standard, .locked: return .white
        case .preselected: return EFB.yellow
        case .entered: return EFB.blue
        case .fixed: return EFB.green
        }
    }

    public var isTappable: Bool {
        switch self {
        case .fixed, .locked: return false
        default: return true
        }
    }

    public var isLocked: Bool { if case .locked = self { return true } else { return false } }
}

/// How a field is edited: list popover (chevron) or keypad / free entry (no chevron).
public enum InputKind: Sendable { case list, numeric }

/// Standard input row: Futura label + optional unit caption left, state-coloured value right.
public struct InputRow: View {
    public let label: String
    public var caption: String?
    public let state: FieldState
    public var kind: InputKind
    public var first: Bool
    public var editing: Bool
    public var action: () -> Void

    public init(label: String, caption: String? = nil, state: FieldState, kind: InputKind,
                first: Bool = false, editing: Bool = false, action: @escaping () -> Void = {}) {
        self.label = label
        self.caption = caption
        self.state = state
        self.kind = kind
        self.first = first
        self.editing = editing
        self.action = action
    }

    private var trailingPad: CGFloat {
        if state.value == nil { return 15 }
        if state.isLocked { return 32 }
        if case .fixed = state { return 30 }
        return kind == .list ? 16 : 27
    }

    public var body: some View {
        Button { if state.isTappable { action() } } label: {
            HStack(spacing: 0) {
                Text(label).fsLabel().fixedSize()
                if let caption {
                    Text("  " + caption).font(EFB.futura(20))
                        .foregroundStyle(state.isLocked ? .white : EFB.caption).fixedSize()
                }
                Spacer(minLength: 2)
                if let value = state.value {
                    Text(value).fsValue(state.color).minimumScaleFactor(0.9)
                    if kind == .list && state.isTappable { Chevron().padding(.leading, 5.5) }
                } else {
                    PencilBadge(selected: editing)
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, trailingPad)
            .fsRow(height: state.isLocked ? EFB.rowHeightCompact : EFB.rowHeight, separator: !first, selected: editing)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// Result row: label left, green value and unit on fixed right-aligned columns (238 pt card).
public struct ResultRow: View {
    public let label: String
    public let value: String
    public var unit: String?
    public var first: Bool

    public init(label: String, value: String, unit: String? = nil, first: Bool = false) {
        self.label = label
        self.value = value
        self.unit = unit
        self.first = first
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            Text(label).fsLabel().padding(.leading, 12)
            if let unit {
                Text(value).fsValue(EFB.green).frame(width: 177.5, alignment: .trailing)
                Text(unit).fsValue(EFB.green).frame(width: 209, alignment: .trailing)
            } else {
                Text(value).fsValue(EFB.green).frame(width: 209, alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fsRow(height: EFB.rowHeight, separator: !first)
    }
}
