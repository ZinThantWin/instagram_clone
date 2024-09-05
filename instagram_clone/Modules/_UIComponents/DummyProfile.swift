import SwiftUI

struct DummyProfile: View {
    var size : Double
    var color : Color = .gray
    var body: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size , height: size )
            .foregroundColor(color )
    }
}
