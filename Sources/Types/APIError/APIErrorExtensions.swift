import Foundation

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .configurationNotFound(let key): "No config: \(key)"
        case .invalidResponse(let desc): desc
        case .httpError(let code, _, let body): "HTTP \(code): \(body?.prefix(100) ?? "")"
        case .requestCancelled(let desc): desc
        case .decodingError(let details, _): details
        }
    }
}
