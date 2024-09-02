import SwiftUI

struct LoginEmailTextField: View {
    @EnvironmentObject private var vm : LoginViewModel
    var body: some View {
        AuthTextField(hintText: "Email", text: $vm.loginEmail)
    }
}

#Preview {
    LoginEmailTextField()
}
