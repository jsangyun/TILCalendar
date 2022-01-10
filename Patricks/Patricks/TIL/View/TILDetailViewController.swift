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
    
    var til: TIL!
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
                self?.til = til[0]
            })
        
        let rightBarButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonClicked))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("detailView Will Appear")
    }
    
    @objc private func editButtonClicked(_ sender: Any) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "TILEditViewController") as? TILEditViewController else {
            return
        }
        editVC.til = til
        self.present(editVC, animated: true, completion: nil)
    }
    
    func setLabelText(_ til: TIL) {
        tilTitleLabel.text = til.title
        tilContentLabel.text = til.content
        tilSubjectLabel.text = subjectViewModel.getSubjectNameById(til.subjectId)
    }
}
