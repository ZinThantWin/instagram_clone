import SwiftUI
import Combine
import SDWebImageSwiftUI

struct Star {
    var position: CGPoint
    var velocity: CGFloat
    var color: Color
}

struct SplashScreenAnimationPage: View {
    @State private var stars: [Star] = []
    @State private var isAnimating: Bool  = false
    @EnvironmentObject private var splashViewModel : SplashScreenViewModel
    let timer = Timer.publish(every: 0.02, on: .main, in: .default).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack{
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
                Canvas { context, size in
                    for star in stars {
                        let rect = CGRect(x: star.position.x, y: star.position.y, width: 4, height: 4)
                        context.fill(Path(ellipseIn: rect), with: .color(star.color))
                    }
                }
                VStack(alignment: .leading){
                    Spacer()
                    HStack{
                        AnimatedImage(name: "splashGif.gif",isAnimating: $isAnimating)
                            .frame(width: 100, height: 80)
                            .scaledToFit()
                        Spacer()
                    }
                    .padding(.bottom,15)
                    AnimatedText(text: "Welcome to Instagram where you connect with the globe!", lineLimit: 3,fontColor: .white, animationInterval: 0.05)
                        .padding(.bottom,50)
                }
            }
            .navigationDestination(isPresented: $splashViewModel.navigateNow, destination: {
                SplashScreen()
            })
        }
        .onDisappear{
            isAnimating = false
        }
        .onAppear {
            
            isAnimating = true
            stars.removeAll()
            for _ in 1...100 {
                let star = Star(
                    position: CGPoint(x: CGFloat.random(in: -200...screenWidth), y: CGFloat.random(in: 0...screenHeight)),
                    velocity: CGFloat.random(in: 2...5),
                    color: Color(
                        red: Double.random(in: 0...1),
                        green: Double.random(in: 0...1),
                        blue: Double.random(in: 0...1)
                    )
                )
                stars.append(star)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                Task{
//                    TokenManager.shared.deleteToken()
                    await splashViewModel.checkToken()
                }
            })
        }
        .onReceive(timer) { _ in
            for i in 0..<stars.count {
                stars[i].position.y += stars[i].velocity
                stars[i].position.x += 1
                if stars[i].position.y > screenHeight {
                    stars[i].position = CGPoint(x: CGFloat.random(in: -200...screenWidth), y: 0)
                }
            }
        }
    }
}

#Preview {
    SplashScreenAnimationPage()
}
