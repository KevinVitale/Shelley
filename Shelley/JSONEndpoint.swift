// MARK: -
// MARK: JSON Endpoint
// MARK: -
enum JSONEndpoint {
    case Request(
        endpointPath: EndpointPath,
        method: ReactiveMoya.Method,
        parameters: [String:AnyObject]?
    )
}

// MARK: -
// MARK: Target Type Extension
// MARK: -
extension JSONEndpoint: TargetType {
    var baseURL: NSURL {
        return NSURL(string: CurrentAPIHost)!
    }

    var path: String {
        switch self {
        case .Request(let endpointPath, _, _):
            return endpointPath.endpointPath
        }
    }

    var method: ReactiveMoya.Method {
        switch self {
        case .Request(_, let method, _):
            return method
        }
    }

    var parameters: [String:AnyObject]? {
        switch self {
        case .Request(_, _, let parameters):
            return parameters
        }
    }

    var sampleData: NSData {
        return NSData()
    }
}
