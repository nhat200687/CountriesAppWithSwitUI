//
//  Country.swift
//  Countries
//
//  Created by Hatana on 21/05/2021.
//

import Foundation

struct Country: CustomDebugStringConvertible, Identifiable {
    var id: Int
    var iso2: String
    var name: String
    var capital: String
    var description: String
    var lat: Double
    var lon: Double
    var continentId: Int
    
    var flag: String {
        unicodeFlag(iso2: self.iso2)
    }
    
    /* Implement the `debugDescription` property from `CustomDebugStringConvertible` protocol to convert `Country` to `String` */
    var debugDescription: String {
        
        return ["\(id)", iso2, name, capital, description, "\(lat)", "\(lon)", "\(continentId)"].joined(separator: "\t")
    }
    
    private func unicodeFlag(iso2: String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in iso2.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
