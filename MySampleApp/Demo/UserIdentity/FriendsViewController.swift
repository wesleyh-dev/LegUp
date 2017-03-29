//
//  FriendsViewController.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 3/28/17.
//
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func goBack(sender: UIButton)
    {
        performSegue(withIdentifier: "friendsToSettings", sender: self)
    }
    
    var friendsArray: [String] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = friendsArray[indexPath.row]
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
