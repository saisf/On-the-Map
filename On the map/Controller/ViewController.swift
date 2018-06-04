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
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.clipsToBounds = true
        login.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Ensure username and password are required to be entered when logout
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let user = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        // MARK: Authenticate User
        Student.Constant.authenticateStudent(username: user, password: password, viewController: self)
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
        let signupURL = URL(string: "https://auth.udacity.com/sign-up")!
        Student.Constant.openSafari(url: signupURL)
    }
}

