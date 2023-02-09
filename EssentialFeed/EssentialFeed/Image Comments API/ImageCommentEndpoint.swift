import Foundation

public enum ImageCommentsEndPoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case let .get(id):
                if #available(iOS 13, *) {
                    return baseURL.appending(path: "/v1/image/\(id)/comments")
                } else {
                    return baseURL.appendingPathExtension("/v1/image/\(id)/comments")
                }
        }
    }
}
