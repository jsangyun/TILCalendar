//  SubjectMainTableViewController.swift

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Lottie

class SubjectMainViewController: UIViewController {
    
    let subjectViewModel = SubjectViewModel()
    let tilViewModel = TILViewModel()
    var disposeBag = DisposeBag()
    
    var subjectList = BehaviorRelay<[Subject]>(value: [])
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    let emptyView = AnimationView(name: "empty-animation")
    let cellIdentifier = "SubjectTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        bindEmptyView()
        bindTableView()
        
        createButton.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subjectList.accept(subjectViewModel.allSubject)
    }
    
    private func bindEmptyView() {
        view.addSubview(emptyView)
        emptyView.setUp()
        emptyView.bind(relay: subjectList, disposeBag: disposeBag)
    }
    
    private func bindTableView() {
        
        // data binding
        _ = subjectList
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: SubjectTableViewCell.self)) { (index, item, cell) in
                
                cell.subjectNameLabel.text = item.name
                
            }
            .disposed(by: disposeBag)
        
        // select event
        _ = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Subject.self))
            .subscribe(onNext: {[weak self] (indexPath, subject) in
                
                guard let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: "SubjectDetailTableViewController") as? SubjectDetailTableViewController else {return}
                
                detailVC.subjectId = subject.id
                
                self?.navigationController?.pushViewController(detailVC, animated: true)
                
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        // delete event
        _ = tableView.rx.modelDeleted(Subject.self)
            .subscribe(onNext: { [weak self] deletedSubject in
                
                let warningMessage = "해당 과목의 TIL들도 함께 삭제됩니다!"
                let alertController = UIAlertController(title: "경고!", message: warningMessage, preferredStyle: .actionSheet)
                
                let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self?.subjectViewModel.deleteSubject(id: deletedSubject.id)
                    self?.tilViewModel.deleteAllSubjectTil(subjectId: deletedSubject.id)
                    
                    if let newList = self?.subjectViewModel.allSubject {
                        self?.subjectList.accept(newList)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                self?.present(alertController, animated: true)
                
            })
            .disposed(by: disposeBag)
        
    }
}

extension SubjectMainViewController {
    func setNavigationBar() {
        
        //Larget Title Color
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.scarlet]
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.scarlet]
        self.navigationController?.navigationBar.tintColor = UIColor.scarlet
        
    }
    
    @IBAction func createButtonClicked() {
        guard let createVC = storyboard?.instantiateViewController(withIdentifier: "SubjectCreateViewController") as? SubjectCreateViewController else {return}
        
        createVC.modalPresentationStyle = .fullScreen
        
        self.present(createVC, animated: true, completion: nil)
    }
}
