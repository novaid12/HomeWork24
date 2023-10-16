//
//  NewPostVC.swift
//  RestAppCW
//
//  Created by Мартынов Евгений on 12.10.23.
//

import Alamofire
import SwiftyJSON
import UIKit

final class NewPostVC: UIViewController {
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var bodyTV: UITextView!
    
    var user: User?
    
    
    @IBAction func postAlamofire() {
        if let userId = user?.id,
           let title = titleTF.text,
           let body = bodyTV.text,
           let url = ApiConstants.postsURL
        {
            let parameters: Parameters = [
                "userId": userId,
                "title": title,
                "body": body
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .response { [weak self] response in
                    /// тут мы уже в главном потоке
                    debugPrint(response)
                    print(response.request)
                    print(response.response)
                    debugPrint(response.result)
                    
                    switch response.result {
                    case .success(let data):
                        print(data)
                        print(JSON(data))
                        self?.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}
