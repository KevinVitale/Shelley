// MARK: -
// MARK: JSON Target
// MARK: -
public struct JSONTarget<T>: TargetType {
    internal let provider: ReactiveCocoaMoyaProvider<JSONEndpoint>
    internal var endpoint: JSONEndpoint

    init(endpoint: JSONEndpoint) {
        self.endpoint = endpoint
        self.provider = APIManager.defaultManager.provider
    }

    public var baseURL: NSURL {
        return endpoint.baseURL
    }

    public var path: String {
        return endpoint.path
    }

    public var method: ReactiveMoya.Method {
        return endpoint.method
    }

    public var parameters: [String:AnyObject]? {
        return endpoint.parameters
    }

    public var sampleData: NSData {
        return endpoint.sampleData
    }
}

// MARK: -
// MARK: JSON Target (SignalProducerType)
// MARK: -
extension JSONTarget: SignalProducerType {
    public typealias Value = T
    public typealias Error = ReactiveMoya.Error

    public var producer: SignalProducer<Value, Error> {
        let p: SignalProducer<Response, Error> = provider.request(self.endpoint)
        return p.mapJSONResponse()
    }

    public func startWithSignal(@noescape setUp: (Signal<Value, Error>, Disposable) -> ()) {
        producer.startWithSignal(setUp)
    }
}

// MARK: -
// MARK: Map JSON Response
// MARK: -
extension SignalProducerType where Value == Response, Error == ReactiveMoya.Error {
    private func mapJSONResponse<T>() -> SignalProducer<T, Error> {
        return mapJSON()
            .attemptMap { (next: AnyObject) -> Result<[AnyObject], Error> in
                if let value = next as? [AnyObject] {
                    return .Success(value)
                }
                let a = [next]
                return .Success(a)
            }
            .flatMap(.Latest) { SignalProducer(values: $0) }
            .attemptMap { (next: AnyObject) -> Result<T, Error> in
                if let value = next as? T {
                    return .Success(value)
                }
                return .Failure(Error.JSONMapping(Response(statusCode: 0, data: NSData())))
            }
            .filter {
                if let dict = $0 as? [String:AnyObject] {
                    if let enabled = dict["enabled"] as? Bool {
                        return enabled
                    }
                    return true
                }
                return true
        }
    }
}

// MARK: -
// MARK: Action Extension
// MARK: -
extension JSONTarget {
    public var action: Action<(), Value, Error> {
        return Action { self.producer }
    }
}
