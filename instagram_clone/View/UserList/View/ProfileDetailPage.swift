import SwiftUI

struct ProfileDetailPage: View {
    let eachUser : UserModel
    var body: some View {
        Text(eachUser.name)
    }
}
