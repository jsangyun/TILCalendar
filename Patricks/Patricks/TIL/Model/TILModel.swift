//  Model.swift

import Foundation

struct TIL: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdDate = "created_date"
        case subjectId = "subject_id"
    }
    
    var id: Int
    var title: String
    var content: String
    var createdDate: String
    var subjectId: Int
    
    init(_ id: Int, _ title: String, _ content: String, _ createdDate: Date, _ subjectId: Int) {
        self.id = id
        self.title = title
        self.content = content
        self.createdDate = createdDate.formatToString()
        self.subjectId = subjectId
    }
    
}
