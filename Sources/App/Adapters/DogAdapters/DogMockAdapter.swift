import Repository
import Vapor

struct DogMockAdapter: DogAdapterProtocol, MockAdapter {
    func get(id: Dog.ID, on worker: Worker) throws -> EventLoopFuture<Dog?> {
        return worker.future(Dog(id: id, name: "Rex", age: 5))
    }
}
