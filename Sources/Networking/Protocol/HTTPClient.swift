import Foundation

/// Main class to perform a request.
public protocol HTTPClient {

    /// Perform a request to the endpoint provided.
    /// - Parameters:
    ///   - endpoint: Endpoint to perform the request.
    /// - Returns: A response if was successful or ``RequestError`` if something went wrong.
    func performRequest<T: Decodable>(to endpoint: Endpoint, for responseModel: T.Type) async throws -> T
}
