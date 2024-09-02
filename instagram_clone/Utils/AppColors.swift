import SwiftUI

class AppColors {
    static let indigoColor : Color = Color.init(hex: "5851d8")
    static let indigoBlueColor : Color = Color.init(hex: "405de6")
    static let purpleColor : Color = Color.init(hex: "833ab4")
    static let indigoPinkColor : Color = Color.init(hex: "c13548")
    static let brightRedColor : Color = Color.init(hex: "e1306c")
    static let redColor : Color = Color.init(hex: "fd1d1d")
    static let orangeColor : Color = Color.init(hex: "f56040")
    static let lightOrangeColor : Color = Color.init(hex: "f56040")
    static let vLightOrangeColor : Color = Color.init(hex: "f77737")
    static let vOrangeColor : Color = Color.init(hex: "fc1f45")
    static let potatoColor : Color = Color.init(hex: "ffdc80")
    
    //Auth
    //Auth Bg color codes
    static let authBGImageGradient1: Color = Color(red: 58/255.0, green: 101/255.0, blue: 147/255.0, opacity: 1.0)
    static let authBGImageGradient2: Color = Color(red: 72/255.0, green: 133/255.0, blue: 158/255.0, opacity: 1.0)
    static let authBGImageGradient3: Color = Color(red: 89/255.0, green: 168/255.0, blue: 182/255.0, opacity: 1.0)
    
    //Auth Textfield
    static let authButtonColor : Color = Color.init(hex: "0044ff")
    static let authTextFieldBorderColor: Color = Color(red: 65/255.0, green: 81/255.0, blue: 95/255.0, opacity: 1.0)
    static let authTextFieldBGColor: Color = Color(red: 29/255.0, green: 38/255.0, blue: 45/255.0, opacity: 1.0)
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

