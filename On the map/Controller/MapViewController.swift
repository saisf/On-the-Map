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
        Student.Constant.getStudentLocations(mapView: mapView)
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
            Student.Constant.openSafari(url: url)
        } else {
            let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        Student.Constant.getStudentLocations(mapView: mapView)
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        self.present(loginViewController, animated: true, completion: nil)
        Student.Constant.deleteSession()
    }
    
    @IBAction func addLocationButton(_ sender: UIBarButtonItem) {
        Student.Constant.verifyUserLocationAlreadyExist(viewController: self, segueIdentifier: "addLocation")
    }
}
