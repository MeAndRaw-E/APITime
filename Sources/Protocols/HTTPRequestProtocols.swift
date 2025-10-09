import Foundation

public protocol HTTPRequestSchema {}
public protocol HTTPRequestHeaders { var headers: [String: String] { get } }
public protocol HTTPRequestQueryItems { var queryItems: [URLQueryItem] { get } }
public protocol HTTPRequestBody {
    associatedtype Body: Encodable
    var body: Body { get }
    func encodeBody(with encoder: JSONEncoder) throws -> Data
}
extension HTTPRequestBody {
    public func encodeBody(with encoder: JSONEncoder) throws -> Data { try encoder.encode(body) }
}
