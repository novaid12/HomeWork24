//
//  DetailVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import CoreLocation
import MapKit
import UIKit

protocol UpdateUser {
    func updateUserData(user: User)
}

final class DetailVC: UIViewController {
    var userData: User?
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var webSiteLbl: UILabel!
    @IBOutlet var adressLbl: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var openMapBtn: UIButton!

    override func viewDidLoad() {
        setupUI()
    }

    @IBAction func allPostsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postsVC = storyboard.instantiateViewController(withIdentifier: "PostsVC") as! PostsVC
        postsVC.userId = userData?.id
        navigationController?.pushViewController(postsVC, animated: true)
    }

    @IBAction func openMap(_ sender: Any) {
        openMapForPlace()
    }

    private func setupUI() {
        guard let user = userData else { return }
        nameLbl.text = user.name
        userNameLbl.text = user.username
        emailLbl.text = user.email
        phoneLbl.text = user.phone
        webSiteLbl.text = user.website
        adressLbl.text = (user.address?.city)! + ", " + (user.address?.street)!
        imageView.image = UIImage(systemName: "person.fill")
        openMapBtn.isHidden = userData?.address?.geo == nil ? true : false
    }

    @IBAction func editUserData(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(withIdentifier: "CreateUserVC") as! CreateUserVC
        createVC.user = userData
        createVC.editType = true
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }

    func openMapForPlace() {
        let latitude = CLLocationDegrees((userData?.address?.geo?.lat)!)
        let longitude = CLLocationDegrees((userData?.address?.geo?.lng)!)

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

extension DetailVC: UpdateUser {
    func updateUserData(user: User) {
        userData = user
        setupUI()
    }
}
