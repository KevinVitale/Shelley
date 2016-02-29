import Shelley
import ReactiveCocoa

public typealias RequestAction = Action<(), [Any], Error>

// MARK: -
// MARK: Host View Model
// MARK: -
public final class RequestViewModel {
    // MARK: Properties (Public)
    public let urlString = MutableProperty("")

    // MARK: Properties (Private)
    private let _components: MutableProperty<NSURLComponents?> = MutableProperty(nil)
    private let _host: MutableProperty<String?> = MutableProperty(nil)
    private let _scheme: MutableProperty<String?> = MutableProperty(nil)
    private let _path: MutableProperty<String?> = MutableProperty(nil)
    private let _query: MutableProperty<String?> = MutableProperty(nil)

    private let _request: MutableProperty<JSONTarget<Any>?> = MutableProperty(nil)
    private let _results: MutableProperty<[Any]> = MutableProperty([])
    private let _action: MutableProperty<RequestAction> = MutableProperty(Action { _ in SignalProducer.empty })

    // MARK: Initialization
    public init() {
        _components <~ urlString.signal.map { NSURLComponents(string: $0) }
        _host <~ _components.signal.map { $0?.host }
        _scheme <~ _components.signal.map { $0?.scheme }
        _path <~ _components.signal.map { $0?.path }
        _query <~ _components.signal.map { $0?.query?.stringByReplacingOccurrencesOfString("&", withString: "\n") }
        
        _request <~ _components.signal
            .map {
                guard let scheme = $0?.scheme,
                    let host = $0?.host else {
                        return nil
                }
                var port: String = ""
                if let string = $0?.port {
                    port = "\(string)"
                }

                CurrentAPIHost = scheme + "://" + host
                if !port.isEmpty {
                    CurrentAPIHost += ":\(port)"
                }

                var parameters: [String:AnyObject]? = nil
                if let queryItems = ($0?.queryItems?.filter { $0.value != nil }) {
                    parameters = [:]
                    for item in queryItems {
                        parameters?[item.name] = item.value!
                    }
                }
                return JSONRequest($0?.path ?? "", parameters: parameters)
        }

        _action <~ _request.signal
            .ignoreNil()
            .map { $0.collect() }
            .map { producer in
                Action { producer }
        }

        _results <~ _action.signal
            .map { $0.values }
            .flatten(.Latest)
            .map {
                $0.map {
                    if let json = $0 as? [String:AnyObject] {
                        return Array(json.enumerate()).map {
                            $0.element.0.uppercaseString + ":\n\($0.element.1)"
                            }
                            .joinWithSeparator("\n\n")
                    } else {
                        return $0
                    }
                }
        }
    }

    // MARK: Computer Properties
    public var action: AnyProperty<RequestAction> {
        return AnyProperty(_action)
    }

    public var reset: Action<(), (), NoError> {
        return Action { [weak self] in
            self?._results.value = []
            self?.urlString.value = ""
            return SignalProducer.empty
        }
    }

    public var results: AnyProperty<[Any]> {
        return AnyProperty(_results)
    }

    public var host: AnyProperty<String?> {
        return AnyProperty(_host)
    }

    public var scheme: AnyProperty<String?> {
        return AnyProperty(_scheme)
    }

    public var path: AnyProperty<String?> {
        return AnyProperty(_path)
    }

    public var query: AnyProperty<String?> {
        return AnyProperty(_query)
    }
}
