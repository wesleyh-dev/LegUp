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

    var sbs: [UIStoryboard] = []
    var signInObserver: AnyObject!
    var signOutObserver: AnyObject!
    var willEnterForegroundObserver: AnyObject!
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    let button = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        willEnterForegroundObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.current) { _ in
            //            self.updateTheme()
        }
        
        presentSignInViewController()
        setupMiddleButton()

        let myrepssb = UIStoryboard(name: "NoSQLDatabase", bundle: nil)
        let myrepsvc = myrepssb.instantiateViewController(withIdentifier: "NoSQLDatabase")
        let repsnav = UINavigationController()
        repsnav.addChildViewController(myrepsvc)
        repsnav.navigationItem.title = "My Representatives"
        repsnav.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let mesb = UIStoryboard(name: "UserIdentity", bundle: nil)
        let mevc = mesb.instantiateViewController(withIdentifier: "UserIdentity")
        let menav = UINavigationController()
        menav.addChildViewController(mevc)
        menav.navigationItem.title = "Me"
        menav.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.viewControllers = [repsnav, menav]
        self.selectedViewController = repsnav
        
        repsnav.tabBarItem.title = "My Reps"
        repsnav.tabBarItem.image = UIImage(named: "EngageSmall")
        
        menav.tabBarItem.title = "Profile"
        menav.tabBarItem.image = UIImage(named: "UserProfileDataSmall")
       

        signInObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignIn, object: AWSIdentityManager.default(), queue: OperationQueue.main, using: {[weak self] (note: Notification) -> Void in
            guard let strongSelf = self else { return }
            print("Sign In Observer observed sign in.")
            strongSelf.setupRightBarButtonItem()
            // You need to call `updateTheme` here in case the sign-in happens after `- viewWillAppear:` is called.
            //                        strongSelf.updateTheme()
        })
        
        signOutObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignOut, object: AWSIdentityManager.default(), queue: OperationQueue.main, using: {[weak self](note: Notification) -> Void in
            guard let strongSelf = self else { return }
            print("Sign Out Observer observed sign out.")
            strongSelf.setupRightBarButtonItem()
            //                        strongSelf.updateTheme()
        })
        
        setupRightBarButtonItem()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(signInObserver)
        NotificationCenter.default.removeObserver(signOutObserver)
        NotificationCenter.default.removeObserver(willEnterForegroundObserver)
    }
    
    
    
    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = loginButton
        navigationItem.rightBarButtonItem!.target = self
        
        if (AWSIdentityManager.default().isLoggedIn) {
            navigationItem.rightBarButtonItem!.title = NSLocalizedString("Sign-Out", comment: "Label for the logout button.")
            navigationItem.rightBarButtonItem!.action = #selector(MainViewController.handleLogout)
        }
    }
    
    func presentSignInViewController() {
        if !AWSIdentityManager.default().isLoggedIn {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
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
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
            self.present(viewController, animated: true, completion: nil)
        
    
    }
    
    func handleLogout() {
        if (AWSIdentityManager.default().isLoggedIn) {
            //            ColorThemeSettings.sharedInstance.wipe()
            AWSIdentityManager.default().logout(completionHandler: {(result: Any?, error: Error?) in
                self.navigationController!.popToRootViewController(animated: false)
                self.setupRightBarButtonItem()
                self.presentSignInViewController()
            })
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            assert(false)
        }
    }
    
}
