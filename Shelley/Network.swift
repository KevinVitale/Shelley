public typealias NoError = ReactiveCocoa.NoError

public var CurrentAPIHost: String = ""

// MARK: -
// MARK: JSON Request
// MARK: -
public func JSONRequest<T>(endpointPath: EndpointPath, method: ReactiveMoya.Method = .GET, parameters: [String:AnyObject]? = nil) -> JSONTarget<T> {
    let endpoint = JSONEndpoint.Request(endpointPath: endpointPath, method: method, parameters: parameters)
    return JSONTarget(endpoint: endpoint)
}
