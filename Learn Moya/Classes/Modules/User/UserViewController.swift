//
//  UserViewController.swift
//  Learn Moya
//
//  Created by Lucas Marques Bighi on 22/04/20.
//  Copyright © 2020 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Properties
    var presenter: UserPresenterProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UserRouter.createUserModule(userRef: self)
        activityIndicator.startAnimating()
        presenter?.getUsers()
    }
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add User", message: "Enter name of new user", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "User name"
        }
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            self.activityIndicator.startAnimating()
            guard let alert = alert else { return }
            let textField = alert.textFields![0]
            self.presenter?.add(User(id: 23, name: textField.text ?? "Username"))
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension UserViewController: UserViewProtocol {
    func showUsers(with users: [User]) {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func successOnCreateUser() {
        activityIndicator.stopAnimating()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    func successOnUpdateUser(at indexPath: IndexPath) {
        activityIndicator.stopAnimating()
        tableView.reloadRows(at: [indexPath], with: .left)
    }
    
    func successOnDeleteUser(at indexPath: IndexPath) {
        activityIndicator.stopAnimating()
        self.tableView.deleteRows(at: [indexPath], with: .right)
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = presenter?.user(at: indexPath)
        cell.textLabel?.text = user?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = presenter?.user(at: indexPath) {
            activityIndicator.startAnimating()
            presenter?.modify(user, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let user = presenter?.user(at: indexPath) {
            activityIndicator.startAnimating()
            presenter?.delete(user, at: indexPath)
        }
    }
}
