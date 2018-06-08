//
//  StudentInformation.swift
//  On the map
//
//  Created by Sai Leung on 6/8/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.objectId = dictionary["objectId"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? "[No First Name]"
        self.lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? "[No Media URL]"
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.createdAt = dictionary["createdAt"] as? String ?? nil
        self.updatedAt = dictionary["updatedAt"] as? String ?? nil
    }
}
