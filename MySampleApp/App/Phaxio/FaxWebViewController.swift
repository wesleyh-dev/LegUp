//
//  FaxWebViewController.swift
//  MySampleApp
//
//  Created by Shachy Rivas on 4/19/17.
//
//

import UIKit

class FaxWebViewController: UIViewController {

    @IBOutlet weak var faxWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let fpath = Bundle.main.path(forResource: "testing", ofType: "html")
        //print(fpath)
//        faxWebView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "test", ofType: nil)!)))
//        let requesturl = URL(string: "www.google.com")
//        let request = URLRequest(url: requesturl!)
//        faxWebView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
