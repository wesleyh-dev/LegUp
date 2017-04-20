//
//  MainTabController.swift
//  MySampleApp
//
//  Created by Wes Harmon on 3/21/17.
//
//

import UIKit
import AWSMobileHubHelper
import Foundation

class MainTabController: UITabBarController {

    let button = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        let myrepssb = UIStoryboard(name: "MyReps", bundle: nil)
        let myrepsvc = myrepssb.instantiateViewController(withIdentifier: "MyReps")
        let repsnav = UINavigationController()
        repsnav.addChildViewController(myrepsvc)
        myrepsvc.navigationItem.title = "My Representatives"
        repsnav.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let legsb = UIStoryboard(name: "AWSBills", bundle: nil)
        let legvc = legsb.instantiateViewController(withIdentifier: "table")
        let legnav = UINavigationController()
        legnav.addChildViewController(legvc)
        legvc.navigationItem.title = "Legislation"
        legnav.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let mesb = UIStoryboard(name: "UserIdentity", bundle: nil)
        let mevc = mesb.instantiateViewController(withIdentifier: "UserIdentity")
        let menav = UINavigationController()
        menav.addChildViewController(mevc)
        menav.navigationItem.title = "Me"
        menav.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.viewControllers = [legnav, repsnav, menav]
//        setupMiddleButton()
        
        if !AWSIdentityManager.default().isLoggedIn {
            self.selectedViewController = menav
        } else {
            self.selectedViewController = repsnav
        }
        
        repsnav.tabBarItem.title = "My Reps"
        repsnav.tabBarItem.image = UIImage(named: "UserIconSmall")
        
        menav.tabBarItem.title = "Profile"
        menav.tabBarItem.image = UIImage(named: "UserProfileDataSmall")
        
        legnav.tabBarItem.title = "Bills"
        legnav.tabBarItem.image = UIImage(named: "EngageSmall")
       
    }
    
    
    
//    func setupMiddleButton() {
//        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
//        
//        var menuButtonFrame = menuButton.frame
//        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
//        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
//        menuButton.frame = menuButtonFrame
//        
//        menuButton.backgroundColor = UIColor.red
//        menuButton.layer.cornerRadius = menuButtonFrame.height/2
//        view.addSubview(menuButton)
//
//        
//        menuButton.setImage(UIImage(named: "logo"), for: .normal)
//        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
//        view.addSubview(menuButton)
//        
//        
//        view.layoutIfNeeded()
//    }
//    
//    @objc private func menuButtonAction(sender: UIButton){
//        let storyboard = UIStoryboard(name: "Legislation", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "Legislation")
//        self.present(viewController, animated: true, completion: nil)
//    }
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)

        
        menuButton.setImage(UIImage(named: "logo"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        view.addSubview(menuButton)
        
        
        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton){
            let storyboard = UIStoryboard(name: "Legislation", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Legislation")
            self.present(viewController, animated: true, completion: nil)
    }
    
}
