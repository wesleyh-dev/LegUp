//
//  LegislationViewController.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/5/17.
//
//

import UIKit

class LegislationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var billTableView: UITableView!
    
    var billsArray: [Bill] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Prevents calling API everytime this view shows up
        if billsArray.count == 0
        {
            print("Getting Bills!")
            let result = fetchBills()
            parse(d: result)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.tintColor = UIColor.lightText
        
        billTableView.delegate = self
        billTableView.dataSource = self
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return billsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell",
                                                 for: indexPath) as! BillTableViewCell
        cell.displayLabel?.text = billsArray[indexPath.row].displayNum
        cell.descriptionLabel?.text = billsArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "billInfoSegue", sender: billsArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let billVC = segue.destination as! BillInfoViewController
        billVC.bill = sender as! Bill
    }
    
    func fetchBills() -> NSDictionary
    {
        var url = "https://www.govtrack.us/api/v2/bill?order_by=-introduced_date"
        url += "&congress=115&limit=300&offset=0"
        let request = NSMutableURLRequest(url: NSURL(string: url as String)! as URL)
        request.httpMethod = "GET"
        
        var response: URLResponse?
        
        do
        {
            let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            
            do
            {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                {
                    return(jsonResult)
                }
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
                
            }
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        return [:]
    }
    
    func parse(d: NSDictionary)
    {
        if let data = d["objects"] as! NSArray!
        {
            for i in 0...data.count - 1
            {
                var id: Int = -1
                var billType: String = "Unknown"
                var displayNum: String = "Unavailable"
                var congressId: Int = -1
                var introducedDate: String = "Unknown"
                var currentChamber: String = "Unknown"
                var currentStatus: String = "Unknown"
                var currentStatusDate: String = "Unknown"
                var currentStatusDesc: String = "Unknown"
                var title: String = "Unavailable"
                
                if let entry = data[i] as? [String:Any]
                {
                    if let bill_id = entry["id"] as! Int!
                    {
                        id = bill_id
                    }
                    if let bt = entry["bill_type"] as! String!
                    {
                        billType = bt
                    }
                    if let dn = entry["display_number"] as! String!
                    {
                        displayNum = dn
                    }
                    if let con = entry["congress"] as! Int!
                    {
                        congressId = con
                    }
                    if let introDate = entry["introduced_date"] as! String!
                    {
                        introducedDate = introDate
                    }
                    if let currCh = entry["current_chamber"] as! String!
                    {
                        currentChamber = currCh
                    }
                    if let currStat = entry["current_status"] as! String!
                    {
                        currentStatus = currStat
                    }
                    if let currStatDate = entry["current_status_date"] as! String!
                    {
                        currentStatusDate = currStatDate
                    }
                    if let majorActions = entry["major_actions"] as? NSArray
                    {
                        if let recent = majorActions[majorActions.count - 1] as? NSArray
                        {
                            if let desc = recent[2] as? String
                            {
                                currentStatusDesc = desc
                            }
                        }
                    }
                    if let t = entry["title_without_number"] as! String!
                    {
                        title = t
                    }
                    let bill = Bill(id: id, billType: billType,
                                    displayNum: displayNum,
                                    congressId: congressId,
                                    introducedDate: introducedDate,
                                    currentChamber: currentChamber,
                                    currentStatus: currentStatus,
                                    currentStatusDate: currentStatusDate,
                                    currentStatusDesc: currentStatusDesc,
                                    title: title)
                    self.billsArray.append(bill)
                }
            }
        }
    }
}
