import SwiftUI

struct RegisterPageRouteButton: View {
    var body: some View {
        NavigationLink(destination: RegisterPage()) {
            Text("Create new account")
                .padding(.vertical, 6)
                .foregroundStyle(AppColors.authButtonColor)
                .frame(maxWidth: .infinity)
                .background(AppColors.authButtonColor.opacity(0.1)) // Optional: Add a background color to make button visible
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(AppColors.authButtonColor, lineWidth: 1.5)
                )
        }
    }
}
