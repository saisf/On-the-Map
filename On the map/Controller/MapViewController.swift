//
//  MapViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/21/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class MapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    static let activityData = ActivityData()
    var exist: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Convenience.sharedInstance.activityIndicator(loading: true)
        
        // MARK: Get student locations
        APIClient.sharedInstance.getStudentLocations { (success, results, error)  in
            if error != nil {
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.fetchingFailureAlert()
                return
            }
            guard let results = results else {
                return
            }
            if success {
                self.addAnnotation(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.mapView?.reloadInputViews()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let subtitle = view.annotation?.subtitle!, let url = URL(string: subtitle) else {
            return
        }
        if (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            popAlert()
        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        Convenience.sharedInstance.activityIndicator(loading: true)
        APIClient.sharedInstance.getStudentLocations { (success, results, error) in
            if error != nil {
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.fetchingFailureAlert()
                return
            }
            guard let results = results else {
                return
            }
            if success {
                self.addAnnotation(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
                self.mapView?.reloadInputViews()
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
//        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
//            return
//        }
//        self.present(loginViewController, animated: true, completion: nil)
        logoutAlert()
        
    }
    
    @IBAction func addLocationButton(_ sender: UIBarButtonItem) {
        Convenience.sharedInstance.activityIndicator(loading: true)
        APIClient.sharedInstance.verifyUserLocationAlreadyExist { (results, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
                return
            }
            guard let results = results else {
                return
            }
            self.verifyPostedLocation(results: results)
            Convenience.sharedInstance.activityIndicator(loading: false)
            if Student.exist {
                self.studentAlreadyExistAlert()
            } else {
                self.performSegue(withIdentifier: "addLocation", sender: nil)
            }
        }
    }
    
    // MARK: Verify if student has previously posted any location
    func verifyPostedLocation(results: [StudentInformation]) {
        for student in results {
            guard let uniqueKey = student.uniqueKey else {
                return
            }
            guard let studentFirstName = student.firstName else {
                return
            }
            guard let studentLastName = student.lastName else {
                return
            }
            guard let objectId = student.objectId else {
                return
            }
            if uniqueKey == Student.uniqueKey {
                Student.exist = true
                Student.firstName = studentFirstName
                Student.lastName = studentLastName
                Student.objectId = objectId
            }
        }
    }
    
    // MARK: Add annotations to map
    func addAnnotation(results: [StudentInformation]) {
        UserManager.sharedInstance.locations.removeAll()
        for result in results {
            var first = ""
            var last = ""
            var lat = 0.0
            var long = 0.0
            var medURL = ""
            var create = ""
            var mapstr = ""
            var objId = ""
            var key = ""
            var update = ""
            if let firstName = result.firstName {
                first = firstName
            }
            if let lastName = result.lastName {
                last = lastName
            }
            if let mediaURL = result.mediaURL {
                medURL = mediaURL
            }
            if let latitude = result.latitude {
                lat = latitude
            }
            if let longitude = result.longitude {
                long = longitude
            }
            if let createdAt = result.createdAt {
                create = createdAt
            }
            if let mapString = result.mapString {
                mapstr = mapString
            }
            if let objectId = result.objectId {
                objId = objectId
            }
            if let uniqueKey = result.uniqueKey {
                key = uniqueKey
            }
            if let updatedAt = result.updatedAt {
                update = updatedAt
            }
            let studentInformation = StudentInformation(createdAt: create, firstName: first, lastName: last, latitude: lat, longitude: long, mapString: mapstr, mediaURL: medURL, objectId: objId, uniqueKey: key, updatedAt: update)
            UserManager.sharedInstance.locations.append(studentInformation)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = medURL
            self.mapView?.addAnnotation(annotation)
        }
    }
    
    // MARK: Fetching data failure alert
    func fetchingFailureAlert() {
        let alert = UIAlertController(title: "Connection Failed", message: "Please Try Again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Logout confirmation alert
    func logoutAlert() {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        let alert = UIAlertController(title: nil, message: "Do you want to exit?", preferredStyle: .alert)
        let overwriteAlertAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            self.present(loginViewController, animated: true, completion: nil)
            APIClient.sharedInstance.deleteSession()
        })
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(overwriteAlertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Alert when mediaURL cannot be opened
    fileprivate func popAlert() {
        let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Alert when student has previously posted a location, option to overwrite to prompt segue
    fileprivate func studentAlreadyExistAlert() {
        let alert = UIAlertController(title: nil, message: "User \"\(Student.firstName) \(Student.lastName)\" Has Already Posted a Student Location. Would you like to Overwrite Their Location?", preferredStyle: .alert)
        let overwriteAlertAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "addLocation", sender: nil)
        })
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(overwriteAlertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
