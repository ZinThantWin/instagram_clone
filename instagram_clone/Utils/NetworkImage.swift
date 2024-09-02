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
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: imageWidth , maxHeight: imageHeight )
                    .clipped()
            case .failure:
                EmptyView()
            default:
                ProgressView()
            }}
    }
}
