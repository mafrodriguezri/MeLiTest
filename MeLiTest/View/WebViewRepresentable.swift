//
//  WebViewRepresentable.swift
//  MeLiTest
//
//  Created by Manuel on 6/10/22.
//
    
import SwiftUI
import WebKit
import Network
 
struct WebViewRepresentable: UIViewRepresentable {
    
    let url: URL
    @Binding var processFinished: Bool
    @Binding var siteFailedToLoad: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView: WKWebView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request: URLRequest = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func loadDidFinish() {
        processFinished = true
    }
    
    func loadDidFail() {
        processFinished = true
        siteFailedToLoad = true
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: WebViewRepresentable
        
        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.loadDidFinish()
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.loadDidFail()
        }
    }
}

class ConnectionStatusHelper: ObservableObject {
    
    @Published var networkAvailable: Bool = true
    private let monitor: NWPathMonitor = NWPathMonitor()
    
    /// Starts checking for network status changes
    func checkConnectionStatus() {
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.updateNetworkStatus(available: true)
                print("MeLiTest Connection available.")
            } else {
                self?.updateNetworkStatus(available: false)
                print("MeLiTest Connection lost.")
            }
        }
        
        let queue: DispatchQueue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    private func updateNetworkStatus(available: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.networkAvailable = available
        }
    }
}
