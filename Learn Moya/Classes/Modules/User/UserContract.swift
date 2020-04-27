//
//  UserContract.swift
//  Learn Moya
//
//  Created by Lucas Marques Bighi on 22/04/20.
//  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit


// MARK: View Output (Presenter -> View)
protocol UserViewProtocol: class {
    func showUsers(with users: [User])
    func successOnCreateUser()
    func successOnUpdateUser(at indexPath: IndexPath)
    func successOnDeleteUser(at indexPath: IndexPath)
}


// MARK: View Input (View -> Presenter)
protocol UserPresenterProtocol: class {
    var interactor: UserInputInteractorProtocol? {get set}
    var view: UserViewProtocol? {get set}
    var router: UserRouterProtocol? {get set}
    
    func getUsers()
    func add(_ user: User)
    func modify(_ user: User, at indexPath: IndexPath)
    func delete(_ user: User, at indexPath: IndexPath)
    func showUserSelection(with user: User, from view: UIViewController)
    func numberOfRows() -> Int
    func user(at indexPath: IndexPath) -> User
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol UserInputInteractorProtocol: class {
    var presenter: UserOutputInteractorProtocol? {get set}
    func getUsers()
    func add(_ user: User)
    func modify(_ user: User, at indexPath: IndexPath)
    func delete(_ user: User, at indexPath: IndexPath)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol UserOutputInteractorProtocol: class {
    func usersDidFetch(users: [User])
    func successOnCreateUser(newUser: User)
    func successOnUpdateUser(updatedUser: User, at indexPath: IndexPath)
    func successOnDeleteUser(at indexPath: IndexPath)
}


// MARK: Router Input (Presenter -> Router)
protocol UserRouterProtocol: class {
    func pushToUserDetail(with user: User, from view: UIViewController)
    static func createUserModule(userRef: UserViewController)
}
