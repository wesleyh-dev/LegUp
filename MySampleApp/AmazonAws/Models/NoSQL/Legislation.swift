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
    
    var _userID : String?
    var _billType : String?
    var _congress : String?
    var _dateIntroduced : String?
    var _displayNum : String?
    var _title : String?
    var _chamber : String?
    var _curStatus : String?
    var _curStatDate : String?
    var _curStatDesc : String?
    
    class func dynamoDBTableName() -> String {
        
        return "codenamelegup-mobilehub-417813871-Legislation"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_userId" : "userId",
            "_billType" : "BillType",
            "_congress" : "Congress",
            "_dateIntroduced" : "DateIntroduced",
            "_displayNum" : "DisplayNum",
            "_title" : "Title",
            "_chamber" : "curChamber",
            "_curStatus" : "curStatus",
            "_curStatDate" : "curStatusDate",
            "_curStatDesc" : "curStatusDesc"
        ]
    }
}
