//
//  CountryList.swift
//  Countries
//
//  Created by Ha Thanh Nhat on 25/05/2021.
//

import SwiftUI

struct CountryList: View {
    
    var countries: [Country] = ViewModel().countries
    var continents: [Continent] = ViewModel().continents
    @State private var selectedIdContinent: Int = 0
    
    var body: some View {
        
        NavigationView {
            List {
                
                HStack {
                    
                    Spacer()
                    
                    Picker("Continent: ", selection: $selectedIdContinent) {
                        
                        Text("ALL")
                            .tag(0)
                    
                        ForEach(continents) { continent in
                            Text("\(continent.name)")
                        }

                    }

                    Text("\(continents.first{$0.id == selectedIdContinent}?.name ?? "All")")
                    
                }
                .pickerStyle(MenuPickerStyle())
                
                ForEach(continents.filter{$0.id == selectedIdContinent || selectedIdContinent == 0 }) { continent in
                    Section(header: Text("\(continent.name)")) {

                        ForEach( countries.filter {$0.continentId == continent.id} ) { country in

                            NavigationLink(destination: CountryDetail(country: country)) {
                        
                                CountryRow(country: country)
                            }

                        }
                    }
                }
            }
            .navigationTitle("Countries")
            
        }
        
    }
}

struct CountryList_Previews: PreviewProvider {
    static var previews: some View {
        CountryList()
    }
}
