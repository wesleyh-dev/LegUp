//
//  Representatives.swift
//  MySampleApp
//
//  Created by Wes Harmon on 4/19/17.
//
//

import Foundation
import UIKit
import AWSDynamoDB

class Representatives: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var userId: String?
    var First: String?
    var Last: String?
    var Party: String?
    var Phone: String?
    var State: String?
    var Desc: String?
    var District: String?
    var Fax: String?
    var Twitter: String?
    
    class func dynamoDBTableName() -> String {
        
        return "codenamelegup-mobilehub-417813871-Representatives"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "userId"
    }
    
}
