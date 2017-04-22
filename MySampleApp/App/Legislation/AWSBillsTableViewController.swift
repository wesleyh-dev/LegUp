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
    
    override func viewWillAppear(_ animated: Bool) {
        
        if billArray.count == 0 {
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            let scanExpression = AWSDynamoDBScanExpression()
            dynamoDBObjectMapper.scan(Legislation.self, expression: scanExpression).continueOnSuccessWith { (task:AWSTask!) -> Any? in
                if let error = task.error as? NSError {
                    print("Scan request failed. Error: \(error)")
                } else if let paginatedOutput = task.result {
                    for bill in paginatedOutput.items as! [Legislation] {
                        self.billArray.append(bill)
                        self.tableView.reloadData()
                    }
                }
                return nil
            }
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AWSBillTableViewCell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! AWSBillTableViewCell
        cell.billLabel.text = billArray[indexPath.row].DisplayNum
        cell.title.text = billArray[indexPath.row].Title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "BillInfoSegue", sender: billArray[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AWSBillInfoViewController
        vc.bill = sender as! Legislation
        
    }


}
