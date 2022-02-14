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
    
    func addSubject(_ subjectName: String) {
        let newSubject = Subject(subjectCount, subjectName)
        subjectCount += 1
        _ = allSubjects
            .take(1)
            .subscribe(onNext: { prev in
                let newData = prev + [newSubject]
                APIService.save("subject.json", newData)
                self.allSubjects.onNext(newData)
            })
    }
    
    func deleteSubject(_ subjectId: Int) {
        
        subjectCount -= 1
        
        _ = allSubjects
            .take(1)
            .map{$0.filter{$0.id != subjectId}}
            .subscribe(onNext: {
                APIService.save("subject.json", $0)
                self.allSubjects.onNext($0)
            })
    }
}
