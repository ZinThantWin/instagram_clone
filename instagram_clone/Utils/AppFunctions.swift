import Foundation

import Foundation

func convertDateString(_ dateString: String) -> String? {
    // Define the input date format
    let inputFormatter = ISO8601DateFormatter()
    
    // Set the options to include fractional seconds, as your date string has them
    inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    // Convert the input string to a Date object
    guard let date = inputFormatter.date(from: dateString) else {
        return "error"
    }
    
    // Define the output date format
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMM d"
    
    // Convert the Date object to a formatted string
    let formattedDate = outputFormatter.string(from: date)
    
    return formattedDate
}
