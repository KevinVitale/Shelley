import Cocoa
import Shelley

extension NSTextField {
    public var racutil_textSignalProducer: SignalProducer<String?, NoError> {
        return rac_textSignal().toSignalProducer()
            .map { $0 as? String }
            .flatMapError { _ in
                return SignalProducer<String?, NoError>.empty}
    }
}

