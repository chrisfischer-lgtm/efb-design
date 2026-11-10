import SwiftUI

/// "Computation is running … Please wait" modal shown while COMPUTE runs (at least
/// `EFB.computeMinimumSeconds`). Metal frame, dark inner panel, spinner, STOP.
public struct ComputingOverlay: View {
    public var onStop: () -> Void
    public static let size = CGSize(width: 420, height: 214)

    public init(onStop: @escaping () -> Void) { self.onStop = onStop }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 6)
                .fill(LinearGradient(colors: [Color(hex: 0xBFC2C7), Color(hex: 0x8C9095), Color(hex: 0x6E7279)],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(EFB.popoverEdge, lineWidth: 1))
                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 3)
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(colors: [Color(hex: 0x55595F), Color(hex: 0x44484E)], startPoint: .top, endPoint: .bottom))
                .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(hex: 0x2B2E33), lineWidth: 1))
                .frame(width: Self.size.width - 36, height: 112)
                .offset(x: 18, y: 18)
            HStack(spacing: 22) {
                ProgressView().progressViewStyle(.circular).tint(.white).scaleEffect(1.35)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Computation is running …").font(EFB.hnc(21)).foregroundStyle(.white)
                    Text("Please wait").font(EFB.hnc(21)).foregroundStyle(.white)
                }
                Spacer(minLength: 0)
            }
            .padding(.leading, 40).padding(.trailing, 24)
            .frame(width: Self.size.width, height: 112, alignment: .leading)
            .offset(y: 18)
            GlossButton(title: "STOP", style: .white, font: EFB.hnc(21), action: onStop)
                .frame(width: 200, height: 44)
                .offset(x: (Self.size.width - 200) / 2, y: 150)
        }
        .frame(width: Self.size.width, height: Self.size.height, alignment: .topLeading)
    }
}
