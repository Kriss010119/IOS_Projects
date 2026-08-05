//
//  WebViewController.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import WebKit

class WebViewController: UIViewController {
    var url: URL?
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.bounds
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
