//
//  User.swift
//
//
//  Created by Lucas Marques Bighi on 23/04/20.
//
//

import Foundation

struct User {
    // MARK: - Properties
    let id: Int
    let name: String
    
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}
