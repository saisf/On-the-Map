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

                print("\(session)")
                
//                guard let account = parseResult?["account"] as? [String: AnyObject], let registered = account["registered"] as? Bool else {
//                    return
//                }
                guard let account = parseResult?["account"] as? [String: AnyObject], let registered = account["registered"] as? Bool, let uniqueKey = account["key"] as? String else {
                    return
                }

                print(registered)
                print(uniqueKey)
                Student.uniqueKey = uniqueKey
                print(Student.uniqueKey)
                
                if registered {
                    print("User is registered")
                    self.performSegue(withIdentifier: "ToTabView", sender: nil)
                    
                    //****************
//                    let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
//                    let session = URLSession.shared
//                    let task = session.dataTask(with: request) { data, response, error in
//                        if error != nil { // Handle error...
//                            return
//                        }
//                        let range = Range(5..<data!.count)
//                        DispatchQueue.main.async {
//                            let newData = data?.subdata(in: range) /* subset response data! */
//                            print(String(data: newData!, encoding: .utf8)!)
//                        }
//                        
//                    }
//                    task.resume()
                    //******************************
                    
                    
//                    self.deleteSession()
                    print("Session id has been deleted!")
                    // 1558413710Sc060bb9f76ffabfd8950a4d771450412
                } else {
                    print("Not registered")
                }
            }
            
        }

        task.resume()

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

