//
//  WebViewController.swift
//  PhotoLibrary
//
//  Created by Dima on 15.05.22.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    var text: String = ""
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        openUrl()
    }
    
    override func  viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    func openUrl() {

        guard let url = URL(string: "\(text))") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
}

