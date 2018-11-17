import Service

public protocol DataSource: Service {
    associatedtype SourceLocation: Location
}
