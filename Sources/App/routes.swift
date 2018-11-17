import Vapor
import FluentSQLite
import Repository

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

    router.get("repoTest") { req -> Future<Dog> in
        let dogMocks = try req.make(Repository.self).make(DogAdapterSet.self).mockAdapter

        return try dogMocks.get(id: 20, on: req).unwrap(or: Abort(.notFound))
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
