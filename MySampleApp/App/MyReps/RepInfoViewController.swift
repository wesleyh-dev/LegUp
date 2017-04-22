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
    
    var rep = DBRep()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nameLabel.text = (rep?.First)! + " " + (rep?.Last)!
        descLabel.text = rep?.Desc!
        partyLabel.text = rep?.Party!
        phoneLabel.text = "Phone - " + (rep?.Phone!)!
        faxLabel.text = "Fax - " + (rep?.Fax!)!
    }

    override func didReceiveMemoryWarning()
    {
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
