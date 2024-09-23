import SwiftUI


struct MeshText : View {
    var body: some View {
        MeshGradientView()
            .frame(width: .infinity, height: 800)
            .mask {
                Image("meta_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 900, height: 200)
            }
            
    }
}

struct MeshGradientView : View {
    @State private var points : [SIMD2<Float>] = getMeshPoints()
    @State private var colors : [Color] = generateRandomColors()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
            if #available(iOS 18.0, *) {
                MeshGradient(width: 3, height: 3, points: points, colors: colors)
                    .onReceive(timer) { _ in
                        withAnimation(.easeIn(duration: 1)) {
                            colors = generateRandomColors()
                        }
                    }
            } else {
                Rectangle()
                    .fill(.black)
            }
    }
}

func generateRandomColors() -> [Color] {
    (0...8).map { _ in
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

func getMeshPoints() -> [SIMD2<Float>]{
    return  [
        SIMD2(x: 0.0, y: 0.0 ),SIMD2(x: 0.5, y: 0.0),SIMD2(x: 1, y: 0.0),
        SIMD2(x: 0.0, y: 0.33),SIMD2(x: 0.5, y: 0.33),SIMD2(x: 1, y: 0.33),
        SIMD2(x: 0.0, y: 0.66),SIMD2(x: 0.5, y: 0.66),SIMD2(x: 1, y: 0.66),
        SIMD2(x: 0.0, y: 1.0),SIMD2(x: 0.5, y: 1.0),SIMD2(x: 1, y: 1.0),
    ]
}

#Preview {
    MeshText()
}
