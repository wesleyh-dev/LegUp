//
//  AWebViewController.swift
//  MySampleApp
//
//  Created by Wesley Harmon on 4/24/17.
//
//

import UIKit

class AWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://actionnetwork.org");
        let request = URLRequest(url: url!);
        webView.loadRequest(request);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
