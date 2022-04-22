//
//  TaskCell.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 18.04.2022.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    func configure(withTask task: Task, done: Bool = false) {
        if done {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attributedString = NSAttributedString(string: task.title, attributes: attributes)
            
            titleLabel.attributedText = attributedString
            dateLabel = nil
            locationLabel = nil
        } else {
            titleLabel.text = task.title
            
            let dateString = dateFormatter.string(from: task.date)
            dateLabel.text = dateString
            
            locationLabel.text = task.location?.name
        }
    }
}
