//
//  LegislationViewController.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/5/17.
//
//

import UIKit

class LegislationViewController: UIViewController, UITableViewDataSource
{
    @IBOutlet weak var billTableView: UITableView!
    
    var billsArray: [String] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        fetchBills()
    }
    
    func fetchBills()
    {
        print("Fetching Bills")
        billsArray.append("Bill1")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return billsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = billsArray[indexPath.row]
        return cell
    }
}
