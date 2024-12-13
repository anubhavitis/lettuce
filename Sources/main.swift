import Cocoa
import WebKit

class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate, NSWindowDelegate,
    WKUIDelegate
{
    var window: NSWindow!
    var webView: WKWebView!
    var localMonitor: Any?
    var globalMonitor: Any?

    func setupEventMonitors() {
        // Monitor for local events (when app is active)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [
            .keyDown, .keyUp, .mouseMoved, .leftMouseDown, .rightMouseDown, .leftMouseUp,
            .rightMouseUp,
        ]) { event in
            self.handleEvent(event)
            return event
        }

        // Monitor for global events (when app is in background)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [
            .mouseMoved, .leftMouseDown, .rightMouseDown, .leftMouseUp, .rightMouseUp,
        ]) { event in
            //self.handleEvent(event)
        }
    }

    func handleEvent(_ event: NSEvent) {
        switch event.type {
        case .keyDown:
            print("Key Down - Key: \(event.characters ?? ""), KeyCode: \(event.keyCode)")
        case .keyUp:
            print("Key Up - Key: \(event.characters ?? ""), KeyCode: \(event.keyCode)")
        //case .mouseMoved:
        //    let location = event.locationInWindow
        //    print("Mouse Moved - Location: \(location)")
        //case .leftMouseDown:
        //    print("Left Mouse Down - Location: \(event.locationInWindow)")
        //case .rightMouseDown:
        //    print("Right Mouse Down - Location: \(event.locationInWindow)")
        //case .leftMouseUp:
        //    print("Left Mouse Up - Location: \(event.locationInWindow)")
        //case .rightMouseUp:
        //    print("Right Mouse Up - Location: \(event.locationInWindow)")
        default:
            break
        }
    }

    // Clean up monitors when app terminates
    func applicationWillTerminate(_ notification: Notification) {
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 1. Configure WebView
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

        // Add handlers for cursor changes
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController

        // 2. Create Window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false)

        // 3. Create WebView
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self

        if #available(macOS 13.3, *) {
            webView.isInspectable = true
        }

        // 4. Setup Window
        window.delegate = self
        window.contentView = webView
        window.title = "Browser"

        // 5. Enable necessary settings for input
        window.acceptsMouseMovedEvents = true
        window.isReleasedWhenClosed = false

        let fileURL = URL(fileURLWithPath: "src/index.html", isDirectory: false)
        let directoryURL = fileURL.deletingLastPathComponent()
        webView.loadFileURL(fileURL, allowingReadAccessTo: directoryURL)

        // Add this for debugging
        print("Attempting to load from: \(fileURL.path)")

        // 7. Setup window and activate
        window.makeFirstResponder(webView)
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.accessibilityFocusedWindow()

        // 9. Ensure proper focus
        NSApp.activate(ignoringOtherApps: true)
        window.makeKey()
        webView.becomeFirstResponder()

        setupEventMonitors()
    }
}

// Create and run the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
//_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
