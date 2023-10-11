//
//  UsersTVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import UIKit

class UsersTVC: UITableViewController {
    private var users: [User] = []
    private var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell
        let user = users[indexPath.row]
        cell.nameLbl.text = user.name
        cell.emailLbl.text = user.email
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let detailVC = segue.destination as? DetailVC else { return }
        let user = users[indexPath.row]
        detailVC.user = user
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
                self.tableView.reloadData()
            }
            
        }.resume()
    }
    
//    func getAvatar(userId: Int) -> UIImage? {
//        guard let photosURL = ApiConstants.photosURL else { return nil }
//
//        URLSession.shared.dataTask(with: photosURL) { [weak self] data, _, error in
//
//            guard let self else { return }
//
//            if let error = error {
//                print(error)
//            }
//
//            if let data = data {
//                do {
//                    let myPhotos = try JSONDecoder().decode([Photo].self, from: data)
//                    self.photos = myPhotos.filter { $0.albumId == userId }
//                } catch {
//                    print(error)
//                }
//            }
//
//        }.resume()
//
//        var myImage: UIImage?
//        let photo = photos.filter { $0.albumId == userId }
//        guard let url = URL(string: photo[0].thumbnailUrl!) else { return nil }
//
//        let urlRequest = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
//            if let data = data,
//               let image = UIImage(data: data)
//            {
//                myImage = image
//            }
//        }.resume()
//        return myImage
//    }
}
