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
        var request = URLRequest(url: Constants.ApiURL().studentLocationURL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, res, err in
            
            if err != nil {
                print(err!)
                return
            }
            
            let parsedData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
            
            if let _ = parsedData["error"] {
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
                self.appDelegate.studentPins = StudentInformation.pinsFromResults(parsedData["results"] as! NSArray)
                
                let notification = Notification.init(name: .studentDataDownloaded)
                self.notificationCenter.post(notification)
            }
        }
        task.resume()
    }
}

extension Notification.Name {
    static let studentDataDownloaded = Notification.Name(rawValue: "StudentDataDownloadCompleted")
}
