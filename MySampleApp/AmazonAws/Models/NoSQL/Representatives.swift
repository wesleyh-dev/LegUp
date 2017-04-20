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
    
    var _userId: String?
    var _first: String?
    var _last: String?
    var _party: String?
    var _phone: String?
    var _state: String?
    var _desc: String?
    var _district: String?
    var _fax: String?
    var _twitter: String?
    
    class func dynamoDBTableName() -> String {
        
        return "codenamelegup-mobilehub-417813871-Representatives"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_userId" : "userId",
            "_first" : "First",
            "_last" : "Last",
            "_party" : "Party",
            "_phone" : "Phone",
            "_state" : "State",
            "_desc" : "Desc",
            "_district" : "District",
            "_fax" : "Fax",
            "_twitter" : "Twitter"
        ]
    }
}
