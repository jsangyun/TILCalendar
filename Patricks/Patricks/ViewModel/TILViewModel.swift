//  TILVIewModel.swift

import Foundation

class TILViewModel {
    private var tilList = Array<TIL>()
    private var tilFilename = "til.json"
    
    init() {
        loadData()
    }
    
    func loadData() {
        let tilData: [TIL] = APIService.load(tilFilename)
        tilList = tilData
    }
    
    func allTIL() -> [TIL] {
        loadData()
        return tilList
    }
    
    func til(id: String) -> TIL? {
        loadData()
        let result = tilList.filter{$0.id == id}
        return result.isEmpty ? nil : result[0]
    }
    
    func getTILByDate(date: Date) -> [TIL] {
        loadData()
        return tilList.filter{$0.createdDate == date}
    }
    
    func getTILBySubject(subjectId: String) -> [TIL] {
        loadData()
        return tilList.filter{$0.subjectId == subjectId}
    }
    
    func saveNewTil(title: String, content: String, createdDate: Date, subjectId: String) {
        let newTil = TIL(UUID().uuidString, title, content, createdDate, subjectId)
        tilList.append(newTil)
        APIService.save(tilFilename, tilList)
    }
    
    func updateTil(id: String, title: String, content: String, createdDate: Date, subjectId: String) {
        let updatedTil = TIL(id, title, content, createdDate, subjectId)
        tilList = tilList.filter{$0.id != id}
        tilList.append(updatedTil)
        APIService.save(tilFilename, tilList)
    }
    
    func deleteTil(id: String) {
        APIService.save(tilFilename, tilList.filter{$0.id != id})
    }
    
    func deleteAllSubjectTil(subjectId: String) {
        APIService.save(tilFilename, tilList.filter{$0.subjectId != subjectId})
    }
}
