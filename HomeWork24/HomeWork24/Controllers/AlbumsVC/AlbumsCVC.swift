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

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
     }
     */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumsCell", for: indexPath) as! AlbumsCell
        let album = albums[indexPath.row]
        cell.photosCount.text = album.title
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

     }
     */

    private func fetchAlbums() {
        guard let userId = userId else { return }
        let url = "\(ApiConstants.albumsPath)/?userId=\(userId)"

        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let data):
                    print(JSON(data))
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
        let width = view.frame.width / 3 - 10
        return CGSize(width: width, height: width)
    }
}
