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
    var studentPins: [StudentInformation] = []
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
        
        let currentPin = studentPins[indexPath.row]
        
        if let first = currentPin.firstName, let last = currentPin.lastName{
            let name = "\(first) \(last)"
            cell.txtStudentName.text = name
            if let url = currentPin.mediaURL {
                cell.txtStudentLink.text = url
            }
        } else {
            cell.txtStudentName.text = "Error fetching name from API"
            cell.txtStudentLink.text = ""
        }
        
        return cell        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selectedPin = self.studentPins[indexPath.row]
        guard let toOpen = selectedPin.mediaURL else { return }
        UIApplication.shared.open(URL(string: toOpen)!)
    }
    
}
