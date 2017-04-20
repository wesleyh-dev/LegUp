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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        objectMapper.scan(Legislation.self, expression: scanExpression).continueOnSuccessWith { (task: AWSTask) -> Any? in
            if let error = task.error as NSError? {
                print("Scan failed with error: \(error)")
            } else if let paginatedOutput = task.result {
                for bill in paginatedOutput.items as! [Legislation] {
                    self.billArray.append(bill)
                    self.tableView.reloadData()
                }
            }
            return nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (billArray.count > 0) {
            print("Number of bills retrieved: \(billArray.count)")
            return billArray.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AWSBillTableViewCell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! AWSBillTableViewCell
        
        cell.billLabel.text = billArray[indexPath.row]._displayNum
        cell.title.text = billArray[indexPath.row]._title
        
        return cell
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
