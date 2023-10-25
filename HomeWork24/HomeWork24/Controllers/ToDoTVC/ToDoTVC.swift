//
//  ToDoTVC.swift
//  HomeWork24
//
//  Created by  NovA on 21.10.23.
//

import Alamofire
import Lottie
import UIKit

class ToDoTVC: UITableViewController {
    var userId: Int?
    var toDos: [ToDos]?
    var index: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchToDos()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDos?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoList", for: indexPath) as! ToDoCell
        let todos = toDos?[indexPath.row]
        cell.emailLbl.text = todos?.title
        cell.configure(isSelected: (todos?.completed)!)
        cell.stackView.alpha = (todos?.completed)! ? 0.4 : 1.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        cell.chechView.isUserInteractionEnabled = true
        cell.chechView.addGestureRecognizer(tapGesture)
        cell.chechView.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = toDos?[indexPath.row].id else { return }
            NetworkService.deleteToDo(id: id) { [weak self] in
                self?.toDos?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag, let todos = toDos?[index] else { return }

        let alertController = UIAlertController(title: "Is the task completed?", message: "Are you sure you want to change the task status?", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in

            guard var completed = todos.completed else { return }

            completed.toggle()

            let parameters: Parameters = [
                "completed": completed
            ]

            let urlEditUser = "\(ApiConstants.todosPath)/\(todos.id)"
            AF.request(urlEditUser, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
                .response { [weak self] response in
                    if let data = response.data {
                        do {
                            self?.fetchToDos()
                            self?.tableView.reloadData()
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func fetchToDos() {
        guard let userId = userId else { return }
        NetworkService.fetchToDos(userID: userId) { [weak self] toDos, error in
            if let error = error {
                print(error)
            } else if let toDos = toDos {
                self?.toDos = toDos
                self?.tableView.reloadData()
            }
        }
    }
}
