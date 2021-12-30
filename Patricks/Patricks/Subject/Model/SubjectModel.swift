//
//  SubjectModel.swift
//  Patricks
//
//  Created by 정상윤 on 2021/12/04.
//

import Foundation

struct Subject: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdDate = "created_date"
    }
    
    var id : Int
    var name: String
    var createdDate: String
    
    init(_ id: Int, _ name: String, _ createdDate: Date = Date()) {
        self.id = id
        self.name = name
        self.createdDate = APIService.formatDateToString(createdDate)
    }
    
    /*
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(createdDate, forKey: .createdDate)
    }
    */
}
