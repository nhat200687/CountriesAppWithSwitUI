//
//  CountryDetail.swift
//  Countries
//
//  Created by Hatana on 26/05/2021.
//

import SwiftUI

struct CountryDetail: View {
    
    var country: Country
    
    var body: some View {
        ScrollView {
            VStack {
                CountryMapView(iso2: country.iso2)
                    .frame(height: 200)
                    .ignoresSafeArea(edges: .top)
                
                Text(country.flag)
                    .font(.system(size: 128.0))
                    .offset(y: -120)
                    .padding(.bottom, -120)
                
                Text(country.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top, -30)
                
                Divider()
                
                Text(country.description)
                    .font(.body)
                    .padding()
                    .frame(alignment: .topLeading)
                
            }
        }
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static let country = ViewModel().countries.randomElement()!
    static var previews: some View {
        CountryDetail(country: country)
    }
}
