//  TILEditViewController.swift

import UIKit
import RxSwift
import RxCocoa

class TILEditViewController: UIViewController {
    
    enum Mode {
        case create
        case edit
    }
    
    var til: TIL?
    var selectedSubjectId: String!
    var selectedDate: Date!
    var mode: Mode!
    
    let tilViewModel = TILViewModel()
    let subjectViewModel = SubjectViewModel()
    
    var subjectName = BehaviorRelay<String>(value: "과목 선택")
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subjectSelectButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectSelectButton.contentHorizontalAlignment = .left
        
        if til == nil {
            mode = .create
        } else {
            mode = .edit
        }
        
        if mode == .edit {
            fillText(til!)
        }
        
        _ = subjectName
            .bind(to: subjectSelectButton.rx.title())
            .disposed(by: disposeBag)
        
        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let subjectId = selectedSubjectId else {return}
        subjectName.accept(subjectViewModel.getSubjectName(id: subjectId))
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if (isThereChange()) {
            let alert = (mode == .edit)
            ? UIAlertController(title: "알림", message: "변경사항이 있습니다!", preferredStyle: .actionSheet)
            : UIAlertController(title: "알림", message: "작성 내용이 있습니다!", preferredStyle: .actionSheet)
            
            let defaultAction = UIAlertAction(title: "저장하지 않고 나가기", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel, handler: nil)
            
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        if subjectSelectButton.titleLabel?.text == "과목 선택" {
            let alert = UIAlertController(title: "", message: "과목을 선택해주세요!", preferredStyle: .alert)
            let action = UIAlertAction(title: "돌아가기", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(mode == .edit) {
            updateCurrentTil()
        }
        
        if(mode == .create) {
            saveCurrentTil()
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func subjectClicked(_ sender: Any) {
        guard let subjectVC = storyboard?.instantiateViewController(withIdentifier: "TILSubjectSelectViewController") as? TILSubjectSelectViewController else {return}
        
        subjectVC.modalPresentationStyle = .fullScreen
        self.present(subjectVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let parentVC = parent as? TILTableViewController else {return}
        parentVC.hidesBottomBarWhenPushed = false
    }
    
}

extension TILEditViewController {
    
    //fill data to textview / textfield
    func fillText(_ til: TIL) {
        
        subjectName.accept(subjectViewModel.getSubjectName(id: til.subjectId))
        
        titleTextField.text = til.title
        contentTextView.text = til.content
        selectedSubjectId = til.subjectId
    }
    
    //check whether data is changed or not
    func isThereChange() -> Bool {
        if (mode == .edit) {
            if (titleTextField.text != til!.title) || (subjectSelectButton.titleLabel?.text != subjectViewModel.getSubjectName(id: til!.subjectId)) || (contentTextView.text != til!.content) {
                return true
            }
        }
        else if (mode == .create) {
            if (titleTextField.text != "") ||
                (contentTextView.text != "" ||
                 (subjectSelectButton.titleLabel?.text != "과목 선택")) {
                return true
            }
        }
        return false
    }
    
    func updateCurrentTil() {
        tilViewModel.updateTil(id: til!.id, title: titleTextField.text!, content: contentTextView.text, createdDate: til!.createdDate, subjectId: selectedSubjectId)
    }
    
    func saveCurrentTil() {
        tilViewModel.saveNewTil(title: titleTextField.text!, content: contentTextView.text, createdDate: selectedDate, subjectId: selectedSubjectId)
    }
    
}
