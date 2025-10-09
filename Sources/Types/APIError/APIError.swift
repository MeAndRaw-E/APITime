public enum APIError: Error, Sendable {
    case configurationNotFound(key: String)
    case invalidResponse(description: String)
    case httpError(statusCode: Int, headers: [String: String], body: String?)
    case requestCancelled(description: String)
    case decodingError(details: String, rawResponse: String?)
}
