//
//  Rep.swift
//  MySampleApp
//
//  Created by Joseph Barbati on 4/11/17.
//
//

import Foundation

class Rep
{
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var party: String = ""
    var state: String = ""
    var district: Int = 0
    var description: String = ""
    var phone: String = ""
    var fax: String = ""
    var contactFormURL: String = ""
    var twitterID: String = ""
    
    init(id: Int, firstName: String, lastName: String, party: String,
         state: String, district: Int,description: String, phone: String,
         fax: String, contactFormURL: String, twitterID: String)
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.party = party
        self.state = state
        self.district = district
        self.description = description
        self.phone = phone
        self.fax = fax
        self.contactFormURL = contactFormURL
        self.twitterID = twitterID
    }
    
    init() {} // Blank Constructor
}
