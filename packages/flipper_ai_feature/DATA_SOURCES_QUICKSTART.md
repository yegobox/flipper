# Data Source Connection - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Access Data Sources

From your AI screen, add a button to access data source management:

```dart
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

// Add this button somewhere in your UI
IconButton(
  icon: Icon(Icons.storage),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DataSourceListScreen()),
    );
  },
  tooltip: 'Data Sources',
)
```

### Step 2: Connect to Supabase

1. **Tap "Add Data Source"**
2. **Select "Supabase"**
3. **Fill in the details**:
   ```
   Connection Name: My Production Database
   Supabase URL: https://xxxxx.supabase.co
   Anon Key: eyJhbGc... (from Supabase Settings → API)
   Service Key: (optional, for admin operations)
   ```
4. **Tap "Test Connection"** ✅
5. **Tap "Connect"** 🎉

### Step 3: Explore Your Data

Once connected:
- View all your tables
- See column schemas
- Get sample data
- Check row counts

### Step 4: Ask Questions!

Now you can ask the AI about your data:

```
"Show me all users from my database"
"What's the total revenue last month?"
"List products with low stock"
"Create a chart of sales by category"
```

## 📋 Complete Example

### Full Implementation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_ai_feature/flipper_ai_feature.dart';

class MyAiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AI Assistant'),
          actions: [
            // Data Sources Button
            IconButton(
              icon: Icon(Icons.storage),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataSourceListScreen(),
                  ),
                );
              },
              tooltip: 'Data Sources',
            ),
          ],
        ),
        body: AiScreen(), // Your existing AI screen
      ),
    );
  }
}
```

### Programmatic Connection

```dart
class ConnectButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dataSourceNotifierProvider);

    return ElevatedButton.icon(
      icon: Icon(Icons.add_link),
      label: Text('Connect Database'),
      onPressed: () async {
        // Create configuration
        final config = DataSourceConfig.supabase(
          id: DateTime.now().toString(),
          name: 'My Database',
          supabaseUrl: 'https://xxxxx.supabase.co',
          anonKey: 'your-anon-key',
        );

        // Test connection
        final isConnected = await notifier.testConnection(config);
        
        if (isConnected) {
          // Add the data source
          await notifier.addDataSource(config);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connected successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}
```

### View Connected Data

```dart
class DataTablesView extends HookConsumerWidget {
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
          return ListTile(
            title: Text(table.name),
            subtitle: Text('${table.columns.length} columns'),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## 🔑 Getting Supabase Credentials

### 1. Go to Supabase Dashboard
Visit [https://supabase.com](https://supabase.com) and log in

### 2. Select Your Project
Choose the project you want to connect

### 3. Navigate to Settings → API
Find your API credentials

### 4. Copy Required Values
```
Project URL: https://xxxxx.supabase.co
anon public: eyJhbGc...
service_role: eyJhbGc... (optional)
```

### 5. Paste in Connection Dialog
Return to your app and paste the values

## ✅ Verification Checklist

After connecting, verify:
- [ ] Connection status shows "Connected" ✅
- [ ] Tables are listed
- [ ] Can view table schemas
- [ ] Can see sample data
- [ ] No error messages

## ❓ Troubleshooting

### "Connection Test Failed"
**Solution**: 
1. Check URL is correct (must start with `https://`)
2. Verify API key is valid
3. Ensure network connection
4. Check Supabase project is active

### "No Tables Found"
**Solution**:
1. Verify database has tables
2. Check you're using correct schema (default: 'public')
3. Ensure user has read permissions

### "Import Errors"
**Solution**:
```bash
flutter pub get
melos bootstrap
```

## 🎯 Next Steps

Once connected:
1. ✅ Explore your data structure
2. ✅ Ask the AI questions about your data
3. ✅ View data visualizations
4. ✅ Connect additional data sources
5. ✅ Share with your team

## 📚 More Resources

- **Full Guide**: `DATA_SOURCES_GUIDE.md`
- **Implementation**: `DATA_SOURCES_IMPLEMENTATION.md`
- **API Reference**: See inline documentation

## 🆘 Need Help?

- Check the full documentation
- Review example code
- Test with a sample Supabase project first
- Contact support for issues

---

**Happy Connecting! 🎉**
