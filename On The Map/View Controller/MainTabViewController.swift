//
//  MainTabViewController.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInfo()
        fetchStudentData()
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
        defaults.removeObject(forKey: "userKey")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        fetchStudentData()
    }
    
    func fetchStudentData(){
        PinsService().getStudentPins(success: { (res) in
            if let _ = res["error"] {
                let alert = UIAlertController(title: "Uh oh!",
                                              message: "Something went wrong while downloading the pins. Please try again.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: {
                        self.appDelegate.studentPins = []
                    })
                }
            } else {
                self.appDelegate.studentPins = StudentInformation.pinsFromResults(res["results"] as! NSArray)
                
                let notification = Notification.init(name: .studentDataDownloaded)
                self.notificationCenter.post(notification)
            }
        }) { (err) in
            print(err.localizedDescription)
        }
    }
    
    func fetchUserInfo(){
        guard let key = self.defaults.string(forKey: "userKey") else { return }
        
        UserService().getUserDetails(key: key,
                                     success: { (res) in
                                        
                                        guard let firstName = res["first_name"], let lastName = res["last_name"] else { return }

                                        self.defaults.set(firstName, forKey: "userFirstName")
                                        self.defaults.set(lastName, forKey: "userLastName")
        }) { (err) in
            print(err.localizedDescription)
        }
    }
}

extension Notification.Name {
    static let studentDataDownloaded = Notification.Name(rawValue: "StudentDataDownloadCompleted")
}
