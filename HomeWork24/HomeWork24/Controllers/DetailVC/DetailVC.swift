//
//  DetailVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import UIKit
import CoreLocation
import MapKit

final class DetailVC: UIViewController {
    var user: User?
    var urlPhoto: String?
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var webSiteLbl: UILabel!
    @IBOutlet var adressLbl: UILabel!
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func allPostsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postsVC = storyboard.instantiateViewController(withIdentifier: "PostsVC") as! PostsVC
        postsVC.userId = user?.id
        navigationController?.pushViewController(postsVC, animated: true)
    }

    @IBAction func openMap(_ sender: Any) {
        openMapForPlace()
    }
    private func setupUI() {
        guard let user = user else { return }
        nameLbl.text = user.name
        userNameLbl.text = user.username
        emailLbl.text = user.email
        phoneLbl.text = user.phone
        webSiteLbl.text = user.website
        adressLbl.text = (user.address?.city)! + ", " + (user.address?.street)!

        guard let urlPhoto = urlPhoto, let url = URL(string: urlPhoto) else { return }

        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, _ in

            guard let self else { return }
            DispatchQueue.main.async {
                if let data = data,
                   let image = UIImage(data: data)
                {
                    self.imageView.image = image
                    self.imageView.layer.cornerRadius = 25
                }
            }
        }.resume()
    }

    func openMapForPlace() {
        let latitude = CLLocationDegrees((user?.address?.geo?.lat)!)
        let longitude = CLLocationDegrees((user?.address?.geo?.lng)!)

        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude!, longitude!)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }
}
