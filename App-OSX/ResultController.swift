import Cocoa
import Shelley
import ReactiveCocoa

// MARK: -
// MARK: Results Controller
// MARK: -
public final class ResultsController: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    // Mark: Properties (Private)
    let _results: MutableProperty<[Any]> = MutableProperty([])
    var _sizingCell: NSTableCellView!
    
    // MARK:
    public required init(_ resultsSignal: Signal<[Any], NoError>, tableView: NSTableView!) {
        super.init()

        tableView.setDataSource(self)
        tableView.setDelegate(self)
        tableView.columnAutoresizingStyle = .UniformColumnAutoresizingStyle
        tableView.rowSizeStyle = .Custom
        _sizingCell = tableView.makeViewWithIdentifier("cell", owner: nil)! as? NSTableCellView

        _results <~ resultsSignal
            .observeOn(UIScheduler())

        _results.signal
            .observeNext { results in
                let indexSet = NSIndexSet(indexesInRange: NSRange.init(location: 0, length: results.count))
                NSAnimationContext.beginGrouping()
                NSAnimationContext.currentContext().duration = 0
                tableView.noteHeightOfRowsWithIndexesChanged(indexSet)
                NSAnimationContext.endGrouping()
                tableView.reloadData()
        }
    }

    public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return _results.value.count
    }

    public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard _results.value.count > 0 else {
            return nil
        }

        switch (tableColumn?.identifier, row) {
        case (_?, _):
            let cellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
            let value = _results.value[row]
            cellView.textField!.stringValue = "\(value)"
            cellView.textField!.sizeToFit()
            return cellView
        default: return nil
        }
    }

    public func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }

    public func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        guard _results.value.count > 0 else {
            print("no count")
            return 100
        }

        guard let value = _results.value[row] as? AnyObject else {
            print("no results")
            return 100
        }

        _sizingCell.objectValue = value
        _sizingCell.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: tableView.frame.width))
        _sizingCell.textField?.stringValue = "\(value)"
        _sizingCell.textField?.sizeToFit()
        let height = _sizingCell.textField?.bounds.height ?? 100
        return height
    }
}
