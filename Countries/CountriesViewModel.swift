//
//  CountriesViewModel.swift
//  Countries
//
//  Created by Hatana on 24/05/2021.
//

import Foundation
import SQLite3

public class ViewModel {
    private let fileNameDb = "cowo"
    private var db: OpaquePointer? = nil
    
    var countries = [Country]()
    var continents = [Continent]()
    
    init() {
       
        guard let db = DbHelper.openDb(self.fileNameDb) else {
           return
        }
        
        self.db = db
        
        self.countries = DbHelper.getCountriesDb(db: self.db!)
        self.continents = DbHelper.getContinentsDb(db: self.db!)
    }
    
    deinit {
        if self.db != nil {
            DbHelper.closeDb(self.db!)
        }
    }
    
}

public struct DbHelper {
    
    static func openDb(_ fileName: String) -> OpaquePointer? {
        guard let urlDb = Bundle.main.url(forResource: fileName, withExtension: "sqlite3") else {
            return nil
        }
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(urlDb.path, &db) == SQLITE_OK {
            print("Database has been opened with path \(urlDb.path).")
        } else {
            print("There is error in opening database with path \(urlDb.path).")
        }
        
        return db
    }

    static func closeDb(_ db: OpaquePointer) {
        sqlite3_close(db)
    }

    static func prepareStmDb(db: OpaquePointer, stm: String, bindValues: Any ...) -> OpaquePointer? {
        var query: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(db, stm, -1, &query, nil) == SQLITE_OK else {
            print("The query is invalid.")
            return nil
        }
        
        for (index, value) in bindValues.enumerated() {
            switch value {
            case is String:
                sqlite3_bind_text(query, Int32(index + 1), (String(describing: value) as NSString).utf8String, -1, nil)
            case is Int:
                let v = Int32(String(describing: value))
                if v != nil {
                    sqlite3_bind_int(query, Int32(index + 1), v!)
                }
            default:
                continue
               
            }
        }
        
        debugPrint("Full Statement SQL:", String(cString: sqlite3_expanded_sql(query)), separator: "\t")
        
        return query
    }

    static func getRowDb(_ query: OpaquePointer?) -> Int32 {
        return sqlite3_step(query)
    }

    static func getCountriesDb(db: OpaquePointer, pk: Int = -1) -> [Country] {
        
        let opt: String = (pk == -1) ? "OR" : "AND"
        
        let stm: String = "select * from cowo_country where id = ? \(opt) status = 1;"
        
        let query = prepareStmDb(db: db, stm: stm, bindValues: pk)
        
        var countries = [Country]()
        while getRowDb(query) == SQLITE_ROW {
            let vId: Int = Int(sqlite3_column_int(query, 0))
            let vIso2: String = String(cString: sqlite3_column_text(query, 1))
            let vName: String = String(cString: sqlite3_column_text(query, 4))
            let vCapital: String = String(cString: sqlite3_column_text(query, 7))
            let vDescription: String = String(cString: sqlite3_column_text(query, 8))
            let vLat: Double = sqlite3_column_double(query, 12)
            let vLon: Double = sqlite3_column_double(query, 13)
            let vContinentId: Int = Int(sqlite3_column_int(query, 27))
            
            let country = Country(id: vId, iso2: vIso2, name: vName, capital: vCapital, description: vDescription, lat: vLat, lon: vLon, continentId: vContinentId)
            
            countries.append(country);
        }
        
        sqlite3_finalize(query)
        
        return countries
    }
    
    static func getContinentsDb(db: OpaquePointer) -> [Continent] {
        let stm: String = "select * from cowo_continent where status = 1;"
        
        let query = prepareStmDb(db: db, stm: stm)
        
        var continents = [Continent]()
        
        while getRowDb(query) == SQLITE_ROW {
            let vId: Int = Int(sqlite3_column_int(query, 0))
            let vName: String = String(cString: sqlite3_column_text(query, 1))
            
            let continent = Continent(id: vId, name: vName)
            
            continents.append(continent)
        }
        
        sqlite3_finalize(query)
        
        return continents
    }
    
}
