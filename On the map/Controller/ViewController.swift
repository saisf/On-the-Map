//
//  ViewController.swift
//  On the map
//
//  Created by Sai Leung on 5/18/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let user = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
//        Student.sharedInstance().taskForPOSTMethod(user: user, password: password) { (result, error) in
//            guard (error == nil) else {
//                return
//            }
//
//            print(result)
//        }
        
//         POSTing a Session to Udacity API to obtain session id
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            DispatchQueue.main.async {
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
                var parseResult: AnyObject! = nil
                
                do {
                    parseResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                } catch {
                    print("Error: \(error)")
                }
//                parseResult = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                
//                let sessionID = parseResult?["session"] as? [String: String]
                
                guard let sessionID = parseResult?["session"] as? [String: String] else {
                    let alert = UIAlertController(title: "Invalid Email or Password", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                guard let session = sessionID["id"] else {
                    return
                }
//                guard let session = sessionID!["id"] else {
//                    return
//                }
                print("\(session)")
                
                guard let account = parseResult?["account"] as? [String: AnyObject], let registered = account["registered"] as? Bool else {
                    return
                }
                print(registered)
                
                if registered {
                    print("User is registered")
                    self.performSegue(withIdentifier: "ToTabView", sender: nil)
                    self.deleteSession()
                    print("Session id has been deleted!")
                    // 1558413710Sc060bb9f76ffabfd8950a4d771450412
                } else {
                    print("Not registered")
                }
            }
            
        }

        task.resume()
//        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/11392149253")!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
//        }
//        task.resume()
//
//    }
    
    }
    
    func deleteSession() {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}

//extension UIViewController {
//    class func displaySpinner(onView: UIView) -> UIView {
//        let spinnerView = UIView.init(frame: onView.bounds)
//        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
//        ai.startAnimating()
//        ai.center = spinnerView.center
//        
//        DispatchQueue.main.async {
//            spinnerView.addSubview(ai)
//            onView.addSubview(spinnerView)
//        }
//        return spinnerView
//    }
//    
//    class func removeSpinner(spinner: UIView) {
//        DispatchQueue.main.async {
//            spinner.removeFromSuperview()
//        }
//    }
//}

