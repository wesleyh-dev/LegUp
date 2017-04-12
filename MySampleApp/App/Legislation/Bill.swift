//
//  Bill.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/11/17.
//
//

import Foundation

class Bill
{
    var id: Int = 0
    var billType: String = ""
    var displayNum: String = ""
    var congressId: Int = 0
    var introducedDate: String = ""
    var currentChamber: String = ""
    var currentStatus: String = ""
    var currentStatusDate: String = ""
    var currentStatusDesc: String = ""
    var title: String = ""
    
    init(id: Int, billType: String, displayNum: String, congressId: Int,
         introducedDate: String, currentChamber: String, currentStatus: String,
         currentStatusDate: String, currentStatusDesc: String, title: String)
    {
        self.id = id
        self.billType = billType
        self.displayNum = displayNum
        self.congressId = congressId
        self.introducedDate = introducedDate
        self.currentChamber = currentChamber
        self.currentStatus = currentStatus
        self.currentStatusDate = currentStatusDate
        self.currentStatusDesc = currentStatusDesc
        self.title = title
    }
    
    init() {} // Blank Constructor
}
