//
//  TableViewController.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var studentPins: NSArray = []
    @IBOutlet weak var pinsTableView: UITableView!
    override func viewDidLoad() {
        pinsTableView.delegate = self
        pinsTableView.dataSource = self
        populateScreen()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(populateScreen), name: .studentDataDownloaded, object: nil)
    }
    
    @objc func populateScreen(){
        if let studentPins = appDelegate.studentPins {
            self.studentPins = studentPins
            self.pinsTableView.reloadData()
            
        }
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentPins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pinsTableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath) as! StudentDataTableViewCell
        
        let currentPin = studentPins[indexPath.row] as! NSDictionary
        let name = "\(currentPin["firstName"] as! String) \(currentPin["lastName"] as! String)"
        cell.txtStudentName.text = name
        cell.txtStudentLink.text = currentPin["mediaURL"] as? String
        return cell
    }
    
    
}
