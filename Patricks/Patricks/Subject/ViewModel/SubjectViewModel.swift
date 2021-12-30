//
//  SubjectViewModel.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/08.
//

import Foundation
import RxSwift
import RxCocoa

class SubjectViewModel {
    
    var allSubjects = BehaviorSubject<[Subject]>(value: [])
    
    init() {
        allSubjects
            .onNext([
                Subject(0, "리액트"),
                Subject(1, "iOS"),
            ])
    }
}
