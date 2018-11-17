import FluentSQLite
import Vapor
import Foundation

//protocol CrudDataSource: DataSource {
//    associatedtype ModelType: Model
//    associatedtype SourceLocation: Location
//
//    func read(id: ModelType.ID) throws -> ModelType?
//    func readAll() throws -> [ModelType]
//    func create(model: ModelType) throws -> ModelType.ID
//    func update(model: ModelType) throws -> ModelType?
//    func delete(_ id: ModelType.ID) throws -> ModelType?
//}
public final class Repository: Container, Service {
    public var config: Config

    public var environment: Environment

    public var services: Services

    public var serviceCache: ServiceCache

    public convenience init(
        config: Config = .init(),
        environment: Environment = .development,
        services: Services = .init()
    ) {
        self.init(config, environment, services)
    }

    /// Internal initializer. Creates an `Application` without booting providers.
    internal init(_ config: Config, _ environment: Environment, _ services: Services) {
        self.config = config
        self.environment = environment
        self.services = services
        self.serviceCache = .init()
    }

    public func register<S: AdapterSet>(adapterSet: S) {
        self.services.register(adapterSet)
    }

    public func get<S: AdapterSet>(adapterSet: S.Type) throws -> S {
        return try self.make(adapterSet)
    }
}
