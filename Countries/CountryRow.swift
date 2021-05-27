//
//  CountryRow.swift
//  Countries
//
//  Created by Hatana on 24/05/2021.
//

import SwiftUI

struct CountryRow: View {
    
    var country: Country
    
    var body: some View {
        HStack() {
            Text(country.flag)
                .font(.title)
            Text(country.name)
                .font(.headline)
        }
        
    }
}

struct CountryRow_Previews: PreviewProvider {
    
    static let countries: [Country] = ViewModel().countries
    
    static var previews: some View {
        Group {
            CountryRow(country: countries.randomElement()!)
            CountryRow(country: countries.randomElement()!)
            CountryRow(country: countries.randomElement()!)
            CountryRow(country: countries.randomElement()!)
        }
        .previewLayout(.fixed(width: 400, height: 70))
        
    }
}
