//
//  MapViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/21/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    var student = Student.sharedInstance()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        
        Student.Constant.mapPin(mapView: mapView)
//        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&&order=-updatedAt")!)
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            // Handle error...
//            if error != nil {
//                return
//            }
//            DispatchQueue.main.async {
//                print(String(data: data!, encoding: .utf8)!)
//                let parseResult = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
//
//
//                print(parseResult)
//                guard let result = parseResult["results"] as? [[String:AnyObject]] else {
//                    return
//                }
//
//                var num = 0
//                for student in result {
//                    let studentLocation = StudentLocation()
//                    var first = ""
//                    var last = ""
//                    var lat = 0.0
//                    var long = 0.0
//                    var medURL = ""
//
//                    num += 1
//                    print(num)
//
//                    if let firstName = student["firstName"] as? String {
//
//                        print("Saved successfully")
//                        studentLocation.firstName = firstName
//                        print(firstName)
//                        first = firstName
//                    }
//
//                    if let lastName = student["lastName"] as? String {
//                        studentLocation.lastName = lastName
//                        print(lastName)
//                        last = lastName
//                    }
//
//                    if let latitude = student["latitude"] as? Double {
//                        studentLocation.latitude = latitude
//                        print(latitude)
//                        lat = latitude
//                    }
//
//                    if let longitude = student["longitude"] as? Double {
//                        studentLocation.longitude = longitude
//                        print(longitude)
//                        long = longitude
//                    }
//
//                    if let mapString = student["mapString"] as? String {
//                        studentLocation.mapString = mapString
//                        print(mapString)
//                    }
//
//                    if let mediaURL = student["mediaURL"] as? String {
//                        studentLocation.mediaURL = mediaURL
//                        print(mediaURL)
//                        medURL = mediaURL
//                    }
//
//                    if let objectId = student["objectId"] as? String {
//                        studentLocation.objectId = objectId
//                        print(objectId)
//                    }
//
//                    if let uniqueKey = student["uniqueKey"] as? String {
//                        studentLocation.uniqueKey = uniqueKey
//                        print(uniqueKey)
//                    }
//
//                    if let createdAt = student["createdAt"] as? String {
//                        studentLocation.createdAt = createdAt
//                        print(createdAt)
//                    }
//
//                    if let updatedAt = student["updatedAt"] as? String {
//                        studentLocation.updatedAt = updatedAt
//                        print(updatedAt)
//                    }
//
//                    StudentLocation.studentLocations.append(studentLocation)
//
//                    print("student location saved successfully")
//                    let latt = CLLocationDegrees(lat)
//                    let longg = CLLocationDegrees(long)
//                    let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
//
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = coordinate
//                    annotation.title = "\(first) \(last)"
//                    annotation.subtitle = medURL
//
//                    self.mapView.addAnnotation(annotation)
//                    }
//            }
//        }
//        task.resume()
    }
    
    func getLocation(result: [[String:AnyObject]], completionaHandler: @escaping (_ studentLocation: [StudentLocation]) -> Void) {
        for student in result {
            let studentLocation = StudentLocation()
            
            if let firstName = student["firstName"] as? String {
//                self.studentFirstName?.append(firstName)
                
                print("Saved successfully")
                studentLocation.firstName = firstName
                print(firstName)
                
            }
            if let lastName = student["lastName"] as? String {
                studentLocation.lastName = lastName
                print(lastName)
            }
            
            if let latitude = student["latitude"] as? Double {
                studentLocation.latitude = latitude
                print(latitude)
            }
            
            if let longitude = student["longitude"] as? Double {
                studentLocation.longitude = longitude
                print(longitude)
            }
            
            if let mapString = student["mapString"] as? String {
                studentLocation.mapString = mapString
                print(mapString)
            }
            
            if let mediaURL = student["mediaURL"] as? String {
                studentLocation.mediaURL = mediaURL
                print(mediaURL)
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
        }
        
        completionaHandler(StudentLocation.studentLocations)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
//            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        Student.Constant.mapPin(mapView: mapView)
        print("Refresh successfully")
        mapView.reloadInputViews()
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let subtitle = view.annotation?.subtitle! else {
//            return
//        }
//        let url = URL(string: subtitle)
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//    }

}
