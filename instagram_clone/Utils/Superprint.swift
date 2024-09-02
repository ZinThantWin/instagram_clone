
import Foundation

func superPrint(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
    let message = items.map { "\($0)" }.joined(separator: " ")
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    let dateTime = formatter.string(from: Date())
//    let fileURL = URL(fileURLWithPath: file)
    print("🍎 \(message)")
//    print("⏱️ [\(dateTime)]")
//    print("📁 File: \(fileURL.absoluteString), Line Number ==> \(line)")
}
