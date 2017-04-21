//
//  Legislation.swift
//  MySampleApp
//
//  Created by Wes Harmon on 4/19/17.
//
//

import Foundation
import UIKit
import AWSDynamoDB

class Legislation: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var userId: String?
    var BillType: String?
    var Congress: String?
    var DateIntroduced: String?
    var DisplayNum: String?
    var Title: String?
    var curChamber: String?
    var curStatus: String?
    var curStatusDate: String?
    var curStatusDesc: String?
    
    class func dynamoDBTableName() -> String {
        
        return "codenamelegup-mobilehub-417813871-Legislation"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "userId"
    }
    
}
