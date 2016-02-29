import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(notification: NSNotification) {
        window.contentViewController = RequestViewController()
    }

    func windowWillClose(notification: NSNotification) {
        NSApp.terminate(nil)
    }
}
