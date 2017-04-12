//
//  BillInfoViewController.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/11/17.
//
//

import UIKit

class BillInfoViewController: UIViewController
{
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var introDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentChamberLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    var bill = Bill()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayLabel.text = bill.displayNum
        introDateLabel.text = "Introduced " + bill.introducedDate
        descriptionLabel.text = bill.title
        if bill.currentChamber.compare("house").rawValue == 0
        {
            currentChamberLabel.text = "Currently in the House of Representatives"
        }
        else
        {
            currentChamberLabel.text = "Currently in the Senate"
        }
        currentStatusLabel.text = "As of " + bill.currentStatusDate + ", " + bill.currentStatusDesc
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
