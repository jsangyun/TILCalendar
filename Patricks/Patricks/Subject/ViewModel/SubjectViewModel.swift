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
    var subjectCount: Int = 0
    
    init() {
        let data: [Subject] = APIService.load("subject.json")
        subjectCount = data.count
        
        allSubjects
            .onNext(data)
    }
    
    func getSubjectNameById(_ id: Int) -> String {
        var name: String = ""
        
        _ = allSubjects
            .map {
                $0.filter{$0.id == id}
            }
            .take(1)
            .subscribe(onNext: {
                name = $0[0].name
            })
            .dispose()
            
        return name
    }
}
