import SwiftUI
import UIKit

/// Hosts content on the fixed 1180×820 pt design canvas and scales it uniformly to the device.
public struct EFBCanvas<Content: View>: View {
    private let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }

    public var body: some View {
        GeometryReader { geo in
            let scale = min(geo.size.width / EFB.canvas.width, geo.size.height / EFB.canvas.height)
            ZStack {
                EFB.chrome
                content
                    .frame(width: EFB.canvas.width, height: EFB.canvas.height, alignment: .topLeading)
                    .scaleEffect(scale)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .persistentSystemOverlays(.hidden)
        .preferredColorScheme(.light)
    }
}

public extension View {
    /// Absolute placement inside a top-leading `ZStack` (canvas coordinates).
    func at(_ x: CGFloat, _ y: CGFloat, w: CGFloat? = nil, h: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        frame(width: w, height: h, alignment: alignment).offset(x: x, y: y)
    }
}

// MARK: - Brushed metal

/// Procedural horizontal-brushed texture, generated once and tiled seamlessly.
public enum MetalTexture {
    public static let image: UIImage = {
        let size = CGSize(width: 512, height: 512)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 2
        format.opaque = false
        return UIGraphicsImageRenderer(size: size, format: format).image { ctx in
            var seed: UInt64 = 0x9E3779B97F4A7C15
            func rnd() -> CGFloat {
                seed = seed &* 6364136223846793005 &+ 1442695040888963407
                return CGFloat((seed >> 33) & 0xFFFFFF) / CGFloat(0xFFFFFF)
            }
            let c = ctx.cgContext
            // Low-frequency bands a few points tall …
            var y: CGFloat = 0
            while y < size.height {
                let h = 6 + rnd() * 34
                let v = rnd() * 2 - 1
                c.setFillColor((v > 0 ? UIColor.white : UIColor.black).withAlphaComponent(abs(v) * 0.035).cgColor)
                c.fill(CGRect(x: 0, y: y, width: size.width, height: h))
                y += h
            }
            // … plus fine half-point streaks that wrap around the right edge.
            y = 0
            while y < size.height {
                var x: CGFloat = rnd() * 120
                let end = x + size.width
                while x < end {
                    let w = min(60 + rnd() * 260, end - x)
                    let v = rnd() * 2 - 1
                    c.setFillColor((v > 0 ? UIColor.white : UIColor.black).withAlphaComponent(abs(v) * 0.045).cgColor)
                    c.fill(CGRect(x: x, y: y, width: w, height: 0.5))
                    c.fill(CGRect(x: x - size.width, y: y, width: w, height: 0.5))
                    x += w
                }
                y += 0.5
            }
        }
    }()
}

/// Brushed-metal background. The stage: nothing on it is interactive.
public struct Metal: View {
    public var base: Color
    public init(base: Color = EFB.metalLight) { self.base = base }
    public var body: some View {
        base.overlay(Image(uiImage: MetalTexture.image).resizable(resizingMode: .tile))
    }
}
