import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst().lowercased()
    }
}

extension JSONDecoder {
    func convertFromUpperCase() {
        self.keyDecodingStrategy = .custom { codingKeys in
            let key = codingKeys.last!.stringValue
            let convertedKey = key.lowercased().capitalizingFirstLetter()
            return AnyKey(stringValue: convertedKey) ?? codingKeys.last!
        }
    }
}

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}
