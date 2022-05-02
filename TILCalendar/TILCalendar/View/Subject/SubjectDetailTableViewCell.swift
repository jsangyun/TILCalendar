//  SubjectDetailTableViewCell.swift

import UIKit

class SubjectDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var tilTitleLabel: UILabel!
    @IBOutlet weak var tilDateLabel: UILabel!
    
    func bind(title: String, date: Date) {
        tilTitleLabel.text = title
        tilDateLabel.text = date.formatToString()
    }

}
