import Foundation

struct HTTPClientManager: HTTPClient {
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func performRequest<T: Decodable>(to endpoint: Endpoint, for responseModel: T.Type) async throws -> T {
        let request = try endpoint.urlRequest
        let (data, response) = try await urlSession.data(for: request, delegate: nil)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }

        switch response.statusCode {
        case 200...299:
            guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                throw NetworkError.decode
            }
            return decodedResponse
        case 401:
            throw NetworkError.decode
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown
        }
    }
}
