import SwiftUI

struct NetworkImage: View {
    var imageUrlInString : String
    var imageHeight : Double
    var imageWidth : Double
    var body: some View {
        AsyncImage(url: URL(string: (imageUrlInString))){phase in
            switch phase {
            case .empty:
                Rectangle()
                    .frame(width: imageWidth,height: imageHeight)
                    .foregroundColor(.gray)
                    .redacted(reason: .placeholder)
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
                Rectangle()
                    .fill(Color(uiColor: #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)))
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight )
                    .clipShape(.circle)
                    .overlay {
                        ProgressView()
                    }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight )
                    .clipShape(.circle)
            case .failure:
                Rectangle()
                    .fill(Color(uiColor: #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)))
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight )
                    .clipShape(.circle)
            default:
                Rectangle()
                    .fill(Color(uiColor: #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)))
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight )
                    .clipShape(.circle)
            }}
    }
}
