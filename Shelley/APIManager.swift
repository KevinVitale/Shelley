// MARK: -
// MARK: API Manager Protocol
// MARK: -
protocol APIManagerProtocol {
    var provider: ReactiveCocoaMoyaProvider<JSONEndpoint> { get }
}

// MARK: -
// MARK: API Manager
// MARK: -
final class APIManager: APIManagerProtocol {
    let provider: ReactiveCocoaMoyaProvider<JSONEndpoint>
    private init() {
        let endpointMapping: JSONEndpoint -> Endpoint<JSONEndpoint> = { aTarget in
            return ReactiveCocoaMoyaProvider.DefaultEndpointMapping(aTarget)
        }

        provider = ReactiveCocoaMoyaProvider (
            endpointClosure: endpointMapping,
            manager: MoyaProvider<JSONEndpoint>.DefaultAlamofireManager(),
            plugins: []
        )
    }

    static let defaultManager: APIManager = APIManager()
}
