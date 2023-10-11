//
//  UsersTVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import UIKit

class UsersTVC: UITableViewController {
    private var users: [User] = []
//    private var albums: [Album] = []
//    private var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
//        fetchAlbums()
//        fetchPhotos()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell
        let user = users[indexPath.row]
        cell.nameLbl.text = user.name
//        cell.imageView?.image = fetchImage(userId: user.id)
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
    
//    private func fetchAlbums() {
//        guard let albumsURL = ApiConstants.albumsURL else { return }
//        
//        URLSession.shared.dataTask(with: albumsURL) { [weak self] data, _, error in
//            
//            guard let self else { return }
//            
//            if let error = error {
//                print(error)
//            }
//            
//            if let data = data {
//                do {
//                    self.albums = try JSONDecoder().decode([Album].self, from: data)
//                } catch {
//                    print(error)
//                }
//            }
//            
//        }.resume()
//    }
//    
//    private func fetchPhotos() {
//        guard let photosURL = ApiConstants.photosURL else { return }
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
//                    self.photos = try JSONDecoder().decode([Photo].self, from: data)
//                } catch {
//                    print(error)
//                }
//            }
//            
//        }.resume()
//    }
//    
    private func fetchImage(userId: Int) -> UIImage? {
//        var myImage: UIImage?
//        var photo: Photo?
//
//        if self.albums[0].userId == userId, self.photos[0].albumId == self.albums[0].id {
//            photo = photos[0]
//        }
//        print(photo)
//        guard let url = URL(string: "") else { return nil }
//
//        let urlRequest = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
//
//            DispatchQueue.main.async {
//                if let data = data,
//                   let image = UIImage(data: data)
//                {
//                    myImage = image
//                } else {
//                    // тут можно пользователю показать ошибку картинки
//                }
//            }
//
//        }.resume()
        return nil
    }
}
