# RapidRepo
RapidRepo is a Vapor framework that provides structure to assist users setting up a modified version of [the repository pattern](https://docs.vapor.codes/3.0/extras/style-guide/#architecture) within their own apps.

## Installation


## Architecture
A set of `DataSource`s are established by the app owner that all models submitted to the repository must adapt to. For example, if the app owner wishes to use a Redis cache, a Postgres database, and and use mock data for testing, each model will have to set up adaptors for each of those data sources.

## Usage
You can set up your models just like you would normally.

```swift
import Vapor
import FluentSQLite

struct Dog: SQLiteModel, Content {
    var id: Int? 
    var name: String
    var age: Int
}
```

You can then establish your data sources by setting up an `AdapterSet`. The `AdapterSet` represents the set of Adapters that all models will need to have.

This `AdapterSet` establishes the requirement for database and mock adapters

```swift
struct AppAdapterSet<ModelType: SQLiteModel, DBAdapterType: SQLiteAdapter, MockAdapterType: MockAdapter>: AdapterSet {
    let dbAdapater: DBAdapterType
    let mockAdapter: MockAdapterType
}
```

You can set up a protocol with all the functionality you want all `Dog` adapters to have.

```swift
protocol DogAdapterProtocol: ModelDataSourceAdapter where ModelType == Dog {
    func get(id: ModelType.ID, on worker: Worker) throws -> Future<Dog?>
}
```

And then go ahead and set up your database and mock datasource adapters.

```swift
struct DogSQLiteAdapter: DogAdapterProtocol, SQLiteAdapter {
    func get(id: Dog.ID, on worker: Worker) throws -> EventLoopFuture<Dog?> {
        return try DataSourceType.DatabaseType().newConnection(on: worker).flatMap { (conn) in
            return ModelType.find(id, on: conn)
        }
    }
}
```

```swift
struct DogMockAdapter: DogAdapterProtocol, MockAdapter {
    func get(id: Dog.ID, on worker: Worker) throws -> EventLoopFuture<Dog?> {
        return worker.future(Dog(id: id, name: "Rex", age: 5))
    }
}
```

Now onto registering all that. 

The `AdapterSet` types get pretty long so it'll be good to have a `typealias`

```swift
typealias DogAdapterSet = AppAdapterSet<Dog, DogSQLiteAdapter, DogMockAdapter>
```

Then within `configure.swift`

```swift
let repo = Repository()
let dbDogAdapter = DogSQLiteAdapter()
let mockDogAdapter = DogMockAdapter()

let adapterSet = DogAdapterSet(dbAdapater: dbDogAdapter, mockAdapter: mockDogAdapter)

repo.register(adapterSet: adapterSet)

services.register(repo, as: Repository.self)
```

and finally you can use your repository.

Within `routes.swift`:

```swift
router.get("repoTest") { req -> Future<Dog> in
    let dogMocks = try req.make(Repository.self).make(DogAdapterSet.self).mockAdapter

    return try dogMocks.get(id: 20, on: req).unwrap(or: Abort(.notFound))
}
```
