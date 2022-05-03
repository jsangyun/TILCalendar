//  SubjectMainTableViewController.swift

import UIKit
import RxSwift
import RxCocoa
import Lottie

class SubjectMainViewController: UIViewController {
    
    let subjectViewModel = SubjectViewModel()
    var disposeBag = DisposeBag()
    
    var subjectList = BehaviorRelay<[Subject]>(value: [])
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    var allSubjects: [Subject] = []
    
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
        subjectList.accept(subjectViewModel.allSubject())
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
        
        // select event binding
        _ = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Subject.self))
            .subscribe(onNext: {[weak self] (indexPath, subject) in
                
                guard let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: "SubjectDetailTableViewController") as? SubjectDetailTableViewController else {return}
                
                detailVC.subjectId = subject.id
                
                self?.navigationController?.pushViewController(detailVC, animated: true)
                
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        _ = tableView.rx.modelDeleted(Subject.self)
            .subscribe(onNext: { [weak self] deletedSubject in
                self?.subjectViewModel.deleteSubject(id: deletedSubject.id)
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
