//  TILTableViewCell.swift

import UIKit

class TILTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tilTitleLabel: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    
    func bind(title: String, subjectName: String) {
        self.tilTitleLabel.text = title
        self.subjectNameLabel.text = subjectName
    }
    
}
