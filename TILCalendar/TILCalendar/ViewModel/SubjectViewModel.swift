//  SubjectViewModel.swift

import Foundation

class SubjectViewModel {
    
    private var subjectFilename = "subject.json"
    
    private var subjectList: [Subject] {
        get { APIService.load(subjectFilename) }
        set { APIService.save(subjectFilename, newValue) }
    }
    
    var allSubject: [Subject] {
        subjectList
    }
    
    func subjectName(of id: String) -> String {
        return subjectList.filter{$0.id == id}[0].name
    }
    
    func saveNewSubject(name: String) {
        subjectList.append(Subject(UUID().uuidString, name))
    }
    
    func updateSubject(id: String, newName: String) {
        subjectList = subjectList.filter{$0.id != id}
        subjectList.append(Subject(id, newName))
    }
    
    func deleteSubject(id: String) {
        subjectList = subjectList.filter{$0.id != id}
    }
}
