import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            if isPresented {
                Text(message)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.opacity)
                    .animation(.easeInOut, value: isPresented)
            }
        }
        .padding()
    }
}
