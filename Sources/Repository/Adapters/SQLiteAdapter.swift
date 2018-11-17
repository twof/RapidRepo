import FluentSQLite

public protocol SQLiteAdapter: ModelDataSourceAdapter where DataSourceType == SQLiteDataSource { }
