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
    
    var rep: Rep = Rep()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nameLabel.text = rep.firstName + " " + rep.lastName
        descLabel.text = rep.description
        partyLabel.text = rep.party
        phoneLabel.text = "Phone - " + rep.phone
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RepInfoViewController.tapFaxLabel))
        if(rep.fax != "Unavailable"){
            faxLabel.addGestureRecognizer(tap)
        }
        
        
        faxLabel.text = "Fax - " + rep.fax
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
    
    func tapFaxLabel(sender: UITapGestureRecognizer) {
        //faxLabel.text = "Working"
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
