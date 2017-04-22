//
//  Rep.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/11/17.
//
//

import Foundation
import AWSDynamoDB

class DBRep : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    var userId: String?
    var Desc: String?
    var District: String?
    var Fax: String?
    var First: String?
    var Last: String?
    var Party: String?
    var Phone: String?
    var State: String?
    var ContactURL: String?
    var Twitter: String?
    var Office: String?
    
    
    
    class func dynamoDBTableName() -> String {
        
        return "codenamelegup-mobilehub-417813871-Representatives"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "userId"
    }
    
}
