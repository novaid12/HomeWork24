//
//  PostsVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import UIKit

final class PostsVC: UITableViewController {
    private var posts: [Post] = []
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell
        let post = posts[indexPath.row]
        cell.bodyLbl.text = post.body
        cell.titleLbl.text = post.title
        return cell
    }

    private func fetchPosts() {
        guard let postsURL = ApiConstants.postsURL else { return }
        
        URLSession.shared.dataTask(with: postsURL) { [weak self] data, _, error in
            
            guard let self else { return }
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let allPosts = try JSONDecoder().decode([Post].self, from: data)
                    for i in 0 ... allPosts.count - 1 {
                        if allPosts[i].userId == userId {
                            self.posts.append(allPosts[i])
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.resume()
    }
}
