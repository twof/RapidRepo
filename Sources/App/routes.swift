import Vapor
import FluentSQLite
import Repository

struct Dog: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int

    static var idKey: WritableKeyPath<Dog, Int?> = \Dog.id

    var id: Int?
    var name: String
    var age: Int
}

protocol DogAdapterProtocol: ModelDataSourceAdapter where ModelType == Dog {
    func get(id: ModelType.ID, on worker: Worker) throws -> Future<Dog?>
}


struct DogSQLiteAdapter: DogAdapterProtocol, SQLiteAdapter {
    typealias DataSourceType = SQLiteDataSource

    func get(id: Dog.ID, on worker: Worker) throws -> EventLoopFuture<Dog?> {
        return try DataSourceType.DatabaseType().newConnection(on: worker).flatMap { (conn) in
            return ModelType.find(id, on: conn)
        }
    }
}

struct DogMockAdapter: DogAdapterProtocol, MockAdapter {
    typealias DataSourceType = ConcreteMockDataSource

    func get(id: Dog.ID, on worker: Worker) throws -> EventLoopFuture<Dog?> {
        return worker.future(Dog(id: 10, name: "Rex", age: 5))
    }
}

struct AppAdapterSet<ModelType: Model, DBAdapterType: SQLiteAdapter, MockAdapterType: MockAdapter>: AdapterSet {
    let dbAdapater: DBAdapterType
    let mockAdapter: MockAdapterType
}

public func repoTest() {
    let repo = Repository()
    let dbDogAdapter = DogSQLiteAdapter()
    let mockDogAdapter = DogMockAdapter()

    let adpaterSet = AppAdapterSet<Dog, DogSQLiteAdapter, DogMockAdapter>(dbAdapater: dbDogAdapter, mockAdapter: mockDogAdapter)

    repo.register(adapterSet: adpaterSet)
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    router.get("repoTest") { req in
        

        return "hello"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
