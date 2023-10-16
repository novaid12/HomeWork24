//
//  NetworkServices.swift
//  HomeWork24
//
//  Created by  NovA on 16.10.23.
//

import Alamofire
import AlamofireImage
import Foundation
import SwiftyJSON

class NetworkService {
    static func deletePost(postId: Int, callback: @escaping () -> ()) {
        let urlPath = "\(ApiConstants.postsPath)/\(postId)"
        AF.request(urlPath, method: .delete, encoding: JSONEncoding.default)
            .response { _ in
                callback()
            }
    }

    static func deleteUser(userId: Int, callback: @escaping () -> ()) {
        let urlUser = "\(ApiConstants.usersPath)/\(userId)"
        AF.request(urlUser, method: .delete, encoding: JSONEncoding.default)
            .response { _ in
                callback()
            }
    }
}
