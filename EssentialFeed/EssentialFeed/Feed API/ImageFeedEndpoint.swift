import Foundation

public enum ImageFeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case .get:
                if #available(iOS 13, *) {
                    return baseURL.appending(path: "/v1/feed")
                } else {
                    return baseURL.appendingPathExtension("/v1/feed")
                }
        }
    }
}
