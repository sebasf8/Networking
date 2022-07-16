enum NetworkError: Error {
    case decode
    case invalidURL
    case notFound
    case noResponse
    case serverError
    case unauthorized
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Authorization required"
        case .invalidURL:
            return "Invalid URL"
        case .serverError:
            return "Server Error"
        case .notFound:
            return "Resource not found"
        case .noResponse:
            return "No response available"
        case .unknown:
            return "Unknown error"
        }
    }
}
