//
//  Model.swift
//  Pleeb
//
//  Created by Brent Kirkland on 2/1/15.
//  Copyright (c) 2015 Pleeb, Inc. All rights reserved.
//

import Realm

class Vote: RLMObject {
    
    dynamic var bump: String = ""
}

class SizeofPoints: RLMObject {
    
    dynamic var length: String = ""
}

class User: RLMObject {
    
    //dynamic var email: String = ""
    dynamic var phone: String = "(949) 292-6284"
    dynamic var token: String = ""
    
}

class Event: RLMObject {
    
    dynamic var address: String! = "Default"
    dynamic var tags = RLMArray(objectClassName: Tag.className())
}

class Tag: RLMObject {
    
    dynamic var name: String!
    dynamic var weight: Int = 0
    
}