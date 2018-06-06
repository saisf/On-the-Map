//
//  Convenience.swift
//  On the map
//
//  Created by Sai Leung on 6/5/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Convenience: NSObject {
    
    // MARK: Activity Loading Indicator
    func activityIndicator(loading: Bool) {
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 80, height: 80)
        NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        if loading {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
        } else {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    static let sharedInstance = Convenience()
}
