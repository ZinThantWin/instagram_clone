import SwiftUI


struct RegisterPage : View {
    var body: some View {
        ZStack{
        bgImage
            VStack(alignment: .leading){
                Text("What's your Email?")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Enter Email address where you can be contacted. No one will see this on your profile.")
                
                    .font(.body)
                    .fontWeight(.medium)
                Text("You may receive WhatsApp and SMS notifications from us for security and login purposes.")
                
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension RegisterPage {
    private var bgImage : some View{
        Rectangle()
            .fill(AppColors().indigoColor.gradient)
//            .opacity(0.5)
            .ignoresSafeArea()
    }
}

#Preview {
    RegisterPage()
}
