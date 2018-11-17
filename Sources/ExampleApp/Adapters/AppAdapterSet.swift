import Repository
import FluentSQLite

struct AppAdapterSet<ModelType: SQLiteModel, DBAdapterType: SQLiteAdapter, MockAdapterType: MockAdapter>: AdapterSet {
    let dbAdapater: DBAdapterType
    let mockAdapter: MockAdapterType
}
