//
//  MapTableViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/22/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MapTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
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
                
                StudentLocation.studentLocations.removeAll()
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
                    //                    let latt = CLLocationDegrees(lat)
                    //                    let longg = CLLocationDegrees(long)
                    //                    let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                    //
                    //                    let annotation = MKPointAnnotation()
                    //                    annotation.coordinate = coordinate
                    //                    annotation.title = "\(first) \(last)"
                    //
                    //                    annotation.subtitle = medURL
                    //
                    //                    mapView?.addAnnotation(annotation)
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StudentLocation.studentLocations.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var first = "[No First Name]"
        var last = "[No Last Name]"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        if let firstName = studentLocation.firstName {
            first = firstName
        }
        if let lastName = studentLocation.lastName {
            last = lastName
        }
        cell.textLabel?.text = "\(first) \(last)"
        cell.detailTextLabel?.text = studentLocation.mediaURL

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = StudentLocation.studentLocations[indexPath.row]

        if verifyUrl(urlString: studentLocation.mediaURL!) == true {
            let url = URL(string: studentLocation.mediaURL!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
//        Student.Constant.mapPin(mapView: nil)
//        self.tableView.reloadData()
//        refresh {
//            self.tableView.reloadData()
//        }
        
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
                
                StudentLocation.studentLocations.removeAll()
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
//                    let latt = CLLocationDegrees(lat)
//                    let longg = CLLocationDegrees(long)
//                    let coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
//
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = coordinate
//                    annotation.title = "\(first) \(last)"
//
//                    annotation.subtitle = medURL
//
//                    mapView?.addAnnotation(annotation)
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
        print("Refresh successfully")
    }
    
    func refresh(completion: @escaping()->Void) {
//        StudentLocation.studentLocations.removeAll()
        Student.Constant.mapPin(mapView: nil)
        completion()
    }
    

    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocationButton(_ sender: UIBarButtonItem) {
        
        var exist: Bool = false
        
        // REQUEST
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=500&&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            // Handle error...
            if error != nil {
                return
            }
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(MapViewController.activityData)
            DispatchQueue.main.async {
                print(String(data: data!, encoding: .utf8)!)
                
                
                let parseResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
        
                print(parseResult)
                
                guard let result = parseResult!["results"] as? [[String:AnyObject]] else {
                    return
                }
                var num = 0
                for student in result {
                    num += 1
                    print(num)
                    if student["uniqueKey"] as? String == Student.uniqueKey {
                        exist = true
                        Student.exist = true
                        print(student["uniqueKey"] as? String)
                        print("I got it")
                        guard let studentFirstName = student["firstName"] as? String else {
                            return
                        }
                        guard let studentLastName = student["lastName"] as? String else {
                            return
                        }
                        Student.firstName = studentFirstName
                        Student.lastName = studentLastName
                    }
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                if exist {
                    let alert = UIAlertController(title: nil, message: "User \"\(Student.firstName) \(Student.lastName)\" Has Already Posted a Student Location. Would you like to Overwrite Their Location?", preferredStyle: .alert)
                    let overwriteAlertAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "ToAddLocationFromTable", sender: nil)
                    })
                    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(overwriteAlertAction)
                    alert.addAction(cancelAlertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
