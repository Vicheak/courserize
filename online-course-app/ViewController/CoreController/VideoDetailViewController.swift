//
//  VideoDetailViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 23/8/24.
//

import UIKit
import SnapKit
import WebKit

class VideoDetailViewController: UIViewController {
    
    var webView: WKWebView!
    var videoUrl: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        
        if let videoURL = URL(string: videoUrl) {
            let request = URLRequest(url: videoURL)
            webView.load(request)
        }
    }
    
}
