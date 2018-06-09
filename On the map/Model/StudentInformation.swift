//
//  StudentInformation.swift
//  On the map
//
//  Created by Sai Leung on 6/8/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation

struct Results: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
//    init(dictionary: [String: AnyObject]) {
//        self.objectId = dictionary["objectId"] as? String
//        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
//        self.firstName = dictionary["firstName"] as? String ?? "[No First Name]"
//        self.lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
//        self.mapString = dictionary["mapString"] as? String ?? ""
//        self.mediaURL = dictionary["mediaURL"] as? String ?? "[No Media URL]"
//        self.latitude = dictionary["latitude"] as? Double ?? 0.0
//        self.longitude = dictionary["longitude"] as? Double ?? 0.0
//        self.createdAt = (dictionary["createdAt"] as? String ?? nil)!
//        self.updatedAt = (dictionary["updatedAt"] as? String ?? nil)!
//    }
}
