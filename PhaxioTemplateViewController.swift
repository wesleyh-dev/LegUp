//
//  PhaxioTemplateViewController.swift
//  MySampleApp
//
//  Created by Shachy Rivas on 4/19/17.
//
//

import UIKit

class PhaxioTemplateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var templateArray:[String] = ["Personal Credentials","Personal Interest w/ Counter Arguements & Proposed Sol","Personal Story w/ Bulleted Data","Hypothetical Scenario/Bill","Thank You Letter","Create your own"]
    var rep: Rep = Rep()
    
    @IBOutlet weak var templateTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        templateTableView.delegate = self
        templateTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return templateArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "templateCell",
                                                 for: indexPath) as! PhaxioTableViewCell
        cell.templateTypeLabel?.text = (templateArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "toTemplateSegue", sender: rep)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let faxVC = segue.destination as! PhaxioViewController
        faxVC.rep = sender as! Rep
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
