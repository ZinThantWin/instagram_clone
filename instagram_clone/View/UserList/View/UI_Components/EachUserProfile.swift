import SwiftUI

struct EachUserProfile: View {
    let eachUser : UserModel
    var body: some View {
        HStack(alignment: .top,spacing: 20){
            if let image = eachUser.image {
                NetworkImage(imageUrlInString: image, imageHeight: 50, imageWidth: 50)
                    .clipShape(Circle())
            }else{
                NetworkImage(imageUrlInString: "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png", imageHeight: 50, imageWidth: 50)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading){
                Text(String(eachUser.id))
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(eachUser.name)
                    .font(.title)
                    .foregroundColor(.primary)
                if let bio = eachUser.bio {
                    Text(bio)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
