import Fluent
import Service

public protocol ModelDataSourceAdapter: Service {
    associatedtype ModelType: Model
    associatedtype DataSourceType: DataSource
}
