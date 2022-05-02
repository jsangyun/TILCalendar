//  TILDetailViewController.swift

import UIKit
import RxSwift
import RxCocoa

class TILDetailViewController: UIViewController {
    
    @IBOutlet weak var tilTitleLabel: UILabel!
    @IBOutlet weak var tilSubjectLabel: UILabel!
    @IBOutlet weak var tilContentLabel: UILabel!
    
    var selectedTil = BehaviorRelay<TIL?>(value: nil)
    var selectedId: String!
    
    let tilViewModel = TILViewModel()
    let subjectViewModel = SubjectViewModel()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedTil.accept(tilViewModel.til(id: selectedId))
        
        _ = selectedTil
            .subscribe(onNext: {
                if $0 == nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.setLabelText($0!)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonClicked))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func editButtonClicked(_ sender: Any) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "TILEditViewController") as? TILEditViewController else {
            return
        }
        
        editVC.til = selectedTil.value
        
        editVC.modalPresentationStyle = .fullScreen
        self.present(editVC, animated: true, completion: nil)
    }
    
    func setLabelText(_ til: TIL) {
        tilTitleLabel.text = til.title
        tilContentLabel.text = til.content
        tilSubjectLabel.text = subjectViewModel.getSubjectName(id: til.subjectId)
    }
}
