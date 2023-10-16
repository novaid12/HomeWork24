//
//  CommentsVC.swift
//  HomeWork24
//
//  Created by  NovA on 16.10.23.
//

import Alamofire
import SwiftyJSON
import UIKit

final class CommentsVC: UITableViewController {
    var postId: String?
    var comments: [Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.bodyLbl.text = comment.body
        cell.emailLbl.text = comment.email
        cell.titleLbl.text = comment.name
        print(comment)
        return cell
    }

    private func fetchComments() {
        guard let postId = postId else { return }
        let url = "\(ApiConstants.commentsPath)/?postId=\(postId)"
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let data):
                    print(JSON(data))
                    if let data = response.data {
                        do {
                            self?.comments = try JSONDecoder().decode([Comment].self, from: data)
                            
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
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
