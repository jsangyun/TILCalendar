//
//  TILDetailViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/31.
//

import UIKit
import RxSwift

class TILDetailViewController: UIViewController {
    
    @IBOutlet weak var tilTitleLabel: UILabel!
    @IBOutlet weak var tilSubjectLabel: UILabel!
    @IBOutlet weak var tilContentLabel: UILabel!
    
    var til: TIL!
    var tilId: Int!
    
    var tilViewModel: TILViewModel!
    var subjectViewModel: SubjectViewModel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        _ = tilViewModel.allTIL
            .map { [weak self] in
                $0.filter { $0.id == self?.tilId }
            }
            .subscribe(onNext: { [weak self] til in
                if til.isEmpty {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.setLabelText(til[0])
                    self?.til = til[0]
                    
                }
            })
            .disposed(by: disposeBag)
        
        let rightBarButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonClicked))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func editButtonClicked(_ sender: Any) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "TILEditViewController") as? TILEditViewController else {
            return
        }
        editVC.til = til
        editVC.tilViewModel = self.tilViewModel
        editVC.subjectViewModel = self.subjectViewModel
        
        editVC.modalPresentationStyle = .overFullScreen
        self.present(editVC, animated: true, completion: nil)
    }
    
    func setLabelText(_ til: TIL) {
        tilTitleLabel.text = til.title
        tilContentLabel.text = til.content
        tilSubjectLabel.text = subjectViewModel.getSubjectNameById(til.subjectId)
    }
}
