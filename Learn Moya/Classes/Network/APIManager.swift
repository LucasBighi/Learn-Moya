////
////  APIManager.swift
////  Learn Moya
////
////  Created by Lucas Marques Bighi on 22/04/20.
////  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//typealias ResultRequest = (data: Data, statusCode: Int)
//class APIManager {
//    
//    var header: HTTPHeaders!
//    
//    init(contentType: String = "application/json") {
//        guard let headerToken = UserModel.userToken else {
//            header = [
//                "Content-Type"  : contentType,
//                "adid"          : UIDevice.current.identifierForVendor!.uuidString,
//                "lng"           : "\(Locale.current.languageCode ?? "")"
//            ]
//            return
//        }
//
//        header = [
//            "Content-Type"  : contentType,
//            "adid"          : UIDevice.current.identifierForVendor!.uuidString,
//            "lng"           : "\(Locale.current.languageCode ?? "")",
//            "Authorization" :headerToken
//        ]
//    }
//    
//    func prepareRequestHeaders(_ newHeaders: HTTPHeaders?) -> HTTPHeaders? {
//        var response = self.header
//        if newHeaders != nil {
//            for (key, value) in newHeaders! {
//                response![key] = value
//            }
//        }
//        return response
//    }
//    
//    func get(url: String, headers: HTTPHeaders?, completion: @escaping (Data?, Int) -> Void) {
//        let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: prepareRequestHeaders(headers))
//        
//        request.request?.log()
//        
//        request.responseJSON { response in
//            var result = ""
//            
//            var statusCode = response.response?.statusCode ?? 0
//            print (statusCode)
//            
//            print (response.result)
//            
//            
//            if response.result.value == nil || response.result.value is NSNull {
//                result = ""
//                if response.result.error?._code == NSURLErrorNotConnectedToInternet {
//                    statusCode = response.result.error!._code
//                }
//            } else {
//                do {
//                    result = try (String(data: JSONSerialization.data(withJSONObject: response.result.value ?? "", options: .prettyPrinted), encoding: .utf8) ?? "").replacingOccurrences(of: "\n", with: "")
//                } catch let error {
//                    Crashlytics.sharedInstance().recordError(error)
//                }
//            }
//
//            DispatchQueue.main.async {
//                print(result.data(using: .utf8)?.toString() ?? "")
//                completion(result.data(using: .utf8), statusCode)
//            }
//            
//        }
//        
//        EventManager.sendEventConection(path: url, method: EventManager.METHOD_GET, action: EventManager.ACTION_CALL)
//    }
//    
//    func post(url: String, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Data?, Int) -> Void) {
//        let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.prepareRequestHeaders(headers))
//        request.responseJSON { response in
//            var result = ""
//            
//            var statusCode = response.response?.statusCode ?? 0
//            
//            print (statusCode)
//            if response.result.value == nil || response.result.value is NSNull {
//                result = ""
//                if response.result.error?._code == NSURLErrorNotConnectedToInternet {
//                    statusCode = response.result.error!._code
//                }
//            } else {
//                
//                do {
//                result = try (String(data: JSONSerialization.data(withJSONObject: response.result.value ?? "", options: .prettyPrinted), encoding: .utf8) ?? "").replacingOccurrences(of: "\n", with: "")
//                } catch let error {
//                    Crashlytics.sharedInstance().recordError(error)
//                }
//                
//                if statusCode != 200 {
//                    let qrCodeReleased: Bool =  UserDefaults.standard.object(forKey: "QRCodeReleased") as? Bool ?? false
//                    if qrCodeReleased {
//                        let fullResult = result.components(separatedBy: "\"")
//                        UserDefaults.standard.set(fullResult[3], forKey: "messageFail")
//                        UserDefaults.standard.synchronize()
//                    } else {
//                        let fullResult = result.components(separatedBy: "\"")
//                        UserDefaults.standard.set(true, forKey: "OperationFail")
//                        UserDefaults.standard.set(true, forKey: "errorMessageWallet")
//                        //UserDefaults.standard.set(fullResult[3], forKey: "messageFail")
//                        UserDefaults.standard.synchronize()
//                        
//                    }
//                }
//                
//            }
//            DispatchQueue.main.async {
//                completion(result.data(using: .utf8), statusCode)
//            }
//        }
//        
//        EventManager.sendEventConection(path: url, method: EventManager.METHOD_POST, action: EventManager.ACTION_CALL)
//    }
//    
//    func postUrlEncoded(url: String, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Data?, Int) -> Void) {
//        let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding(), headers: self.prepareRequestHeaders(headers))
//        request.responseJSON { response in
//            var result = ""
//            if response.result.value == nil || response.result.value is NSNull {
//                result = ""
//            } else {
//                do {
//                    result = try (String(data: JSONSerialization.data(withJSONObject: response.result.value ?? "", options: .prettyPrinted), encoding: .utf8) ?? "").replacingOccurrences(of: "\n", with: "")
//                    
//                } catch let error {
//                    Crashlytics.sharedInstance().recordError(error)
//                }
//            }
//            completion(result.data(using: .utf8), response.response?.statusCode ?? 0)
//        }
//        
//        EventManager.sendEventConection(path: url, method: EventManager.METHOD_POST, action: EventManager.ACTION_CALL)
//    }
//    
//    func postWithoutJson(url: String, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Data?, Int) -> Void) {
//        let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.prepareRequestHeaders(headers))
//        
//        request.responseJSON { response in
//            var result = ""
//            if response.result.value == nil || response.result.value is NSNull {
//                result = ""
//            } else {
//                result = "OK"
//            }
//            completion(result.data(using: .utf8), response.response?.statusCode ?? 0)
//        }
//        
//        EventManager.sendEventConection(path: url, method: EventManager.METHOD_POST, action: EventManager.ACTION_CALL)
//    }
//    
//    func put(url: String, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Data?, Int) -> Void) {
//        let request = Alamofire.request(url, method: .put, parameters: parameters!, encoding: JSONEncoding.default, headers: self.prepareRequestHeaders(headers))
//        request.responseJSON { response in
//            var result = ""
//            
//            var statusCode = response.response?.statusCode ?? 0
//            if response.result.value == nil || response.result.value is NSNull {
//                result = ""
//                if response.result.error?._code == NSURLErrorNotConnectedToInternet {
//                    statusCode = response.result.error!._code
//                }
//            } else {
//                do {
//                    result = try (String(data: JSONSerialization.data(withJSONObject: response.result.value ?? "", options: .prettyPrinted), encoding: .utf8) ?? "").replacingOccurrences(of: "\n", with: "")
//                } catch let error {
//                    Crashlytics.sharedInstance().recordError(error)
//                }
//            }
//            print(result.data(using: .utf8))
//            completion(result.data(using: .utf8), statusCode)
//        }
//        
//        EventManager.sendEventConection(path: url, method: EventManager.METHOD_PUT, action: EventManager.ACTION_CALL)
//    }
//    
//    func delete(url: String, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Data?, Int) -> Void) {
//        let request = Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: self.prepareRequestHeaders(headers))
//        
//        request.responseJSON { response in
//            var result = ""
//            if response.result.value == nil || response.result.value is NSNull {
//                result = ""
//            } else {
//                do {
//                result = try (String(data: JSONSerialization.data(withJSONObject: response.result.value ?? "", options: .prettyPrinted), encoding: .utf8) ?? "").replacingOccurrences(of: "\n", with: "")
//                } catch let error {
//                    Crashlytics.sharedInstance().recordError(error)
//                }
//            }
//            completion(result.data(using: .utf8), response.response?.statusCode ?? 0)
//        }
//        
//        EventManager.sendEventConection(path: url, method: EventManager.METHOD_PUT, action: EventManager.ACTION_CALL)
//    }
//    
//    func url(_ url: String) -> String {
//        return url
//    }
//    
//    // MARK: - Handle result
//     func result<U: ResponseRequest>(success: @escaping(U) -> Void, fail: @escaping(UZZOResponseError) -> Void)-> (ResultRequest)-> Swift.Void  {
//        return { result in
//            
//            do {
//                let obj = try JSONDecoder().decode(U.self, from: result.data)
//                if result.statusCode >= 200 && result.statusCode <= 299 {
//                    success(obj)
//                } else {
//                    fail(UZZOResponseError(errorCode: Int(obj.code ?? "0"), message: obj.message ?? "", statusCode: result.statusCode))
//                }
//            } catch {
//                print(error)
//                fail(UZZOResponseError(errorCode: result.statusCode, message: "", statusCode: result.statusCode))
//            }
//        }
//    }
//}
//
import Moya

