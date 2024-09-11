import SwiftUI

struct NetworkImage: View {
    var imageUrlInString : String
    var imageHeight : Double
    var imageWidth : Double
    var body: some View {
        AsyncImage(url: URL(string: (imageUrlInString))){phase in
            switch phase {
            case .empty:
                ProgressView()
                    .foregroundColor(.primary)
                //                Rectangle()
                //                    .frame(width: imageWidth,height: imageHeight)
                //                    .foregroundColor(.gray)
                //                    .redacted(reason: .placeholder)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight )
                    .clipped()
            case .failure:
                Image("noImage")
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight)
                    .clipped()
            default:
                Rectangle()
                    .frame(width: imageWidth,height: imageHeight)
                    .foregroundColor(.gray)
                    .redacted(reason: .placeholder)
            }}
    }
}

struct NetworkImageProfile: View {
    var imageUrlInString : String
    var imageHeight : Double
    var imageWidth : Double
    var body: some View {
        AsyncImage(url: URL(string: (imageUrlInString))){phase in
            switch phase {
            case .empty:
                ProgressView()
                    .foregroundColor(.primary)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight )
                    .clipShape(.circle)
            case .failure:
                Image(systemName: "person.circle")
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight)
                    .clipShape(.circle)
            default:
                Image(systemName: "person.circle")
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight)
                    .clipShape(.circle)
            }}
    }
}
