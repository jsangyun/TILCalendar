//  Model.swift

import Foundation

struct TIL: Codable {
    
    var id: String
    var title: String
    var content: String
    var createdDate: Date
    var subjectId: String
    
    init(_ id: String, _ title: String, _ content: String, _ createdDate: Date, _ subjectId: String) {
        self.id = id
        self.title = title
        self.content = content
        self.createdDate = createdDate
        self.subjectId = subjectId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdDate = "created_date"
        case subjectId = "subject_id"
    }
    
    mutating func update(title: String, content: String, createdDate: Date, subjectId: String) {
        self.title = title
        self.content = content
        self.createdDate = createdDate
        self.subjectId = subjectId
    }
    
}
