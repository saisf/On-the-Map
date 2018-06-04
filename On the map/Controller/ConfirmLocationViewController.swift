//
//  ConfirmLocationViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/31/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finish: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        finish.clipsToBounds = true
        finish.layer.cornerRadius = 10

        guard let coordinate = Student.newLocation else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView?.addAnnotation(annotation)
        
        // Set region for mapView so it automatically zoom in when loaded
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        // Reverse geocode using CLLocation to obtain detail name of entered location to be populated in annotation callout
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            guard let placemarks = placemarks else {
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0]
                guard let city = pm.locality, let state = pm.administrativeArea, let country = pm.country else {
                    return
                }
                annotation.title = "\(city), \(state), \(country)"
                Student.studentCity = city
                Student.studentState = state
            } else {
                print("Problem with the data received from geocoder")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView?.canShowCallout = true
        return pinView
    }
    @IBAction func finishButton(_ sender: UIButton) {
        if Student.exist {
            Student.Constant.updateExistingLocation(viewController: self)
        } else {
            Student.Constant.addNewLocation(viewController: self)
        }
    }
}
