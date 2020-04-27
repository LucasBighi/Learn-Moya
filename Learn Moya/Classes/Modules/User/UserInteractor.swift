//
//  UserInteractor.swift
//  Learn Moya
//
//  Created by Lucas Marques Bighi on 22/04/20.
//  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
//

import Foundation

class UserInteractor: UserInputInteractorProtocol {
    // MARK: Properties
    var presenter: UserOutputInteractorProtocol?
    var apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func getUsers() {
        apiManager.makeRequest(.get(endpoint: .users), success: { (users: [User]) in
            self.presenter?.usersDidFetch(users: users)
        }) { (error) in
            print(error)
        }
    }
    
    func add(_ user: User) {
        apiManager.makeRequest(.post(endpoint: .users, param: ["name": user.name]), success: { (newUser: User) in
            self.presenter?.successOnCreateUser(newUser: newUser)
        }) { (error) in
            print(error)
        }
    }
    
    func modify(_ user: User, at indexPath: IndexPath) {
        apiManager.makeRequest(.put(endpoint: .users, path: "\(user.id)", param: ["name": "[Modified] " + user.name]), success: { (updatedUser: User) in
            self.presenter?.successOnUpdateUser(updatedUser: updatedUser, at: indexPath)
            print(updatedUser)
        }) { (error) in
            print(error)
        }
    }
    
    func delete(_ user: User, at indexPath: IndexPath) {
        apiManager.makeRequest(.delete(endpoint: .users, path: "\(user.id)"), success: { (result: User) in
            self.presenter?.successOnDeleteUser(at: indexPath)
        }) { (error) in
            print(error)
        }
    }
}
