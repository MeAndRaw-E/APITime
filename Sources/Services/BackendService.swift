import Foundation
import LoggingTime

public actor BackendService {
    public private(set) var backendConfigurationKey = ""

    public static let sharedURLSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.httpShouldSetCookies = true
        configuration.httpCookieAcceptPolicy = .always
        return URLSession(configuration: configuration)
    }()

    public static let shared = BackendService()

    public func setupBackendConfiguration(backendConfigurationKey configKey: String, backendBaseURL: URL) async {
        backendConfigurationKey = configKey
        registerAPIConfiguration(
            APIConfiguration(key: backendConfigurationKey, apiBaseURL: backendBaseURL)
        )
    }

    public func checkBackendHealth() async -> Bool {
        guard
            let response = try? await executeAPIOperation(
                GetBackendStatus(apiConfigurationKey: backendConfigurationKey)
            )
        else { return false }
        return response.status == "operational"
    }
}
