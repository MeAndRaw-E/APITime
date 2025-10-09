import Foundation
import LoggingTime

public func executeAPIOperation<O: APIOperation>(
    _ op: O,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) async throws -> O.ResponseSchema {
    do { return try await op.execute() }
    catch {
        let ctx = LoggingContext.withCaller(callerFile: file, callerFunction: function, callerLine: line)
        if case APIError.requestCancelled(let description) = error {
            PreviewLogger.log("Request cancelled: \(description)", level: .info, context: ctx)
        }
        else {
            PreviewLogger.log("APIOperation failed: \(error)", level: .error, context: ctx)
        }
        throw error
    }
}
