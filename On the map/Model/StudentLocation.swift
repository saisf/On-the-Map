//
//  StudentData.swift
//  On the map
//
//  Created by Sai Leung on 5/22/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation {
    
    var createdAt: String?
    var firstName: String? = "[No First Name]"
    var lastName: String? = "[No Last Name]"
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String? = "[No Media URL]"
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    static var studentLocations = [StudentLocation]()
}
