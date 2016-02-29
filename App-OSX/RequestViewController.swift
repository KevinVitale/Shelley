import Shelley
import ReactiveCocoa

// MARK: -
// MARK: JSON View Controller
// MARK: -
public final class RequestViewController: NSViewController {
    // MARK: Properties (Public)
    @IBOutlet var hostURLInput: NSTextField!
    @IBOutlet var hostLabel: NSTextField!
    @IBOutlet var schemeLabel: NSTextField!
    @IBOutlet var pathLabel: NSTextField!
    @IBOutlet var queryLabel: NSTextField!
    @IBOutlet var tableView: NSTableView!

    // MARK: Properties (Private)
    private var _requestViewModel = RequestViewModel()
    private var _resultsController: ResultsController!

    // MARK: Initialization
    public override func viewDidLoad() {
        super.viewDidLoad()
        _resultsController = ResultsController(_requestViewModel.results.signal, tableView: tableView)
        _requestViewModel.urlString <~ hostURLInput.racutil_textSignalProducer.ignoreNil()
        _requestViewModel.host.signal.observeNext { [weak self] in self?.hostLabel.stringValue = $0 ?? "Unknown" }
        _requestViewModel.scheme.signal.observeNext { [weak self] in self?.schemeLabel.stringValue = $0 ?? "Unknown" }
        _requestViewModel.path.signal.observeNext { [weak self] in self?.pathLabel.stringValue = $0 ?? "Unknown" }
        _requestViewModel.query.signal.observeNext { [weak self] in self?.queryLabel.stringValue = $0 ?? "Unknown" }
        _requestViewModel.urlString.value = hostURLInput.stringValue
    }

    // MARK: Actions
    @IBAction func sendRequest(sender: AnyObject?) {
        _requestViewModel.action.value.apply().start()
    }

    @IBAction func reset(sender: AnyObject?) {
        _requestViewModel.reset.apply().start()
        hostURLInput.stringValue = _requestViewModel.urlString.value
    }
}
