//
//  PhaxioFiveViewController.swift
//  MySampleApp
//
//  Created by Shachy Rivas on 4/22/17.
//
//

import UIKit
import AWSMobileHubHelper

class PhaxioFiveViewController: UIViewController {
    // example url needed for access base_url + "/" + path + "/?" + "api_key=" + key + "&api_secret=" + secret
    var base_url = "https://api.phaxio.com/v1"
    var path = "send/"
    var test_key = "f1104bb29b050e3e58282cdb71bcbfd3b2573ce7"
    var test_secret = "f6398a472db707f6ee2cfe299fc20584dcb78613"
    var api_key = "2f6c613cb4b1f52ce145aac6720779298f05ade2"
    var api_secret = "41b71944ad7165b95da82878e7e828cdadae2e5f"
    
    var rep: DBRep = DBRep()
    
    var header: String = ""
    var dear: String = ""
    var sig: String = ""
    
    // heading inputs
    @IBOutlet weak var billNameInput: UITextField!
    
    // body inputs
    @IBOutlet weak var faxBodyInput: UITextView!
    
    // signature inputs
    
    @IBOutlet weak var addrL1Input: UITextField!
    @IBOutlet weak var addrL2Input: UITextField!
    @IBOutlet weak var phoneNumInput: UITextField!
    @IBOutlet weak var faxNumInput: UITextField!
    
    @IBOutlet weak var reviewFaxButton: UIButton!
    @IBOutlet weak var sendFaxButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLetterHeader();
        setLetterSignature();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func billNameEditing(_ sender: Any) {
        checkAllFields()
    }
    @IBAction func addrL1Editing(_ sender: Any) {
        checkAllFields()
    }
    @IBAction func addrL2Editing(_ sender: Any) {
        checkAllFields()
    }
    @IBAction func phoneNumEditing(_ sender: Any) {
        checkAllFields()
    }
    @IBAction func faxNumEditing(_ sender: Any) {
        checkAllFields()
    }
    
    func checkAllFields(){
        if (billNameInput.text! == "") || (faxBodyInput.text! == "") || (addrL1Input.text! == "") || (addrL2Input.text! == "") || (phoneNumInput.text! == "") || (faxNumInput.text! == "") {
            sendFaxButton.isEnabled = false
        } else {
            sendFaxButton.isEnabled = true
        }
    }
    
    func setLetterHeader(){
        let date = Date();
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let longDate = dateFormatter.string(from: date)
        if (Int(rep.District!) == -1){
            header = "\(longDate)\n\nThe Honorable \(rep.First ?? "Unavailable") \(rep.Last ?? "Unavailable")\n\(rep.Office ?? "Unavailable")\nUnited States Senate\nWashington, D.C. 20510"
        } else {
            header = "\(longDate)\n\nThe Honorable \(rep.First ?? "Unavailable") \(rep.Last ?? "Unavailable")\n\(rep.Office ?? "Unavailable")\nUnited States House of Representatives\nWashington, D.C. 20515"
        }
        dear = "Dear Representative \(rep.First ?? "Unavailable") \(rep.Last ?? "Unavailable"):\n"
    }
    
    func setLetterSignature(){
        // pull username from account
        let identityManager = AWSIdentityManager.default()
        
        if let identityUserName = identityManager.userName
        {
            sig = "\nSincerely,\n\n\(identityUserName)"
        }
    }
    @IBAction func reviewFaxButtonAction(_ sender: Any) {
        let file = generateHTMLString()
        self.performSegue(withIdentifier: "toWBVFive", sender: file)
    }
    
    @IBAction func sendFaxButtonAction(_ sender: Any) {
        //get parameters i.e. (to, string_data, string_data_type) from DB here
        
        let file = generateHTMLString()
        
        let faxNum = self.rep.Fax
        let to = "+1\(faxNum?.replacingOccurrences(of: "-", with: "")  ?? "Unavailable")"
        let url = "\(self.base_url)/\(self.path)?api_key=\(self.test_key)&api_secret=\(self.test_secret)"
        let body = "to=\(to)&string_data=\(file)&string_data_type=html"
        
        let response: [String: Any] = self.send(url: url as NSString, body: body as NSString) as! [String : Any]
        let success = (response["success"] as? Bool)!
        if response["success"] != nil {
            self.sendFaxHandler(success: success, message: response["message"] as! String, url: url as NSString, body: body as NSString)
        }
    }
    
    func generateHTMLString() -> String{
        let header_h = self.header.replacingOccurrences(of: "\n", with: "<br>")
        let billName_h = self.billNameInput.text!.replacingOccurrences(of: "\n", with: "<br>")
        let dearLabel_h = self.dear.replacingOccurrences(of: "\n", with: "<br>")
        let faxBody_h = self.faxBodyInput.text!.replacingOccurrences(of: "\n", with: "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
        let sig_h = self.sig.replacingOccurrences(of: "\n", with: "<br>")
        let addrln1_h = self.addrL1Input.text!.replacingOccurrences(of: "\n", with: "<br>")
        let addrln2_h = self.addrL2Input.text!.replacingOccurrences(of: "\n", with: "<br>")
        let phoneNum_h = self.phoneNumInput.text!.replacingOccurrences(of: "\n", with: "<br>")
        let faxNum_h = self.faxNumInput.text!.replacingOccurrences(of: "\n", with: "<br>")
        
        let head = ""
        let body = "<p>\(header_h)<br><p style=\"font-weight: bold; text-align: center;\">RE: \(billName_h)</p>\(dearLabel_h)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\(faxBody_h)</p><p style=\"margin-left:65%;\">\(sig_h)<br>\(addrln1_h)<br>\(addrln2_h)<br>Phone: \(phoneNum_h)<br>Fax: \(faxNum_h)</span></p>"
        let htmlString = "<DOCTYPE! html><html><head>\(head)</head><body style=\"margin: 10px;font-size:12px;font-family=\"TimesNewRoman\">\(body)</body></html>"
        return htmlString
    }
    
    func sendFaxHandler(success: Bool, message: String, url:NSString, body:NSString) {
        if success {
            let alertController = UIAlertController(title: message, message: "Your fax is on the way!", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                //sends back to myRepsView
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        } else if !success {
            let alertController = UIAlertController(title: message, message: "There was a problem. Please retry sending.", preferredStyle: .alert)
            let ResendAction = UIAlertAction(title: "Resend", style: .default) { action in
                // ... call reset function
                var retry_res:[String: Any] = self.send(url: url as NSString, body: body as NSString) as! [String: Any]
                let retry_succ = (retry_res["success"] as? Bool)!
                if retry_res["success"] != nil {
                    self.sendFaxHandler(success: retry_succ, message: retry_res["message"] as! String, url: url as NSString, body: body as NSString)
                }
            }
            alertController.addAction(ResendAction)
            let CancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                // ... do nothing
            }
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true)
        }
    }
    
    
    func send(url:NSString, body:NSString) -> NSDictionary{
        let request = NSMutableURLRequest(url: NSURL(string: url as String)! as URL)
        request.httpBody = body.data(using: String.Encoding.utf8.rawValue)
        request.httpMethod = "POST"
        
        var response: URLResponse?
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print("Synchronous\(jsonResult)")
                    return(jsonResult)
                }
            }catch let error as NSError {
                print(error.localizedDescription)
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [:]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let letterWBV = segue.destination as! letterWebViewController
        letterWBV.htmlString = sender as! String
    }

}
