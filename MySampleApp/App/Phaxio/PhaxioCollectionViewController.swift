//
//  PhaxioCollectionViewController.swift
//  MySampleApp
//
//  Created by Shachy Rivas on 4/22/17.
//
//

import UIKit

class PhaxioCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var colView: UICollectionView!
    
    var templateArray:[String] = ["Professional Ties","Personal Ties","Personal Story","Hypothetical Scenario/Bill","Thank You Letter","Create Your Own"]
    var rep: DBRep = DBRep()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath.row) {
            case 0:
                performSegue(withIdentifier: "PhaxioSegue0", sender: rep)
                break;
            case 1:
                performSegue(withIdentifier: "PhaxioSegue1", sender: rep)
                break;
            case 2:
                performSegue(withIdentifier: "PhaxioSegue2", sender: rep)
                break;
            case 3:
                performSegue(withIdentifier: "PhaxioSegue3", sender: rep)
                break;
            case 4:
                performSegue(withIdentifier: "PhaxioSegue4", sender: rep)
                break;
            case 5:
                performSegue(withIdentifier: "PhaxioSegue5", sender: rep)
                break;
            default:
                performSegue(withIdentifier: "PhaxioSegue0", sender: rep)
                break;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhaxioColViewCell", for: indexPath) as! PhaxioCollectionViewCell
        cell.templateTypeLabel?.text = templateArray[indexPath.row]
        // Configure the cell
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch (segue.identifier!) {
            case "PhaxioSegue0":
                let faxVC = segue.destination as! PhaxioZeroViewController
                faxVC.rep = sender as! DBRep
                break;
            case "PhaxioSegue1":
                let faxVC = segue.destination as! PhaxioOneViewController
                faxVC.rep = sender as! DBRep
                break;
            case "PhaxioSegue2":
                let faxVC = segue.destination as! PhaxioTwoViewController
                faxVC.rep = sender as! DBRep
                break;
            case "PhaxioSegue3":
                let faxVC = segue.destination as! PhaxioThreeViewController
                faxVC.rep = sender as! DBRep
                break;
            case "PhaxioSegue4":
                let faxVC = segue.destination as! PhaxioFourViewController
                faxVC.rep = sender as! DBRep
                break;
            case "PhaxioSegue5":
                let faxVC = segue.destination as! PhaxioFiveViewController
                faxVC.rep = sender as! DBRep
                break;
            default:
                let faxVC = segue.destination as! PhaxioZeroViewController
                faxVC.rep = sender as! DBRep
                break;
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
