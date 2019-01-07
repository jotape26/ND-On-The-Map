//
//  StudentDataTableViewCell.swift
//  On The Map
//
//  Created by João Leite on 07/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class StudentDataTableViewCell: UITableViewCell {

    @IBOutlet weak var txtStudentName: UILabel!
    @IBOutlet weak var txtStudentLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
