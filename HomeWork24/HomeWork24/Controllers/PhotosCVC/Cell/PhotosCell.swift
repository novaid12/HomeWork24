//
//  PhotosCell.swift
//  HomeWork24
//
//  Created by  NovA on 21.10.23.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    var thumbnailUrl: String? {
        didSet {
            getThumbnail()
        }
    }

    private func getThumbnail() {
        guard let thumbnailUrl = thumbnailUrl else { return }
        NetworkService.getThumbnail(thumbnailURL: thumbnailUrl) { [weak self] image, _ in
            self?.activityIndicatorView.stopAnimating()
            self?.imageView.image = image
        }
    }
}
