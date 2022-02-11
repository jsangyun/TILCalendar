//
//  SubjectDetailTableViewController.swift
//  Patricks
//
//  Created by 정상윤 on 2022/01/13.
//

import UIKit

class SubjectDetailTableViewController: UITableViewController {
    
    var subjectId: Int!
    var subjectViewModel: SubjectViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
