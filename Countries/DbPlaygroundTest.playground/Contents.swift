import Foundation
import SQLite3
import PlaygroundSupport

/* ----------------------------------------Main Test---------------------------------------- */
guard let db = DbHelper.openDb("cowo") else {
    PlaygroundPage.current.finishExecution();
}


let countries: [Country] = DbHelper.getCountriesDb(db: db, pk: -1)

for country in countries {
    debugPrint(country, terminator: "\n\(String(repeating: "-", count: 150))\n")
}

DbHelper.closeDb(db)

