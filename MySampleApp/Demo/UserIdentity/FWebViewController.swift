//
//  FWebViewController.swift
//  MySampleApp
//
//  Created by Wesley Harmon on 4/24/17.
//
//

import UIKit

class FWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeXozCQePo3QuhcjNPHSD6WXDL0qf380hI6PNHmkKQOUV0cyw/viewform");
        let request = URLRequest(url: url!);
        webView.loadRequest(request);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
