public enum HTTPMethod: String, Sendable {
    case get, post, put, delete
    public var rawValue: String { String(describing: self).uppercased() }
}
