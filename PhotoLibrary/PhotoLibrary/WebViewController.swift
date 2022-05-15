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
    
//    init(text: String) {
//            self.text = text
//            super.init(nibName: nil, bundle: nil)
//        }
//
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(text)
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

