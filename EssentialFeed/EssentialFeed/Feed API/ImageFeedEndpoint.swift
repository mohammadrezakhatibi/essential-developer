import Foundation

public enum ImageFeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case .get:
                return baseURL.appending(path: "/v1/feed")
        }
    }
}
