import Foundation

public enum APIConfigurationRegistry {
    private static nonisolated(unsafe) var configurations: [String: APIConfiguration] = [:]
    private static let lock = NSLock()

    public static func register(_ configuration: APIConfiguration) {
        lock.withLock { configurations[configuration.key] = configuration }
    }

    public static func get(forKey key: String) -> APIConfiguration? {
        lock.withLock { configurations[key] }
    }
}

public func registerAPIConfiguration(_ configuration: APIConfiguration) {
    APIConfigurationRegistry.register(configuration)
}
