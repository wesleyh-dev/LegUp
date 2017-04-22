//
//  AWSBillInfoViewController.swift
//  MySampleApp
//
//  Created by Wes Harmon on 4/19/17.
//
//

import UIKit

class AWSBillInfoViewController: UIViewController {
    
    @IBOutlet weak var displayNum: UILabel!
    @IBOutlet weak var billDesc: UILabel!
    @IBOutlet weak var introduced: UILabel!
    @IBOutlet weak var statusDesc: UILabel!
    
    var bill = Legislation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayNum.text = bill?.DisplayNum
        billDesc.text = bill?.Title
        introduced.text = "Introduced " + (bill?.DateIntroduced)!
        statusDesc.text = bill?.curStatusDesc
        
        billDesc.lineBreakMode = .byWordWrapping
        billDesc.numberOfLines = 0
        
        statusDesc.lineBreakMode = .byWordWrapping
        statusDesc.numberOfLines = 0
        
        
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


