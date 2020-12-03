//
//  UserService.swift
//  Learn Moya
//
//  Created by Lucas Marques Bighi on 22/04/20.
//  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import Moya

enum UserService {
    case createUser(name: String)
    case readUser
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)
}

extension UserService: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .readUser, .createUser(_):
            return "/users"
        case .updateUser(let id, _), .deleteUser(let id):
            return "/users/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        case .readUser:
            return .get
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
        case .createUser(let name):
            return "{'name':'\(name)'}".data(using: .utf8)!
        case .readUser:
            return Data()
        case .updateUser(let id, let name):
            return "{'id':'\(id)', 'name':'\(name)'}".data(using: .utf8)!
        case .deleteUser(let id):
            return "{'id':'\(id)'}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .readUser, .deleteUser(_):
            return .requestPlain
        case .createUser(let name), .updateUser(_, let name):
            return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
