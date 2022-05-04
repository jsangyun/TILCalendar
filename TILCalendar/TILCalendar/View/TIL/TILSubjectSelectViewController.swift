//  TILSubjectSelectViewController.swift

import UIKit
import RxSwift
import RxCocoa
import Lottie

class TILSubjectSelectViewController: UIViewController {
    
    let subjectViewModel = SubjectViewModel()
    let disposeBag = DisposeBag()
    
    var subjectList = BehaviorRelay<[Subject]>(value: [])
    var selectedSubjectId: String!

    @IBOutlet weak var subjectPickerView: UIPickerView!
    
    let emptyView = AnimationView(name: "empty-animation")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        bindPickerView()
    }
    
    private func setDelegate() {
        subjectPickerView.delegate = nil
        subjectPickerView.dataSource = nil
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subjectList.accept(subjectViewModel.allSubject)
    }
    
    private func bindPickerView() {
        _ = subjectList
            .bind(to: subjectPickerView.rx.itemTitles) { _, item in
                self.selectedSubjectId = item.id
                return item.name
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        if let id = selectedSubjectId,
           let prevVC = self.presentingViewController as? TILEditViewController {
            prevVC.selectedSubjectId = id
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let addSubjectVC = UIStoryboard(name: "Subject", bundle: nil).instantiateViewController(withIdentifier: "SubjectCreateViewController") as? SubjectCreateViewController else {return}
        
        self.present(addSubjectVC, animated: true, completion: nil)
    }
}
