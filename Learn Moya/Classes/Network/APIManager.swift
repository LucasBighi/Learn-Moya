//
//  APIManager.swift
//  Learn Moya
//
//  Created by Lucas Marques Bighi on 22/04/20.
//  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
//

import Moya

class APIManager {
    
    enum Method {
        case get(endpoint: Endpoints, path: String = "")
        case post(endpoint: Endpoints, path: String = "", param: [String: String]?)
        case put(endpoint: Endpoints, path: String = "", param: [String: String]?)
        case delete(endpoint: Endpoints, path: String = "")
    }
    
    private var provider = MoyaProvider<APIManager.Method>()
    
    func makeRequest<U: Codable>(_ method: Method, success: @escaping(U) -> Void, failure: @escaping(Error) -> Void) {
        
        provider.request(method) { (result) in
            switch result {
            case .success(let response):
                do {
                    success(try JSONDecoder().decode(U.self, from: response.data))
                } catch let error {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}

extension APIManager.Method: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {
            fatalError("Unable to convert url string to URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .get(let endpoint, let path):
            return "\(endpoint.rawValue)/\(path)"
        case .post(let endpoint, let path, _):
            return "\(endpoint.rawValue)/\(path)"
        case .put(let endpoint, let path, _):
            return "\(endpoint.rawValue)/\(path)"
        case .delete(let endpoint, let path):
            return "\(endpoint.rawValue)/\(path)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .get, .delete:
            return .requestPlain
        case .post(_, _, let param), .put(_, _, let param):
            return .requestParameters(parameters: param ?? [String: Any](), encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