class ResponseData: Codable {
    
}

class APIManager {
    
    let responseData = ResponseData()
    
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
    
//    func get<U: Codable>(endpoint: Endpoints, path: String = "", success: @escaping(U) -> Void, failure: @escaping(Error) -> Void) {
//        provider.request(.get(endpoint: endpoint.rawValue + path)) { (result) in
//            switch result {
//            case .success(let response):
//                do {
//                    let resultData = try JSONDecoder().decode(U.self, from: response.data)
//                    success(resultData)
//                } catch let error {
//                    failure(error)
//                }
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//    
//    func post<U: Codable>(endpoint: Endpoints, path: String = "", parameters: [String: String]?, success: @escaping(U) -> Void, failure: @escaping(Error) -> Void) {
//        provider.request(.post(endpoint: endpoint.rawValue + path, param: parameters)) { (result) in
//            switch result {
//            case .success(let response):
//                do {
//                    let resultData = try JSONDecoder().decode(U.self, from: response.data)
//                    success(resultData)
//                } catch let error {
//                    failure(error)
//                }
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//    
//    func put<U: Codable>(endpoint: Endpoints, path: String = "", parameters: [String: String]?, success: @escaping(U) -> Void, failure: @escaping(Error) -> Void) {
//        provider.request(.put(endpoint: endpoint.rawValue + path, param: parameters)) { (result) in
//            switch result {
//            case .success(let response):
//                do {
//                    let resultData = try JSONDecoder().decode(U.self, from: response.data)
//                    success(resultData)
//                } catch let error {
//                    failure(error)
//                }
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//    
//    func delete<U: Codable>(endpoint: Endpoints, path: String = "", success: @escaping(U) -> Void, failure: @escaping(Error) -> Void) {
//        provider.request(.delete(endpoint: endpoint.rawValue + path)) { (result) in
//            switch result {
//            case .success(let response):
//                do {
//                    let resultData = try JSONDecoder().decode(U.self, from: response.data)
//                    success(resultData)
//                } catch let error {
//                    failure(error)
//                }
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
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
        case .get(_):
            return .get
        case .post(_, _, _):
            return .post
        case .put(_, _, _):
            return .put
        case .delete(_, _):
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .get(_), .delete(_):
            return .requestPlain
        case .post(_, _, let param), .put(_, _, let param):
            return .requestParameters(parameters: param ?? [String: Any](), encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
