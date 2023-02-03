import Foundation

public enum ImageCommentsEndPoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case let .get(id):
                return baseURL.appending(path: "/v1/image/\(id)/comments")
        }
    }
}
