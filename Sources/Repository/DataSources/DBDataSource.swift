import Fluent

public protocol DBDataSource: DataSource where SourceLocation == DatabaseLocation {
    associatedtype DatabaseType: Database
}
