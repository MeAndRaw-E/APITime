import Foundation

public struct APIConfiguration: Sendable {
    let key: String
    let apiBaseURL: URL

    public init(key: String, apiBaseURL: URL) {
        self.key = key
        self.apiBaseURL = apiBaseURL
    }
}
