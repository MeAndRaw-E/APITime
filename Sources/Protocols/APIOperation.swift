import Foundation
import LoggingTime

public protocol APIOperation {
    associatedtype RequestSchema: HTTPRequestSchema = NoRequestData
    associatedtype ResponseSchema: Decodable
    var apiConfigurationKey: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var requestData: RequestSchema { get }
}

extension APIOperation {
    public var path: String {
        "/"
            + String(describing: Self.self).enumerated().map {
                $0.offset > 0 && $0.element.isUppercase ? "-\($0.element.lowercased())" : $0.element.lowercased()
            }.joined()
    }

    public func execute() async throws -> ResponseSchema {
        do {
            return try handleResponse(
                data: try await BackendService.sharedURLSession.data(for: try await makeURLRequest())
            )
        }
        catch let urlError as URLError where urlError.code == .cancelled {
            throw APIError.requestCancelled(
                description: "Request cancelled: \(urlError.failureURLString ?? "nil")"
            )
        }
    }

    private func makeURLRequest() async throws -> URLRequest {
        guard let cfg = APIConfigurationRegistry.get(forKey: apiConfigurationKey) else {
            throw APIError.configurationNotFound(key: apiConfigurationKey)
        }
        var req = URLRequest(url: HTTPEndpoint(method: method, baseURL: cfg.apiBaseURL, path: path).url)
        req.httpMethod = method.rawValue
        try configureRequest(&req, with: requestData)
        return req
    }

    private func configureRequest(_ request: inout URLRequest, with dataModel: any HTTPRequestSchema) throws {
        if let headersModel = dataModel as? HTTPRequestHeaders {
            headersModel.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        if let bodyModel = dataModel as? any HTTPRequestBody {
            PreviewLogger.log("Body before encoding: \(bodyModel.body)", level: .observe)
            let bodyData = try bodyModel.encodeBody(with: StandardJSONCoder.encoder)
            request.httpBody = bodyData
            PreviewLogger.log(
                "Body after encoding: \(String(data: bodyData, encoding: .utf8) ?? "Unable to convert data to string")",
                level: .observe
            )
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let queryModel = dataModel as? HTTPRequestQueryItems, !queryModel.queryItems.isEmpty,
            let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        {
            components.queryItems = queryModel.queryItems
            request.url = components.url
        }
    }

    private func handleResponse(data resp: (Data, URLResponse)) throws -> ResponseSchema {
        guard let http = resp.1 as? HTTPURLResponse else {
            throw APIError.invalidResponse(description: "Non‑HTTP response")
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.httpError(
                statusCode: http.statusCode,
                headers: http.allHeaderFields as? [String: String] ?? [:],
                body: String(data: resp.0, encoding: .utf8)
            )
        }
        do { return try StandardJSONCoder.decoder.decode(ResponseSchema.self, from: resp.0) }
        catch {
            let p = { (c: DecodingError.Context) in c.codingPath.map(\.stringValue).joined(separator: ".") }
            throw APIError.decodingError(
                details: (error as? DecodingError).map {
                    switch $0 {
                    case .keyNotFound(let k, let c): "Missing '\(k.stringValue)' at \(p(c))"
                    case .typeMismatch(_, let c): "Type error at \(p(c))"
                    case .valueNotFound(_, let c): "Null at \(p(c))"
                    case .dataCorrupted(let c): "Bad data at \(p(c))"
                    @unknown default: $0.localizedDescription
                    }
                } ?? error.localizedDescription,
                rawResponse: String(data: resp.0, encoding: .utf8)
            )
        }
    }

    public func callAsFunction() async throws -> ResponseSchema { try await execute() }
}

extension APIOperation where RequestSchema == NoRequestData { public var requestData: RequestSchema { .init() } }
