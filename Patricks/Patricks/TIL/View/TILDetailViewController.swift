//
//  TILDetailViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/31.
//

import UIKit

class TILDetailViewController: UIViewController {
    
    @IBOutlet weak var tilTitleLabel: UILabel!
    @IBOutlet weak var tilSubjectLabel: UILabel!
    @IBOutlet weak var tilContentLabel: UILabel!
    
    var tilId: Int!
    
    var tilViewModel = TILViewModel()
    var subjectViewModel = SubjectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = tilViewModel.allTIL
            .map {
                $0.filter { $0.id == self.tilId }
            }
            .subscribe(onNext: { [weak self] til in
                self?.setLabelText(til[0])
            })
        
    }
    
    func setLabelText(_ til: TIL) {
        tilTitleLabel.text = til.title
        tilContentLabel.text = til.content
        tilSubjectLabel.text = subjectViewModel.getSubjectNameById(til.subjectId)
    }
}
