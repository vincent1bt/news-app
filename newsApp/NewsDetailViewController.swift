//
//  NewsDetailViewController.swift
//  newsApp
//
//  Created by vicente rodriguez on 2/24/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webViewDisplay: UIWebView!
    var urlString = ""
    var stringTitle = ""
    var shimmeringView: FBShimmeringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: urlString)!
        webViewDisplay.loadRequest(NSURLRequest(URL: url))
        //webViewDisplay.allowsBackForwardNavigationGestures = true
        let navLabel = UILabel()
        navLabel.text = stringTitle
        navLabel.textAlignment = .Center
        navLabel.textColor = UIColor.whiteColor()
        self.shimmeringView = FBShimmeringView(frame: CGRectMake(0, 0, 200, (self.navigationController?.navigationBar.bounds.height)!))
        self.shimmeringView.contentView = navLabel
        self.navigationItem.titleView = self.shimmeringView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.shimmeringView.shimmering = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.shimmeringView.shimmering = false
    }

}
