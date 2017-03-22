//
//  UserIdentityViewController.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.12
//

import Foundation
import UIKit
import AWSMobileHubHelper

class UserIdentityViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    var signInObserver: AnyObject!
    var signOutObserver: AnyObject!
    var willEnterForegroundObserver: AnyObject!
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentSignInViewController()
        
        let identityManager = AWSIdentityManager.default()
        
        if let identityUserName = identityManager.userName {
            userName.text = identityUserName
        } else {
            userName.text = NSLocalizedString("Guest User", comment: "Placeholder text for the guest user.")
        }
        
        userID.text = identityManager.identityId
        if let imageURL = identityManager.imageURL {
            let imageData = try! Data(contentsOf: imageURL)
            if let profileImage = UIImage(data: imageData) {
                userImageView.image = profileImage
            } else {
                userImageView.image = UIImage(named: "UserIcon")
            }
        }
        
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
