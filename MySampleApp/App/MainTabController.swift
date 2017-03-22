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

    var demoFeatures: [DemoFeature] = []
    var signInObserver: AnyObject!
    var signOutObserver: AnyObject!
    var willEnterForegroundObserver: AnyObject!
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        willEnterForegroundObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.current) { _ in
            //            self.updateTheme()
        }
        
        presentSignInViewController()
        
        var demoFeature = DemoFeature.init(
            name: NSLocalizedString("User Sign-in",
                                    comment: "Label for demo menu option."),
            detail: NSLocalizedString("Enable user login with popular 3rd party providers.",
                                      comment: "Description for demo menu option."),
            icon: "UserIdentityIcon", storyboard: "UserIdentity")
        
        demoFeatures.append(demoFeature)
        let storyboard = UIStoryboard(name: demoFeature.storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: demoFeature.storyboard)
        
        demoFeature = DemoFeature.init(
            name: NSLocalizedString("NoSQL",
                                    comment: "Label for demo menu option."),
            detail: NSLocalizedString("Store data in the cloud.",
                                      comment: "Description for demo menu option."),
            icon: "NoSQLIcon", storyboard: "NoSQLDatabase")
        
        demoFeatures.append(demoFeature)
        let storyboard1 = UIStoryboard(name: demoFeature.storyboard, bundle: nil)
        let viewController1 = storyboard1.instantiateViewController(withIdentifier: demoFeature.storyboard)
        
        viewControllers = [viewController, viewController1]
        selectedViewController = viewController
        
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        selectedViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        selectedViewController?.loadView()
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
