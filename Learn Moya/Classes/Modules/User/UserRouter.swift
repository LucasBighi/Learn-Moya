//
//  UserRouter.swift
//  Learn Moya
//
//  Created by Lucas Marques Bighi on 22/04/20.
//  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

class UserRouter: UserRouterProtocol {
    func pushToUserDetail(with user: User, from view: UIViewController) {
        
    }
    
    static func createUserModule(userRef: UserViewController) {
        let presenter: UserPresenterProtocol & UserOutputInteractorProtocol = UserPresenter()
        
        userRef.presenter = presenter
        userRef.presenter?.router = UserRouter()
        userRef.presenter?.view = userRef
        userRef.presenter?.interactor = UserInteractor(apiManager: APIManager())
        userRef.presenter?.interactor?.presenter = presenter
    }
}
