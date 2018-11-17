import FluentSQLite

public protocol SQLiteAdapter: ModelDataSourceAdapter where DataSourceType: DBDataSource, DataSourceType.DatabaseType == SQLiteDatabase { }
