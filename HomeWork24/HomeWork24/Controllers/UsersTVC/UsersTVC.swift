//
//  UsersTVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import UIKit

final class UsersTVC: UITableViewController {
    private var users: [User] = []
    private var photos: [Photo] = []
    private var avatarsUrl: [String] = []

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        activityIndicator.startAnimating()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell
        let user = users[indexPath.row]

        let photo = photos.filter { $0.albumId == user.id }

        guard let url = photo[0].thumbnailUrl, let fullUrl = photo[0].url else { return cell }
        avatarsUrl.append(fullUrl)

        cell.nameLbl.text = user.name
        cell.emailLbl.text = user.email

        guard let url = URL(string: url) else { return cell }

        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data,
                   let image = UIImage(data: data)
                {
                    cell.avatarImage.image = image
                    cell.avatarImage.layer.cornerRadius = 25
                }
            }
        }.resume()
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let detailVC = segue.destination as? DetailVC else { return }
        let user = users[indexPath.row]
        detailVC.user = user
        detailVC.urlPhoto = avatarsUrl[indexPath.row]
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
        }.resume()

        guard let photosURL = ApiConstants.photosURL else { return }

        URLSession.shared.dataTask(with: photosURL) { [weak self] data, _, error in

            guard let self else { return }

            if let error = error {
                print(error)
            }

            if let data = data {
                do {
                    self.photos = try JSONDecoder().decode([Photo].self, from: data)
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
