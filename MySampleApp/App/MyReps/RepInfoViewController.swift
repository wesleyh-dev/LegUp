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
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var faxButton: UIButton!
    
    var rep = DBRep()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nameLabel.text = (rep?.First)! + " " + (rep?.Last)!
        descLabel.text = rep?.Desc
        partyLabel.text = rep?.Party
        
        if(rep?.Fax == "NULL"){
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
        let phaxioVC = segue.destination as! PhaxioCollectionViewController
        phaxioVC.rep = sender as! DBRep
    }
    @IBAction func callButtonAction(_ sender: Any) {
        let repNum = rep?.Phone
        let phoneNum = "+1\(repNum?.replacingOccurrences(of: "-", with: "") ?? "Unavailable")"
        print(phoneNum)
        let url = URL(string: "tel://\(phoneNum)")!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func faxButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "phaxioSegue", sender: rep)
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
