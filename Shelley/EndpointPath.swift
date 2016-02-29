// MARK: -
// MARK: Endpoint Path
// MARK: -
public protocol EndpointPath {
    var endpointPath: String { get }
}

// MARK: -
// MARK: Raw Representable Extension
// MARK: -
public extension RawRepresentable where RawValue == String {
    public var endpointPath: String {
        return self.rawValue
    }
}

// MARK: -
// MARK: String Extension
// MARK: -
public extension String {
    public var endpointPath: String {
        return self
    }
}
extension String: EndpointPath { }
