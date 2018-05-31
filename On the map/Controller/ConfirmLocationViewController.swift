//
//  ConfirmLocationViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/31/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
//        guard let coordinate = Student.newLocation else {
//            return
//        }
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
////        annotation.title = "\(first) \(last)"
////
////        annotation.subtitle = medURL
//
//        mapView?.addAnnotation(annotation)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        guard let coordinate = Student.newLocation else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
                annotation.title = "Hi"
        //
        //        annotation.subtitle = medURL
        print("Location successful")
        mapView?.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
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
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let pinToZoomOn = view.annotation
//
//        let span = MKCoordinateSpanMake(0.5, 0.5)
//
//        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
//    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */

}
