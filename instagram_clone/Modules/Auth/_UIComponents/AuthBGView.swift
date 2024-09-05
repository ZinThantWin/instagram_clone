import SwiftUI

struct AuthBGView : View {
    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [AppColors.authBGImageGradient1, AppColors.authBGImageGradient2,AppColors.authBGImageGradient3]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )).ignoresSafeArea()
    }
}
