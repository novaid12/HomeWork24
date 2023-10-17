//
//  UsersTVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import Alamofire
import AlamofireImage
import SwiftUI
import SwiftyJSON
import UIKit

final class UsersTVC: UITableViewController {
    private var users: [User] = []

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        activityIndicator.startAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        fetchUsers()
        activityIndicator.startAnimating()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let userId = users[indexPath.row].id
            NetworkService.deleteUser(userId: userId) { [weak self] in
                self?.users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell
        let user = users[indexPath.row]

        cell.nameLbl.text = user.name
        cell.emailLbl.text = user.email

        return cell
    }

    @IBAction func goToCreateUserVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(withIdentifier: "CreateUserVC") as! CreateUserVC
        navigationController?.pushViewController(createVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let detailVC = segue.destination as? DetailVC else { return }
        let user = users[indexPath.row]
        detailVC.userData = user
    }

    private func fetchUsers() {
        guard let usersURL = ApiConstants.usersURL else { return }

        URLSession.shared.dataTask(with: usersURL) { [weak self] data, _, error in

            guard let self else { return }

            if let error = error {
                print(error)
            }

            if let data = data {
                do {
                    self.users = try JSONDecoder().decode([User].self, from: data)
                } catch {
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }.resume()
    }
}
