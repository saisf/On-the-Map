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
        Convenience.sharedInstance.activityIndicator(loading: true)

        // MARK: Get student locations
        APIClient.sharedInstance.getStudentLocations { (success, results, error)  in
            if error != nil {
                return
            }
            guard let results = results else {
                return
            }
            if success {
//                UserManager.sharedInstance.locations.removeAll()
//                UserManager.sharedInstance.locations = results
                self.loadCellData(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return StudentLocation.studentLocations.count
        return UserManager.sharedInstance.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var first = "[No First Name]"
        var last = "[No Last Name]"
        var media = "[No Media URL]"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        let studentLocation = UserManager.sharedInstance.locations[indexPath.row]
        if let firstName = studentLocation.firstName {
            first = firstName
        }
        if let lastName = studentLocation.lastName {
            last = lastName
        }
        if let mediaURL = studentLocation.mediaURL {
            media = mediaURL
        }
        cell.textLabel?.text = "\(first) \(last)"
        cell.detailTextLabel?.text = media
        
//        first = studentLocation.firstName
//        last = studentLocation.lastName
//
//        media = studentLocation.mediaURL
//        cell.textLabel?.text = "\(first) \(last)"
//        cell.detailTextLabel?.text = media

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        let studentLocation = UserManager.sharedInstance.locations[indexPath.row]
        if verifyUrl(urlString: studentLocation.mediaURL!) == true {
            let url = URL(string: studentLocation.mediaURL!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            popAlert()
        }
        
//        if verifyUrl(urlString: studentLocation.mediaURL) == true {
//            let url = URL(string: studentLocation.mediaURL)
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        } else {
//            popAlert()
//        }
        
    }
    
    // Function to verify if a url entered can be opened
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    // MARK: Add annotations to map
    func loadCellData(results: [StudentInformation]) {
        UserManager.sharedInstance.locations.removeAll()
        UserManager.sharedInstance.locations = results
//        StudentLocation.studentLocations.removeAll()
//        for student in results {
//            let studentLocation = StudentLocation()
//
//            if let firstName = student["firstName"] as? String {
//                studentLocation.firstName = firstName
//            }
//            if let lastName = student["lastName"] as? String {
//                studentLocation.lastName = lastName
//            }
//            if let latitude = student["latitude"] as? Double {
//                studentLocation.latitude = latitude
//            }
//            if let longitude = student["longitude"] as? Double {
//                studentLocation.longitude = longitude
//            }
//            if let mapString = student["mapString"] as? String {
//                studentLocation.mapString = mapString
//            }
//            if let mediaURL = student["mediaURL"] as? String {
//                studentLocation.mediaURL = mediaURL
//            }
//            if let objectId = student["objectId"] as? String {
//                studentLocation.objectId = objectId
//            }
//            if let uniqueKey = student["uniqueKey"] as? String {
//                studentLocation.uniqueKey = uniqueKey
//            }
//            if let createdAt = student["createdAt"] as? String {
//                studentLocation.createdAt = createdAt
//            }
//            if let updatedAt = student["updatedAt"] as? String {
//                studentLocation.updatedAt = updatedAt
//            }
//            StudentLocation.studentLocations.append(studentLocation)
//        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
//        Student.Constant.getStudentLocations(mapView: nil)
        Convenience.sharedInstance.activityIndicator(loading: true)
        
        // MARK: Refresh student locations
        APIClient.sharedInstance.getStudentLocations { (success, results, error)  in
            if error != nil {
                return
            }
            guard let results = results else {
                return
            }
            if success {
                self.loadCellData(results: results)
                Convenience.sharedInstance.activityIndicator(loading: false)
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        self.present(loginViewController, animated: true, completion: nil)
        APIClient.sharedInstance.deleteSession()
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
            }
        }
    }
    
    // MARK: Verify if student has previously posted any location
    func verifyPostedLocation(results: [StudentInformation]) {
//        for student in results {
//            if student["uniqueKey"] as? String == Student.uniqueKey {
//                Student.exist = true
//                guard let studentFirstName = student["firstName"] as? String else {
//                    return
//                }
//                guard let studentLastName = student["lastName"] as? String else {
//                    return
//                }
//                guard let objectId = student["objectId"] as? String else {
//                    return
//                }
//                Student.firstName = studentFirstName
//                Student.lastName = studentLastName
//                Student.objectId = objectId
//            }
//        }
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
    
    // MARK: Alert when student has previously posted a location, option to overwrite to prompt segue
    fileprivate func studentAlreadyExistAlert() {
        let alert = UIAlertController(title: nil, message: "User \"\(Student.firstName) \(Student.lastName)\" Has Already Posted a Student Location. Would you like to Overwrite Their Location?", preferredStyle: .alert)
        let overwriteAlertAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ToAddLocationFromTable", sender: nil)
        })
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(overwriteAlertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func popAlert() {
        let alert = UIAlertController(title: "Invalid Link", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
