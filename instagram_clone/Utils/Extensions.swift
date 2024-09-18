import SwiftUI

extension Image {
    // Function to create an app logo with optional width and height
    @ViewBuilder
    static func appLogo(named name: String, width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        let image = Image(name) // Use the provided name parameter for the image

        if let width = width, let height = height {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
        } else if let width = width {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
        } else if let height = height {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: height)
        } else {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension View {
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
}
