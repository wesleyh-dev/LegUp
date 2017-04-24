//
//  AWSBillsTableViewController.swift
//  MySampleApp
//
//  Created by Wes Harmon on 4/19/17.
//
//

import UIKit
import AWSDynamoDB

class AWSBillsTableViewController: UITableViewController {

    var billArray: [Legislation] = []
    var filteredBill: [Legislation] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if billArray.count == 0 {
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            let scanExpression = AWSDynamoDBScanExpression()
            dynamoDBObjectMapper.scan(Legislation.self, expression: scanExpression).continueOnSuccessWith { (task:AWSTask!) -> Any? in
                if let error = task.error as? NSError {
                    print("Scan request failed. Error: \(error)")
                } else if let paginatedOutput = task.result {
                    for bill in paginatedOutput.items as! [Legislation] {
                        self.billArray.append(bill)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return nil
            }
        }
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "senate", "house"]
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.backgroundColor = UIColor.gray
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if searchController.searchBar.isHidden {
            searchController.searchBar.isHidden = false
        }
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        do {
            filteredBill = try billArray.filter({( bill : Legislation) -> Bool in
                var bool = true
                
                let categoryMatch = (scope == "All") || (bill.curChamber!.contains(scope))
                let contains = bill.Title?.lowercased().contains(searchText.lowercased())
                if let contains = contains {
                    bool = contains
                }
                
                return try categoryMatch && bool
            })
        }
        catch {
            
        }
       tableView.reloadData()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBill.count
        }
        return  billArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AWSBillTableViewCell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! AWSBillTableViewCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        cell.layer.shadowOpacity = 15.0
        cell.layer.shadowRadius = 10
        cell.clipsToBounds = true
        cell.billLabel.text = billArray[indexPath.section].DisplayNum
        cell.title.text = billArray[indexPath.section].Title
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "BillInfoSegue", sender: billArray[indexPath.section])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AWSBillInfoViewController
        vc.bill = sender as! Legislation
        
    }


}

extension AWSBillsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension AWSBillsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

