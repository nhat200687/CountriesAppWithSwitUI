//
//  CountryMapView.swift
//  Countries
//
//  Created by Hatana on 26/05/2021.
//

import SwiftUI
import MapKit

struct CountryMapView: View {
    
//    var coordinate: CLLocationCoordinate2D
    var iso2: String
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.491, longitude: 105.314),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(iso2: iso2)
            }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
    
    private func setRegion(iso2: String) {
        
//        if #available(iOS 13.0, *) {}
        
        let searchReq = MKLocalSearch.Request()
        searchReq.naturalLanguageQuery = iso2
        
        let search = MKLocalSearch(request: searchReq)
        
        search.start {
            (response, error) in
            
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            region = response.boundingRegion
            
            
        }
        
    }
}

struct CountryMapView_Previews: PreviewProvider {
    static var previews: some View {
        CountryMapView(iso2: "VN")
    }
}
