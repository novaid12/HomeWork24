//
//  AlbumsCVC.swift
//  HomeWork24
//
//  Created by  NovA on 16.10.23.
//

import Alamofire
import SwiftyJSON
import UIKit

class AlbumsCVC: UICollectionViewController {
    var userId: String?
    
    var albums: [Album] = []
    override func viewDidLoad() {
        fetchAlbums()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumsCell", for: indexPath) as! AlbumsCell
        let album = albums[indexPath.row]
        cell.photosCount.text = album.title
        cell.imageView.image = UIImage(systemName: "photo.artframe")
        return cell
    }
    
    private func fetchAlbums() {
        guard let userId = userId else { return }
        let url = "\(ApiConstants.albumsPath)/?userId=\(userId)"
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let data):
                    if let data = response.data {
                        do {
                            self?.albums = try JSONDecoder().decode([Album].self, from: data)
                            
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension AlbumsCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2 - 10
        return CGSize(width: width, height: width)
    }
}
