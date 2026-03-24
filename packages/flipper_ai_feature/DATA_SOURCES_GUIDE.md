# Data Source Connection Guide

## Overview

The Flipper AI Feature now supports connecting to external data sources, allowing users to ask questions about their data directly in the AI chat. Starting with **Supabase** support, with plans to add more data sources in the future.

## Features

- 🔌 **Easy Connection** - Connect your data sources with a simple dialog
- 🔒 **Secure Storage** - Credentials stored securely on your device
- 📊 **Schema Discovery** - Automatically discover tables and columns
- 🔍 **Search & Query** - Search across your data and execute queries
- 📈 **Data Visualization** - Visualize your data with charts and graphs
- 🔄 **Multi-Source Support** - Connect multiple data sources simultaneously

## Supported Data Sources

### Currently Supported
- ✅ **Supabase** - Full support for Supabase databases

### Coming Soon
- 🔄 PostgreSQL
- 🔄 MySQL
- 🔄 MongoDB
- 🔄 REST APIs
- 🔄 Google Sheets
- 🔄 CSV/JSON Files

## Quick Start

### 1. Access Data Sources

From the AI screen, you can access data source management:

```dart
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

// Navigate to data source management
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DataSourceListScreen()),
);
```

### 2. Connect a Data Source

#### Using the UI

1. Tap the **"Add Data Source"** button
2. Select **Supabase** as the data source type
3. Enter your connection details:
   - **Connection Name**: A friendly name (e.g., "Production Database")
   - **Supabase URL**: Your project URL (e.g., `https://xxxxx.supabase.co`)
   - **Anon/Public Key**: Your public API key
   - **Service Role Key** (optional): For admin operations
4. Tap **"Test Connection"** to verify
5. Tap **"Connect"** to save

#### Programmatically

```dart
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

// Create a Supabase configuration
final config = DataSourceConfig.supabase(
  id: 'my-supabase-db',
  name: 'Production Database',
  supabaseUrl: 'https://xxxxx.supabase.co',
  anonKey: 'your-anon-key',
  serviceKey: 'your-service-key', // optional
);

// Add the data source
final notifier = ref.read(dataSourceNotifierProvider);
await notifier.addDataSource(config);
```

### 3. Manage Connections

View and manage all your data source connections:

```dart
// Get all data sources
final dataSources = ref.watch(dataSourcesProvider);

// Get connection status
final statuses = ref.watch(connectionStatusesProvider);

// Connect to a data source
await notifier.connect('data-source-id');

// Disconnect from a data source
await notifier.disconnect('data-source-id');
```

## Architecture

### Components

```
flipper_ai_feature/
└── data_source/
    ├── models/
    │   └── data_source_models.dart    # Data models
    ├── services/
    │   ├── data_source_connector.dart     # Interface
    │   ├── supabase_data_source_connector.dart  # Supabase implementation
    │   └── data_source_manager.dart     # Connection manager
    ├── providers/
    │   └── data_source_provider.dart    # Riverpod providers
    └── widgets/
        ├── data_source_connection_dialog.dart  # Connection UI
        ├── data_source_list_screen.dart        # List view
        └── data_source_detail_screen.dart      # Detail view
```

### Key Classes

#### DataSourceConfig

Configuration for a data source connection:

```dart
final config = DataSourceConfig(
  id: 'unique-id',
  name: 'My Database',
  type: DataSourceType.supabase,
  credentials: {
    'supabaseUrl': 'https://...',
    'anonKey': '...',
  },
  options: {
    'schemas': ['public'],
  },
  isActive: true,
);
```

#### DataSourceConnector

Interface for connecting to different data sources:

```dart
abstract class DataSourceConnector {
  DataSourceType get supportedType;
  Future<bool> testConnection(DataSourceConfig config);
  Future<DataSourceConnectionStatus> connect(DataSourceConfig config);
  Future<void> disconnect(DataSourceConfig config);
  Future<List<DataSourceTable>> getTables(DataSourceConfig config);
  Future<DataSourceQueryResult> executeQuery(DataSourceConfig config, String query);
  // ... more methods
}
```

#### DataSourceManager

Singleton that manages all data source connections:

```dart
final manager = DataSourceManager();
await manager.initialize();

// Add a data source
await manager.addDataSource(config);

// Get tables
final tables = await manager.getTables('data-source-id');

// Execute a query
final result = await manager.executeQuery('data-source-id', 'SELECT * FROM users');
```

