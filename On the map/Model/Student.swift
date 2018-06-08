//
//  Student.swift
//  On the map
//
//  Created by Sai Leung on 5/19/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import CoreLocation

class Student: NSObject {
    static var uniqueKey = ""
    static var firstName = ""
    static var lastName = ""
    static var newLocation: CLLocationCoordinate2D?
    static var mediaURL = ""
    static var exist = false
    static var studentCity = ""
    static var studentState = ""
    static var objectId = ""

//    // MARK: Shared Instance
//    class func sharedInstance() -> Student {
//        struct Singleton {
//            static var sharedInstance = Student()
//        }
//        return Singleton.sharedInstance
//    }
}
