//
//  ReportingModel.swift
//  InstagramKloneApp
//
//  Created by Christian on 22.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation

class ReportingModel {
    
    var reportingId: String?
    var fromUserUid: String?
    var type: String?
    var objectId: String?
    
    // Time
    var secondsFrom1970: Double?
    var createDate: Date?
    
    init(dictionary: [String: Any]) {
        reportingId = dictionary["id"] as? String
        fromUserUid = dictionary["fromUserUid"] as? String
        type = dictionary["type"] as? String
        objectId = dictionary["objectId"] as? String
        
        // Time
        secondsFrom1970 = dictionary["time"] as? Double
        if let _secondFrom1970 = secondsFrom1970 {
            createDate = Date(timeIntervalSince1970: _secondFrom1970)
        }
        
    }
    
}
