//
//  TabBarHelper.swift
//  MySampleApp
//
//  Created by Wes Harmon on 3/19/17.
//
//

import Foundation

// The object that is associated with the separate tabs
class TabBarHelper: NSObject {
    
    var tabName: String
    var storyboard: String
    var icon: String
    var navName: String
    
    init(name: String, icon: String, storyboard: String, title: String) {
        self.tabName = name
        self.icon = icon
        self.storyboard = storyboard
        self.navName = title
        super.init()
    }
    
}
