import Foundation
import SQLite3
import PlaygroundSupport

func openDb(_ fileName: String) -> OpaquePointer? {
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

func closeDb(_ db: OpaquePointer) {
    sqlite3_close(db)
}

func prepareStmDb(db: OpaquePointer, stm: String, bindValues: Any ...) -> OpaquePointer? {
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
    
    print(String(cString: sqlite3_expanded_sql(query)))
    
    return query
}

/* Note: using In-Out Parameters: https://docs.swift.org/swift-book/LanguageGuide/Functions.html# */
func getRowDb(_ query: OpaquePointer?) -> Int32 {
    return sqlite3_step(query)
}

func getCountriesDb(db: OpaquePointer, pk: Int = -1) {
    
    let opt: String = (pk == -1) ? "OR" : "AND"
    
    let stm: String = "select * from cowo_country where id = ? \(opt) status = 1;"
    
    let query = prepareStmDb(db: db, stm: stm, bindValues: pk)
    
    let countries: [Country]
    while getRowDb(query) == SQLITE_ROW {
        let id: Int = Int(sqlite3_column_int(query, 0))
        let iso2: String = String(cString: sqlite3_column_text(query, 1))
        let name: String = String(cString: sqlite3_column_text(query, 4))
        let capital: String = String(cString: sqlite3_column_text(query, 7))
        let description: String = String(cString: sqlite3_column_text(query, 8))
        let lat: Double = sqlite3_column_double(query, 12)
        let lon: Double = sqlite3_column_double(query, 13)
        let continentId: Int = Int(sqlite3_column_int(query, 27))
        
        print(name)
    }
    
    sqlite3_finalize(query)
}

/* ----------------------------------------Main Test---------------------------------------- */
guard let db = openDb("cowo") else {
    PlaygroundPage.current.finishExecution();
}

getCountriesDb(db: db, pk: -1)

closeDb(db)

