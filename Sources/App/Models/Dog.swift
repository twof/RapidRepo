import Vapor
import FluentSQLite

struct Dog: SQLiteModel, Content {
    var id: Int?
    var name: String
    var age: Int
}
