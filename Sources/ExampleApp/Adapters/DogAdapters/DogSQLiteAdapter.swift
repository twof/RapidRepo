import Repository
import FluentSQLite

struct DogSQLiteAdapter: DogAdapterProtocol, SQLiteAdapter {
    func get(id: Dog.ID, on worker: Worker) throws -> EventLoopFuture<Dog?> {
        return try DataSourceType.DatabaseType().newConnection(on: worker).flatMap { (conn) in
            return ModelType.find(id, on: conn)
        }
    }
}
