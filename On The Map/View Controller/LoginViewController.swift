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
    @IBOutlet weak var btnLogin: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtPassword.delegate = self
        btnLogin.layer.cornerRadius = 4
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtEmail.text = ""
        txtPassword.text = ""
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        btnLogin.isEnabled = false
        btnLogin.titleLabel?.text = "Logging in..."
        guard let email = txtEmail.text else {
            print("email empty")
            return
        }
        
        guard let password = txtPassword.text else {
            print("password empty")
            return
        }
        
        UserService().userLogin(email: email,
                                password: password, success: { (res) in
                                    if let account = res["account"] as? [String: AnyObject] {
                                        self.defaults.set(account["key"]!, forKey: "userKey")
                                        
                                        DispatchQueue.main.sync {
                                            self.performSegue(withIdentifier: "LoginToMainSegue", sender: nil)
                                        }
                                    } else if (res["error"] as? String) != nil {
                                        let alert = UIAlertController(title: "Uh oh!",
                                                                      message: "It appears that the credentials you entered are invalid. Please verify your credentials and try again.",
                                                                      preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                        
                                        DispatchQueue.main.async {
                                            self.present(alert, animated: true, completion: nil)
                                            self.txtEmail.becomeFirstResponder()
                                            self.btnLogin.isEnabled = true
                                            self.btnLogin.titleLabel?.text = "LOG IN"
                                            self.txtEmail.text = ""
                                            self.txtPassword.text = ""
                                        }
                                    }
        }) { (err) in
            print(err.localizedDescription)
            self.btnLogin.isEnabled = true
            self.btnLogin.titleLabel?.text = "LOG IN"
        }
    }
    
}

// MARK: - TextFieldDelegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
