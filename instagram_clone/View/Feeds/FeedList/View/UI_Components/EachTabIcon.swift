import SwiftUI

struct EachTabIcon<Content: View>: View {
    var content: Content
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            content
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
    }
}
