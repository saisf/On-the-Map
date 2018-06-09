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
}
