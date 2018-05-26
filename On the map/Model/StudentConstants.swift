//
//  StudentConstants.swift
//  On the map
//
//  Created by Sai Leung on 5/19/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import MapKit
import NVActivityIndicatorView

extension Student {
    struct Constants {
        // MARK: URL
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Constant {
        
    static func mapPin(mapView: MKMapView?) {
        
        // MARK: Activity Indicator
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 80, height: 80)
        NVActivityIndicatorView.DEFAULT_TYPE = .orbit
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            // Handle error...
//            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            if error != nil {
                return
            }
            DispatchQueue.main.async {
                print(String(data: data!, encoding: .utf8)!)


                let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject


                print(parseResult)
                
                guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                    return
                }
        
                
                var num = 0
                for student in result {
                    let studentLocation = StudentLocation()
                    var first = ""
                    var last = ""
                    var lat = 0.0
                    var long = 0.0
                    var medURL = ""
                    
                    num += 1
                    print(num)
                    
                    if let firstName = student["firstName"] as? String {
                        
                        print("Saved successfully")
                        studentLocation.firstName = firstName
                        print(firstName)
                        first = firstName
                    }
                    
                    if let lastName = student["lastName"] as? String {
                        studentLocation.lastName = lastName
                        print(lastName)
                        last = lastName
                    }
                    
                    if let latitude = student["latitude"] as? Double {
                        studentLocation.latitude = latitude
                        print(latitude)
                        lat = latitude
                    }
                    
                    if let longitude = student["longitude"] as? Double {
                        studentLocation.longitude = longitude
                        print(longitude)
                        long = longitude
                    }
                    
                    if let mapString = student["mapString"] as? String {
                        studentLocation.mapString = mapString
                        print(mapString)
                    }
                    
                    if let mediaURL = student["mediaURL"] as? String {
                        studentLocation.mediaURL = mediaURL
                        print(mediaURL)
                        medURL = mediaURL
                    }
                    
                    if let objectId = student["objectId"] as? String {
                        studentLocation.objectId = objectId
                        print(objectId)
                    }
                    
                    if let uniqueKey = student["uniqueKey"] as? String {
                        studentLocation.uniqueKey = uniqueKey
                        print(uniqueKey)
                    }
                    
                    if let createdAt = student["createdAt"] as? String {
                        studentLocation.createdAt = createdAt
                        print(createdAt)
                    }
                    
                    if let updatedAt = student["updatedAt"] as? String {
                        studentLocation.updatedAt = updatedAt
                        print(updatedAt)
                    }
                    
                    StudentLocation.studentLocations.append(studentLocation)
                    
                    print("student location saved successfully")
                    let latt = CLLocationDegrees(lat)
                    let longg = CLLocationDegrees(long)
                    let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    
                    annotation.subtitle = medURL
                    
                    mapView?.addAnnotation(annotation)
                }
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        }
        task.resume()
    }
    }
}
