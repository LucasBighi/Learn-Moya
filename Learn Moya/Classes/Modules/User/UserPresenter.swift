//
//  UserPresenter.swift
//  Learn Moya
//
//  Created by Lucas Marques Bighi on 22/04/20.
//  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

class UserPresenter: UserPresenterProtocol {
    var interactor: UserInputInteractorProtocol?
    var view: UserViewProtocol?
    var router: UserRouterProtocol?
    
    var users = [User]()
    
    func add(_ user: User) {
        interactor?.add(user)
    }
    
    func modify(_ user: User, at indexPath: IndexPath) {
        interactor?.modify(user, at: indexPath)
    }
    
    func delete(_ user: User, at indexPath: IndexPath) {
        interactor?.delete(user, at: indexPath)
    }
    
    func getUsers() {
        interactor?.getUsers()
    }
    
    func showUserSelection(with user: User, from view: UIViewController) {
        router?.pushToUserDetail(with: user, from: view)
    }
    
    func numberOfRows() -> Int {
        return users.count
    }
    
    func user(at indexPath: IndexPath) -> User {
        return users[indexPath.row]
    }
}

extension UserPresenter: UserOutputInteractorProtocol {
    func successOnUpdateUser(updatedUser: User, at indexPath: IndexPath) {
        users[indexPath.row] = updatedUser
        view?.successOnUpdateUser(at: indexPath)
    }
    
    func successOnDeleteUser(at indexPath: IndexPath) {
        users.remove(at: indexPath.row)
        view?.successOnDeleteUser(at: indexPath)
    }
    
    func successOnCreateUser(newUser: User) {
        users.insert(newUser, at: 0)
        view?.successOnCreateUser()
    }
    
    func usersDidFetch(users: [User]) {
        self.users = users
        view?.showUsers(with: users)
    }
}
