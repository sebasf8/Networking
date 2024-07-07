import Foundation

public struct HTTPClientManager: HTTPClient {
    private let urlSession: URLSessionProtocol

    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    public func performRequest<T: Decodable>(to endpoint: Endpoint, for responseModel: T.Type) async throws -> T {
        let request = try endpoint.urlRequest
        let (data, response) = try await urlSession.data(for: request, delegate: nil)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }

        switch response.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(responseModel, from: data)
            } catch {
                print(error)
                throw error
            }
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown
        }
    }
}
