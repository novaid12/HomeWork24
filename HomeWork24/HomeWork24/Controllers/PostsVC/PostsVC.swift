//
//  PostsVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import Alamofire
import SwiftyJSON
import UIKit

final class PostsVC: UITableViewController {
    private var posts: [Post] = []
//    var comments: [Comment]?
    var userId: Int?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPosts()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell
        let post = posts[indexPath.row]
        cell.bodyLbl.text = post.body
        cell.titleLbl.text = post.title
        
        let postId = post.id
        
        let url = "\(ApiConstants.commentsPath)/?postId=\(postId)"
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .response { response in
                if let data = response.data {
                    do {
                        let array = try JSONDecoder().decode([Comment].self, from: data)
                        cell.countComments.text = "Comments: " + array.count.description
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postId = posts[indexPath.row].id
            NetworkService.deletePost(postId: postId) { [weak self] in
                self?.posts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    @IBAction func newPostBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newPostVC = storyboard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
        newPostVC.user = user
        navigationController?.pushViewController(newPostVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let commentsVC = segue.destination as? CommentsVC else { return }
        let postId = posts[indexPath.row].id
        commentsVC.postId = postId.description
    }

    private func fetchPosts() {
        guard let userId = user?.id else { return }
        
        let url = "\(ApiConstants.postsPath)/?userId=\(userId)"

        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let data):
                    print(JSON(data))
                    if let data = response.data {
                        do {
                            self?.posts = try JSONDecoder().decode([Post].self, from: data)
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        
    }
}