## Using Connected Data in AI Chat

Once connected, the AI can access your data to answer questions:

### Example Questions

- "Show me all users from my database"
- "What's the total revenue last month?"
- "List all products with stock less than 10"
- "Create a chart of sales by category"

### How It Works

1. User asks a question about their data
2. AI analyzes the question and identifies the data source
3. AI queries the connected data source
4. Results are displayed with optional visualization

```dart
// In your AI service, you can access data sources:
final manager = ref.read(dataSourceManagerProvider);

// Get connected data sources
final connectedSources = ref.watch(connectedDataSourcesProvider);

if (connectedSources.isNotEmpty) {
  // Query the data source
  final tables = await manager.getTables(connectedSources.first.id);
  
  // Execute a query
  final result = await manager.executeQuery(
    connectedSources.first.id,
    'SELECT * FROM users LIMIT 10',
  );
  
  // Use the data in AI response
  return result.data;
}
```

## Supabase Setup

### Prerequisites

1. A Supabase project ([sign up at supabase.com](https://supabase.com))
2. Project URL and API keys

### Getting Your Credentials

1. **Supabase URL**
   - Go to your Supabase project
   - Navigate to **Settings** → **API**
   - Copy the **Project URL**

2. **Anon/Public Key**
   - In the same **API** settings page
   - Copy the **anon public** key
   - This key is safe to use in client applications

3. **Service Role Key** (Optional)
   - Also in the **API** settings page
   - Copy the **service_role** key
   - ⚠️ **Warning**: This key bypasses RLS policies - use carefully

### Security Best Practices

- ✅ Use the **Anon key** for read-only operations
- ✅ Enable **Row Level Security (RLS)** in Supabase
- ✅ Create specific policies for AI access
- ⚠️ Only use **Service Role key** if absolutely necessary
- ⚠️ Never commit keys to version control

### Example RLS Policy for AI

```sql
-- Create a policy that allows AI to read specific tables
CREATE POLICY "AI can read products"
ON products FOR SELECT
USING (true);

-- Or restrict to authenticated users only
CREATE POLICY "AI can read orders for authenticated users"
ON orders FOR SELECT
USING (auth.role() = 'authenticated');
```

## Adding New Data Source Types

To add support for a new data source type:

### 1. Add the Type

```dart
enum DataSourceType {
  supabase,
  postgresql,  // Add new type
  // ...
}
```

### 2. Create a Connector

```dart
class PostgreSQLDataSourceConnector extends BaseDataSourceConnector {
  @override
  DataSourceType get supportedType => DataSourceType.postgresql;

  @override
  Future<DataSourceConnectionStatus> connect(DataSourceConfig config) async {
    // Implement connection logic
  }

  @override
  Future<List<DataSourceTable>> getTables(DataSourceConfig config) async {
    // Implement table discovery
  }

  // ... implement other methods
}
```

### 3. Register the Connector

```dart
final manager = DataSourceManager();
manager.registerConnector(PostgreSQLDataSourceConnector());
```

### 4. Update UI

Add the new type to the dropdown in `DataSourceConnectionDialog`:

```dart
DropdownMenuItem(
  value: DataSourceType.postgresql,
  child: Row(
    children: [
      Icon(Icons.storage, size: 20),
      SizedBox(width: 8),
      Text('PostgreSQL'),
    ],
  ),
),
```

## API Reference

### Models

#### DataSourceConfig

| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique identifier |
| `name` | String | Friendly name |
| `type` | DataSourceType | Type of data source |
| `credentials` | Map<String, dynamic> | Connection credentials |
| `options` | Map<String, dynamic> | Additional options |
| `isActive` | bool | Whether the connection is active |
| `createdAt` | DateTime? | Creation timestamp |
| `updatedAt` | DateTime? | Last update timestamp |

#### DataSourceTable

| Property | Type | Description |
|----------|------|-------------|
| `name` | String | Table name |
| `schema` | String? | Schema name |
| `columns` | List<DataSourceColumn> | Column information |
| `rowCount` | int? | Number of rows |
| `metadata` | Map<String, dynamic>? | Additional metadata |

#### DataSourceQueryResult

| Property | Type | Description |
|----------|------|-------------|
| `data` | List<Map<String, dynamic>> | Query results |
| `columns` | List<DataSourceColumn> | Column information |
| `totalRows` | int | Total number of rows |
| `executionTime` | Duration | Query execution time |
| `query` | String? | Executed query |
| `error` | String? | Error message if failed |

### Providers

#### Reading Data

```dart
// Get all data sources
final dataSources = ref.watch(dataSourcesProvider);

// Get a specific data source
final dataSource = ref.watch(dataSourceProvider(dataSourceId));

// Get connection statuses
final statuses = ref.watch(connectionStatusesProvider);

// Get tables from a data source
final tables = await ref.watch(tablesProvider(dataSourceId).future);

// Get table sample data
final sample = await ref.watch(tableSampleProvider(dataSourceId, 'users').future);
```

#### Modifying Data

```dart
final notifier = ref.read(dataSourceNotifierProvider);

// Add a data source
await notifier.addDataSource(config);

// Update a data source
await notifier.updateDataSource(config);

// Remove a data source
await notifier.removeDataSource(dataSourceId);

// Connect/disconnect
await notifier.connect(dataSourceId);
await notifier.disconnect(dataSourceId);
```

## Troubleshooting

### Connection Issues

**Problem**: "Failed to connect to data source"

**Solutions**:
1. Verify your Supabase URL is correct (should start with `https://`)
2. Check that your API key is valid
3. Ensure your Supabase project is active
4. Check network connectivity
5. Verify firewall settings allow HTTPS traffic

**Problem**: "Connection test failed"

**Solutions**:
1. Click "Test Connection" to see detailed error
2. Check Supabase dashboard for any service outages
3. Verify RLS policies allow access
4. Try using the service role key (temporarily for testing)

### Data Access Issues

**Problem**: "No tables found"

**Solutions**:
1. Ensure your database has tables
2. Check the schema filter (default is 'public')
3. Verify the connected user has read permissions
4. Check RLS policies

**Problem**: "Query execution failed"

**Solutions**:
1. Review the error message for details
2. Check table and column names
3. Verify SQL syntax
4. Ensure adequate permissions

## Examples

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

class MyDataSourcesPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSources = ref.watch(dataSourcesProvider);
    final notifier = ref.read(dataSourceNotifierProvider);

    // Initialize on first build
    useEffect(() {
      ref.read(initDataSourceManagerProvider);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text('My Data Sources')),
      body: dataSources.isEmpty
          ? Center(
              child: Text('No data sources connected'),
            )
          : ListView.builder(
              itemCount: dataSources.length,
              itemBuilder: (context, index) {
                final dataSource = dataSources[index];
                return ListTile(
                  title: Text(dataSource.name),
                  subtitle: Text(dataSource.type.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => notifier.removeDataSource(dataSource.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => DataSourceConnectionDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Querying Data

```dart
class DataQueryExample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectedSources = ref.watch(connectedDataSourcesProvider);

    if (connectedSources.isEmpty) {
      return Text('No data sources connected');
    }

    final firstSource = connectedSources.first;
    final tablesAsync = ref.watch(tablesProvider(firstSource.id));

    return tablesAsync.when(
      data: (tables) => ListView.builder(
        itemCount: tables.length,
        itemBuilder: (context, index) {
          final table = tables[index];
          return ExpansionTile(
            title: Text(table.name),
            children: [
              ...table.columns.map((column) => ListTile(
                title: Text(column.name),
                subtitle: Text(column.type),
              )),
            ],
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## Future Enhancements

- [ ] **PostgreSQL Support** - Direct PostgreSQL database connections
- [ ] **MySQL Support** - MySQL database integration
- [ ] **MongoDB Support** - NoSQL database connectivity
- [ ] **REST API Connector** - Connect to any REST API
- [ ] **Google Sheets** - Spreadsheet integration
- [ ] **File Upload** - CSV/JSON file analysis
- [ ] **Query Builder** - Visual query builder for non-technical users
- [ ] **Data Preview** - Preview data before connecting
- [ ] **Advanced Filters** - Filter tables and columns
- [ ] **Custom Schemas** - Support for multiple schemas
- [ ] **Connection Pooling** - Optimize connection management
- [ ] **Offline Support** - Cache schema information locally

## Contributing

To contribute new data source connectors:

1. Create a new connector class implementing `DataSourceConnector`
2. Add tests for your connector
3. Update the documentation
4. Submit a pull request

## Support

For issues or questions:
- 📖 Check the [README.md](README.md)
- 🐛 Report bugs on GitHub
- 💬 Ask questions in discussions

## License

This feature is part of the Flipper project and follows the same license.
