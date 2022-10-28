//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/20.
//

import MapKit

public extension MKMapView {
    func addPin(location: CLLocationCoordinate2D, title: String, subtitle: String, zoomTo: Bool = false) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        self.addAnnotation(annotation)
        if zoomTo {
            let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.setRegion(coordinateRegion, animated: true)
        }
    }
}
