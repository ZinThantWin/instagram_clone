import Foundation
import SwiftUI

enum ApiError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unauthorized
    case serverError
    case networkError
    case tokenExpired
    case unknownError
}

class ApiService {
    
    static let shared = ApiService()
    private init() {}
    
    var apiToken: String = ""
    let baseUrl: String = "https://social.petsentry.info/"
    
    func apiGetCall<T: Decodable>(from endpoint: String, as type: T.Type, xNeedToken: Bool = true ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30.0
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            superPrint("\(httpResponse.statusCode) \(endpoint)")
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    
                    superPrint("Decoding error: \(error)")
                    throw ApiError.invalidData
                }
            } else if httpResponse.statusCode == 401 {
                superPrint("Token expired, handling expiration")
                onTokenExpired()
                throw ApiError.tokenExpired // More specific error
            } else {
                superPrint("Unexpected status code: \(httpResponse.statusCode)")
                throw ApiError.invalidResponse
            }
        } catch {
            superPrint("unexpected error! \(error)")
            throw ApiError.unknownError
        }
    }
    
    
    func apiPostCall<T: Decodable, U: Encodable>(
        to endpoint: String,
        body: U,
        as type: T.Type,
        xNeedToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let bodyData = try encoder.encode(body)
            request.httpBody = bodyData
        } catch {
            superPrint("Encoding error: \(error)")
            throw ApiError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            superPrint("\(httpResponse.statusCode) \(endpoint)")
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    superPrint("Decoding error: \(error)")
                    throw ApiError.invalidData
                }
            } else if httpResponse.statusCode == 401 {
                superPrint("Token expired, handling expiration")
                onTokenExpired()
                throw ApiError.tokenExpired // More specific error
            } else {
                superPrint("Unexpected status code: \(httpResponse.statusCode)")
                throw ApiError.invalidResponse
            }
        } catch {
            superPrint("Network request failed: \(error)")
            throw ApiError.networkError
        }
    }
    
    func apiPostCallAny<T: Decodable>(
        to endpoint: String,
        body: [String: Any],
        as type: T.Type,
        xNeedToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = bodyData
        } catch {
            superPrint("Serialization error: \(error)")
            throw ApiError.invalidData
        }
        
        return try await executeRequest(request, responseType: T.self)
    }
    
    // Common function to execute the network request and decode the response
    private func executeRequest<T: Decodable>(
        _ request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    superPrint("Decoding error: \(error)")
                    throw ApiError.invalidData
                }
            } else if httpResponse.statusCode == 401 {
                superPrint("Token expired, handling expiration")
                onTokenExpired()
                throw ApiError.tokenExpired
            } else {
                superPrint("Unexpected status code: \(httpResponse.statusCode)")
                throw ApiError.invalidResponse
            }
        } catch {
            superPrint("Network request failed: \(error)")
            throw ApiError.networkError
        }
    }
    
    func apiUpdateImage<T: Decodable>(
        to endpoint: String,
        imageData: Data?,
        imageName: String,
        formFields: [String: Any],
        as type: T.Type,
        xNeedToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = 30.0
        
        // Boundary string
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Create multipart form data
        var body = Data()
        
        // Append all key-value pairs from formFields
        for (key, value) in formFields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            
            // Convert `Any` to `String` and append to body
            if let stringValue = value as? String {
                body.append("\(stringValue)\r\n".data(using: .utf8)!)
            } else if let intValue = value as? Int {
                body.append("\(intValue)\r\n".data(using: .utf8)!)
            } else if let doubleValue = value as? Double {
                body.append("\(doubleValue)\r\n".data(using: .utf8)!)
            } else {
                throw ApiError.invalidData // Handle unsupported data types
            }
        }
        
        // Append image data if it's not nil
        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(imageName)\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!) // Adjust based on image type if necessary
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } else if httpResponse.statusCode == 401 {
                onTokenExpired()
                throw ApiError.tokenExpired
            } else {
                throw ApiError.invalidResponse
            }
        } catch {
            throw ApiError.networkError
        }
    }
    
    func uploadNewFeed<T: Decodable>(
        to endpoint: String,
        imageData: Data?,
        imageName: String,
        title: String,
        content: String,
        as type: T.Type,
        xNeedToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        
        // Boundary string
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Create multipart form data
        var body = Data()
        
        // Append title field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(title)\r\n".data(using: .utf8)!)
        
        // Append content field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"content\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(content)\r\n".data(using: .utf8)!)
        
        // Append image data only if it's not nil
        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(imageName)\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            superPrint("HTTP Response Status Code: \(httpResponse.statusCode)")
            superPrint("Response Body: \(String(data: data, encoding: .utf8) ?? "No response body")")
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    superPrint("Decoding error: \(error)")
                    throw ApiError.invalidData
                }
            } else if httpResponse.statusCode == 401 {
                superPrint("Token expired, handling expiration")
                onTokenExpired()
                throw ApiError.tokenExpired
            } else {
                superPrint("Unexpected status code: \(httpResponse.statusCode)")
                throw ApiError.invalidResponse
            }
        } catch {
            superPrint("Network request failed: \(error)")
            throw ApiError.networkError
        }
    }

    
    func updateNewFeed<T: Decodable>(
        to endpoint: String,
        imageData: Data?,
        imageName: String,
        title: String,
        content: String,
        as type: T.Type,
        xNeedToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = 30.0
        
        // Boundary string
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Create multipart form data
        var body = Data()
        
        // Append title field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(title)\r\n".data(using: .utf8)!)
        
        // Append content field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"content\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(content)\r\n".data(using: .utf8)!)
        
        // Append image data only if it's not nil
        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(imageName)\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!) // Adjust if using PNG or other formats
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            superPrint("HTTP Response Status Code: \(httpResponse.statusCode)")
            superPrint("Response Body: \(String(data: data, encoding: .utf8) ?? "No response body")")
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    superPrint("Decoding error: \(error)")
                    throw ApiError.invalidData
                }
            } else if httpResponse.statusCode == 401 {
                superPrint("Token expired, handling expiration")
                onTokenExpired()
                throw ApiError.tokenExpired
            } else {
                superPrint("Unexpected status code: \(httpResponse.statusCode)")
                throw ApiError.invalidResponse
            }
        } catch {
            superPrint("Network request failed: \(error)")
            throw ApiError.networkError
        }
    }
    
    func apiPutCall<T: Decodable, U: Encodable>(
        to endpoint: String,
        body: U,
        as type: T.Type,
        xNeedToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let bodyData = try encoder.encode(body)
            request.httpBody = bodyData
        } catch {
            superPrint("Encoding error: \(error)")
            throw ApiError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            superPrint("\(httpResponse.statusCode) \(endpoint)")
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    superPrint("Decoding error: \(error)")
                    throw ApiError.invalidData
                }
            } else if httpResponse.statusCode == 401 {
                superPrint("Token expired, handling expiration")
                onTokenExpired()
                throw ApiError.tokenExpired
            } else {
                superPrint("Unexpected status code: \(httpResponse.statusCode)")
                throw ApiError.invalidResponse
            }
        } catch {
            superPrint("Network request failed: \(error)")
            throw ApiError.networkError
        }
    }
    
    func apiDeleteCall<T: Decodable>(
        from endpoint: String,
        as type: T.Type,
        xNeedToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if xNeedToken {
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            
            superPrint("\(httpResponse.statusCode) \(endpoint)")
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    superPrint("Decoding error: \(error)")
                    throw ApiError.invalidData
                }
            } else if httpResponse.statusCode == 401 {
                superPrint("Token expired, handling expiration")
                onTokenExpired()
                throw ApiError.tokenExpired
            } else {
                superPrint("Unexpected status code: \(httpResponse.statusCode)")
                throw ApiError.invalidResponse
            }
        } catch {
            superPrint("Network request failed: \(error)")
            throw ApiError.networkError
        }
    }
    
    
    private func onTokenExpired(){
//        TokenManager.shared.deleteToken()
    }
    
    
}
