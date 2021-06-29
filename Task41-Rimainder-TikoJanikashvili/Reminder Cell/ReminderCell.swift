//
//  ReminderCell.swift
//  Task41-Rimainder-TikoJanikashvili
//
//  Created by Tiko on 28.06.21.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    
    func setCell(item: Reminder) {
        self.titleLabel.text = "\(item.title)"
        self.discriptionLabel.text = item.discription
       
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        self.dateLabel.text = formatter.string(from: item.data)
    }
}
