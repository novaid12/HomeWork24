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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        performSegue(withIdentifier: "showPhotos", sender: album)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
           let vc = segue.destination as? PhotosCVC,
           let albom = sender as? Album
        {
            vc.albom = albom
        }
    }

    private func fetchAlbums() {
        guard let userId = userId else { return }
        NetworkService.fetchAlboms(userID: userId) { [weak self] albums, error in
            if let error = error {
                print(error)
            } else if let albums = albums {
                self?.albums = albums
                
                self?.collectionView.reloadData()
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
