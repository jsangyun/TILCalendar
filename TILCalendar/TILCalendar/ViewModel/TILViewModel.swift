//  TILVIewModel.swift

import Foundation
import RxSwift

class TILViewModel {
    private var tilList: [TIL] {
        get { APIService.load(tilFilename) }
        set { APIService.save(tilFilename, newValue) }
    }
    private var tilFilename = "til.json"
    
    var allTIL: [TIL] {
        tilList
    }
    
    /*
     Calendar 탭에서 열려져 있던 상태에서 Subject 탭에서 삭제 시
     Crash 발생 방지를 위해 Optional 타입으로 반환
    */
    func til(id: String) -> TIL? {
        return tilList.filter{$0.id == id}.first
    }
    
    func getTILByDate(date: Date) -> [TIL] {
        return tilList.filter{$0.createdDate == date}
    }
    
    func getTILBySubject(subjectId: String) -> [TIL] {
        return tilList.filter{$0.subjectId == subjectId}
    }
    
    func saveNewTil(title: String, content: String, createdDate: Date, subjectId: String) {
        let newTil = TIL(UUID().uuidString, title, content, createdDate, subjectId)
        tilList.append(newTil)
    }
    
    func updateTil(id: String, title: String, content: String, createdDate: Date, subjectId: String) {
        tilList = tilList.filter{$0.id != id}
        tilList.append(TIL(id, title, content, createdDate, subjectId))
    }
    
    func deleteTil(id: String) {
        tilList = tilList.filter{$0.id != id}
    }
    
    func deleteAllSubjectTil(subjectId: String) {
        tilList = tilList.filter{$0.subjectId != subjectId}
    }
}
