import Repository
import FluentSQLite

protocol DogAdapterProtocol: ModelDataSourceAdapter where ModelType == Dog {
    func get(id: ModelType.ID, on worker: Worker) throws -> Future<Dog?>
}
