//
//  MapVC.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import MapKit
import UIKit

class MapVC: UIViewController, MKMapViewDelegate {
    var geo: Geo?

    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self // or connect in storyboard
        createAnnotation()
    }

    func createAnnotation() {
        guard let geo = geo else { return }
        let coordinate = CLLocationCoordinate2D(latitude: geo.lat!, longitude: geo.lng!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Тут я живу"
        annotation.subtitle = "Описание места"
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}
