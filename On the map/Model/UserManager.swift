//
//  UserManager.swift
//  On the map
//
//  Created by Sai Leung on 6/8/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation

struct UserManager {
    var locations = [StudentInformation]()
    
    static var sharedInstance = UserManager()
}
