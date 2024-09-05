import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0
    var baseColor: Color
    var highlightColor: Color
    var width: CGFloat
    var height: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [baseColor.opacity(0), highlightColor, baseColor.opacity(0)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: phase * width, y: phase * height)
                    .mask(content)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering(baseColor: Color = .gray, highlightColor: Color = .white, width: CGFloat = 200, height: CGFloat = 200) -> some View {
        self.modifier(Shimmer(baseColor: baseColor, highlightColor: highlightColor, width: width, height: height))
    }
}
