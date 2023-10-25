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
import UIKit

class NetworkService {
    static func deletePost(postId: Int, callback: @escaping () -> ()) {
        let urlPath = "\(ApiConstants.postsPath)/\(postId)"
        AF.request(urlPath, method: .delete, encoding: JSONEncoding.default)
            .response { _ in
                callback()
            }
    }
    
    static func deleteToDo(id: Int, callback: @escaping () -> ()) {
        let urlPath = "\(ApiConstants.todosPath)/\(id)"
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
    
    static func fetchAlboms(userID: String, callback: @escaping (_ result: [Album]?, _ error: Error?) -> ()) {
        
        let urlPath = "\(ApiConstants.albumsPath)?userId=\(userID)"
        
        AF.request(urlPath, method: .get, encoding: JSONEncoding.default)
            .response { response in

                var value: [Album]?
                var err: Error?

                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        callback(value, err)
                        return
                    }
                    do {
                        value = try JSONDecoder().decode([Album].self, from: data)
                    } catch (let decoderError) {
                        callback(value, decoderError)
                    }
                case .failure(let error):
                    err = error
                }
                callback(value, err)
            }
    }

    static func fetchPhotos(albomID: Int, callback: @escaping (_ result: [Photo]?, _ error: Error?) -> ()) {
        let urlPath = "\(ApiConstants.photosPath)?albomId=\(albomID)"

        AF.request(urlPath, method: .get, encoding: JSONEncoding.default)
            .response { response in

                var value: [Photo]?
                var err: Error?

                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        callback(value, err)
                        return
                    }
                    do {
                        value = try JSONDecoder().decode([Photo].self, from: data)
                    } catch (let decoderError) {
                        callback(value, decoderError)
                    }
                case .failure(let error):
                    err = error
                }
                callback(value, err)
            }
    }
    
    static func fetchToDos(userID: Int, callback: @escaping (_ result: [ToDos]?, _ error: Error?) -> ()) {
        let urlPath = "\(ApiConstants.todosPath)?userId=\(userID)"

        AF.request(urlPath, method: .get, encoding: JSONEncoding.default)
            .response { response in

                var value: [ToDos]?
                var err: Error?

                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        callback(value, err)
                        return
                    }
                    do {
                        value = try JSONDecoder().decode([ToDos].self, from: data)
                    } catch (let decoderError) {
                        callback(value, decoderError)
                    }
                case .failure(let error):
                    err = error
                }
                callback(value, err)
            }
    }
    
    

    static func getThumbnail(thumbnailURL: String, callback: @escaping (_ result: UIImage?, _ error: AFError?) -> ()) {
        if let image = CacheManager.shared.imageCache.image(withIdentifier: thumbnailURL) {
            callback(image, nil)
        } else {
            AF.request(thumbnailURL).responseImage { response in
                switch response.result {
                case .success(let image):
                    CacheManager.shared.imageCache.add(image, withIdentifier: thumbnailURL)
                    callback(image, nil)
                case .failure(let error):
                    callback(nil, error)
                }
            }
        }
    }

    static func getData(from url: URL, complition: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: complition).resume()
    }

    static func downloadImage(from url: URL, callback: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        getData(from: url) { data, _, error in
            /// тут можно добавить логику
            ///  - обработки ошибо
            ///  - преобразования картинок
            if let data,
               let image = UIImage(data: data)
            {
                callback(image, nil)
            } else {
                callback(nil, error)
            }
        }
    }
}
