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
    dynamic var phone: Int = 1231231234
    dynamic var token: String = ""
    
}