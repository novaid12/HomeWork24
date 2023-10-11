//
//  ImageVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import UIKit

final class ImageVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    private let imageURL = "https://www.usgbc.org/sites/default/files/2023-06/Photo%20credit_carles-rabada-unsplash_0.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    private func fetchImage() {
        guard let url = URL(string: imageURL) else { return }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let response = response {
                    print(response)
                }
                
                if let data = data,
                   let image = UIImage(data: data)
                {
                    self?.imageView.image = image
                } else {
                    // тут можно пользователю показать ошибку картинки
                }
            }
        }
        task.resume()
    }
}
