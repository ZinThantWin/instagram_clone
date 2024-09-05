import SwiftUI


struct RegisterPage : View {
    @EnvironmentObject private var vm : RegisterViewModel
    var body: some View {
        NavigationStack{
            ZStack{
                AuthBGView()
                VStack(alignment: .leading){
                    Text("What's your Email?")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("Enter Email address where you can be contacted. No one will see this on your profile.")
                        .font(.body)
                        .fontWeight(.medium)
                    RegisterNameTextField()
                    RegisterEmailTextField().padding(.vertical, 5)
                    RegisterPasswordTextField().padding(.bottom,2)
                    RegisterButton().frame(width: UIScreen.main.bounds.width - 40,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("You may receive WhatsApp and SMS notifications from us for security and login purposes.")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal,20)
            }.navigationDestination(isPresented: $vm.registerSuccess){
                LoginPage()
            }
        }
    }
}

#Preview {
    RegisterPage().environmentObject(RegisterViewModel())
        .preferredColorScheme(.dark)
}
