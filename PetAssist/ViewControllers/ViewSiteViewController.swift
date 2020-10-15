//
//  ViewSiteViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-03-27.
//  Copyright © 2020 Taranpreet Singh . All rights reserved.
//

import UIKit
import WebKit

class ViewSiteViewController: UIViewController, WKNavigationDelegate {
    
    //Connected to webview
    @IBOutlet var webView : WKWebView!
    
    //Activity indicator view in web view
    @IBOutlet var activity : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let urlAddress = URL(string: mainDelegate.selectedURL)
        let url = URLRequest(url: urlAddress!)
        webView.load(url as URLRequest)
        webView.navigationDelegate = self
    }
    
    //Web page loading has started
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        activity.startAnimating()
        activity.isHidden = false
    }
    
    //Web page loading has finished
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
        activity.isHidden = true
    }

    
}
