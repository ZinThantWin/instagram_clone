import SwiftUI
import Combine

struct AnimatedText: View {
    let text: String
    var lineLimit: Int = 2
    var fontColor : Color = .white
    var animationInterval : Double = 0.1
    @State private var displayedCharacters: String = ""
    @State private var currentIndex: Int = 0
    @State var timer : Timer? = nil
    
    var body: some View {
        Text(displayedCharacters)
            .foregroundColor(fontColor)
            .lineLimit(lineLimit)
            .contentTransition(.numericText())
            .font(.system(size: 30, weight: .bold))
            .onAppear{
                displayedCharacters = ""
                currentIndex = 0
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { _ in
                    animateText()
                }
            }
    }
    
    private func animateText() {
        guard currentIndex < text.count else { return }
        
        let index = text.index(text.startIndex, offsetBy: currentIndex)
        withAnimation {
            displayedCharacters.append(text[index])
        }
        currentIndex += 1
    }
    
    private func resetAnimation() {
        displayedCharacters = ""
        currentIndex = 0
    }
}

#Preview {
    VStack {
        AnimatedText(text: "Mingalarpar အချစ်ကလေး")
        AnimatedText(text: "Hello SwiftUI", lineLimit: 1)
    }
}
