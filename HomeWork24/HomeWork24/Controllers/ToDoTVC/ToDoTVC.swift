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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap(_:)))
        cell.chechView.isUserInteractionEnabled = true
        cell.chechView.addGestureRecognizer(tapGesture)

        return cell
    }

    @objc func imageTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            if imageView.image == image1 {
              
            } else {
                
            }
        }
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
