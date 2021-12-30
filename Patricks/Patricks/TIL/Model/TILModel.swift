//
//  Model.swift
//  Patricks
//
//  Created by 정상윤 on 2021/11/20.
//

import Foundation

struct TIL: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case content
        case createdDate = "created_date"
        case subjectId = "subject_id"
    }
    
    var content: String
    var createdDate: String
    var subjectId: [Int]
    
    init(_ content: String = "", _ createdDate: String, _ subjectId: [Int]) {
        self.content = content
        self.createdDate = createdDate
        self.subjectId = subjectId
    }
    
    init(_ content: String = "", subjectId: [Int]) {
        self.content = content
        self.createdDate = APIService.formatDateToString(Date())
        self.subjectId = subjectId
    }
    /*
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(subject, forKey: .subject)
    }
    */
}
