//
//  LoginViewController.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = txtEmail.text else {
            print("email empty")
            return
        }
        
        guard let password = txtPassword.text else {
            print("password empty")
            return
        }
        
        var request = URLRequest(url: Constants.ApiURL.init().loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, res, err) in
            if err != nil {
                print(err!)
                return
            }
            
            print(String(data: data!, encoding: .utf8)!)
        }
        
        task.resume()
        
    }
    
}
