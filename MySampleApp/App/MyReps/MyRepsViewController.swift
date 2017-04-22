//
//  MyRepsViewController.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/10/17.
//
//

import UIKit
import AWSDynamoDB

class MyRepsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var repsTableView: UITableView!

    var repsArray: [Rep] = []
    var repsArray2: [DBRep] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let scanExpression = AWSDynamoDBScanExpression()
        
        dynamoDBObjectMapper.scan(DBRep.self, expression: scanExpression).continueOnSuccessWith{ (task:AWSTask!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for rep in paginatedOutput.items as! [DBRep] {
                    if (rep.District == nil) {
                        rep.District = "-1";
                    }
                    self.repsArray2.append(rep)
                }
                
            }
            
            self.repsArray2.sort {
                if ($0.State! != $1.State!) {
                    return $0.State! < $1.State!
                }
                else {
                    return Int($0.District!)! < Int($1.District!)!
                }

            }
        
            DispatchQueue.main.async {
                self.repsTableView.reloadData()
            }
            
            return nil
        }
        
        print(repsArray2.count)
    
        
        // Prevents calling API everytime view appears
        if repsArray.count == 0
        {
            print("Getting Reps")
            let result = fetchReps()
            parse(d: result)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        repsTableView.delegate = self
        repsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return repsArray2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repCell",
                                                 for: indexPath) as! RepsTableViewCell
        cell.nameLabel?.text = (repsArray2[indexPath.row].First! + " " + repsArray2[indexPath.row].Last!)
        cell.descriptionLabel?.text = repsArray2[indexPath.row].Desc!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "repsInfoSegue", sender: repsArray2[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let repsVC = segue.destination as! RepInfoViewController
        repsVC.rep = sender as! DBRep
    }
    
    func fetchReps() -> NSDictionary
    {
        let url = "https://www.govtrack.us/api/v2/role?current=true&order_by=state&limit=600"
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
                var firstName: String = "Unavailable"
                var lastName: String = "Unavailable"
                var party: String = "Unavailable"
                var state: String = "Unavailable"
                var district: Int = -1
                var description: String = "Unavailable"
                var phone: String = "Unavailable"
                var fax: String = "Unavailable"
                var contactFormURL: String = "Unavailable"
                var twitterID: String = "Unavailable"
                if let entry = data[i] as? [String:Any]
                {
                    if let st = entry["state"] as! String!
                    {
                        // Skips Pres and VP
                        if st == ""
                        {
                            continue
                        }
                        else
                        {
                            state = st
                        }
                    }
                    if let rep_id = entry["id"] as! Int!
                    {
                        id = rep_id
                    }
                    if let person = entry["person"] as? [String:Any]
                    {
                        if let fn = person["firstname"] as! String!
                        {
                            firstName = fn
                        }
                        if let ln = person["lastname"] as! String!
                        {
                            lastName = ln
                        }
                        if let twitter = person["twitterid"]
                        {
                            if twitter is NSNull
                            {
                                
                            }
                            else
                            {
                                let tweet = twitter as! String
                                twitterID = tweet
                            }
                        }
                    }
                    if let p = entry["party"] as! String!
                    {
                        party = p
                    }
                    if let dist = entry["district"]
                    {
                        if dist is NSNull
                        {
                            
                        }
                        else
                        {
                            let distr = dist as! Int
                            district = distr
                        }
                    }
                    if let desc = entry["description"] as! String!
                    {
                        description = desc
                    }
                    if let ph = entry["phone"] as! String!
                    {
                        phone = ph
                    }
                    if let extra = entry["extra"] as? [String:Any]
                    {
                        if let f = extra["fax"] as! String!
                        {
                            fax = f
                        }
                        if let con = extra["contact_form"] as! String!
                        {
                            contactFormURL = con
                        }
                    }
                    let rep = Rep(id: id, firstName: firstName, lastName: lastName,
                                  party: party, state: state, district: district,
                                  description: description, phone: phone, fax: fax,
                                  contactFormURL: contactFormURL, twitterID: twitterID)
                    self.repsArray.append(rep)
                }
            }
        }
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
