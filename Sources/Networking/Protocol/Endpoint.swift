import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String] { get }
    var body: [String: Any] { get }
    var urlParams: [String: String] { get }
}

public extension Endpoint {
    var urlParams: [String: String] { [:] }
    var body: [String: Any] { [:] }
    var port: Int? { nil }

    var urlRequest: URLRequest {
        get throws {
            var components = URLComponents()
            components.scheme = scheme
            components.port = port
            components.host = host
            components.path = path

            if !urlParams.isEmpty {
                components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
            }

            guard let url = components.url else {
                throw  NetworkError.invalidURL
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            if !headers.isEmpty {
                urlRequest.allHTTPHeaderFields = headers
            }

            if !body.isEmpty {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            }

            return urlRequest
        }
    }
}
