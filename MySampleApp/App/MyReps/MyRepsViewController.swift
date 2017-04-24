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
    var filteredReps: [DBRep] = []
    let searchController = UISearchController(searchResultsController: nil)
    
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
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Senator", "Representative"]
        
        
    
        repsTableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        repsTableView.delegate = self
        repsTableView.dataSource = self
        
        repsTableView.backgroundColor = UIColor.gray
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredReps.count
        }
        return repsArray2.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repCell",
                                                 for: indexPath) as! RepsTableViewCell
        let reps: DBRep
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            reps = filteredReps[indexPath.section]
        }  else {
            reps = repsArray2[indexPath.section]
        }
        
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        cell.layer.shadowOpacity = 15.0
        cell.layer.shadowRadius = 10
        cell.clipsToBounds = true
        
        cell.nameLabel?.text = (reps.First! + " " + reps.Last!)
        cell.descriptionLabel?.text = reps.Desc!
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        do {
            filteredReps = try repsArray2.filter({( rep : DBRep) -> Bool in
                var bool = true
                
                let categoryMatch = (scope == "All") || (rep.Desc!.contains(scope))
                let contains = rep.Desc?.lowercased().contains(searchText.lowercased())
                if let contains = contains {
                    bool = contains
                }
                
                return try categoryMatch && bool
            })
        }
        catch {
            
        }
        repsTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if searchController.searchBar.text != "" {
        tableView.deselectRow(at: indexPath, animated: true)
                performSegue(withIdentifier: "repsInfoSegue", sender: filteredReps[indexPath.section])
        } else {
            
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "repsInfoSegue", sender: repsArray2[indexPath.section])
        }
        
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
                var office: String = "Unavailable"
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
                        if let of = extra["office"] as! String!
                        {
                            office = of
                        }
                        if let con = extra["contact_form"] as! String!
                        {
                            contactFormURL = con
                        }
                    }
                    let rep = Rep(id: id, firstName: firstName, lastName: lastName,
                                  party: party, state: state, district: district,
                                  description: description, phone: phone, fax: fax, office: office,
                                  contactFormURL: contactFormURL, twitterID: twitterID)
                    self.repsArray.append(rep)
                }
            }
        }
    }
}

extension MyRepsViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension MyRepsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
