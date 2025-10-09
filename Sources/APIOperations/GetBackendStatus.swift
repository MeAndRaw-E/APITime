public struct GetBackendStatusResponseDataModel: Decodable, Sendable {
    let status: String
}

public struct GetBackendStatus: APIOperation {
    public typealias ResponseSchema = GetBackendStatusResponseDataModel
    public typealias RequestSchema = NoRequestData

    public var apiConfigurationKey: String
    public let method: HTTPMethod = .get
    public let requestData = NoRequestData()

    public init(apiConfigurationKey: String) { self.apiConfigurationKey = apiConfigurationKey }
}
