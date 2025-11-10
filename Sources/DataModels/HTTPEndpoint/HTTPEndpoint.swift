import Foundation

public struct HTTPEndpoint: Sendable {
    let method: HTTPMethod
    let baseURL: URL
    let path: String

    public init(method: HTTPMethod, baseURL: URL, path: String) {
        self.method = method
        self.baseURL = baseURL
        self.path = path
    }

    var url: URL {
        baseURL.appendingPathComponent(path)
    }
}
