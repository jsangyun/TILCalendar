//
//  Model.swift
//  Patricks
//
//  Created by 정상윤 on 2021/11/20.
//

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
        self.createdDate = APIService.formatDateToString(createdDate)
        self.subjectId = subjectId
    }
    
    //createdDate 입력 없을 시 오늘 날짜로
    init(_ id: Int, _ title: String, _ content: String, _ subjectId: Int) {
        self.id = id
        self.title = title
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
