//
//  RepInfoViewController.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/11/17.
//
//

import UIKit

class RepInfoViewController: UIViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var faxLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var faxButton: UIButton!
    
    var rep: Rep = Rep()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nameLabel.text = rep.firstName + " " + rep.lastName
        descLabel.text = rep.description
        partyLabel.text = rep.party
        phoneLabel.text = "Phone - " + rep.phone
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(RepInfoViewController.tapFaxLabel))
//        if(rep.fax != "Unavailable"){
//            faxLabel.addGestureRecognizer(tap)
//        }
        
        faxLabel.text = "Fax - " + rep.fax
        
        if(rep.fax == "Unavailable"){
            faxButton.setTitle("Fax is unavailable", for: [])
            faxButton.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let phaxioVC = segue.destination as! PhaxioViewController
        phaxioVC.rep = sender as! Rep
    }
    @IBAction func callButtonAction(_ sender: Any) {
        let repNum = rep.phone
        let phoneNum = "+1\(repNum.replacingOccurrences(of: "-", with: ""))"
        print(phoneNum)
        let url = URL(string: "tel://\(phoneNum)")!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func faxButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "phaxioSegue", sender: rep)
    }
    
    
    
//    func tapFaxLabel(sender: UITapGestureRecognizer) {
//        performSegue(withIdentifier: "phaxioSegue", sender: rep)
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
