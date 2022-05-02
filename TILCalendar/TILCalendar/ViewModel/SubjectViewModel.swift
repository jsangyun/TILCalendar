//  SubjectViewModel.swift

import Foundation

class SubjectViewModel {
    
    private var subjectList = Array<Subject>()
    private var subjectFilename = "subject.json"
    
    init() {
        loadData()
    }
    
    func loadData() {
        let subjectData: [Subject] = APIService.load(subjectFilename)
        subjectList = subjectData
    }
    
    func allSubject() -> [Subject] {
        loadData()
        return subjectList
    }
    
    func getSubjectName(id: String) -> String {
        loadData()
        return subjectList.filter{$0.id == id}[0].name
    }
    
    func saveNewSubject(name: String) {
        let newSubject = Subject(UUID().uuidString, name)
        subjectList.append(newSubject)
        APIService.save(subjectFilename, subjectList)
    }
    
    func deleteSubject(id: String) {
        APIService.save(subjectFilename, subjectList.filter{$0.id != id})
    }
}
