# Data Source Feature - UI Access Guide

## How to Access Data Source Connection

The data source connection feature is now integrated into the AI Assistant screen. Here's how to access it:

### 📱 Mobile Layout

1. Open the **AI Assistant** from the main navigation
2. Look at the **top app bar**
3. Tap the **storage/database icon** (📊) labeled "Data Sources"
4. This opens the Data Source Management screen

### 🖥️ Desktop Layout

1. Open the **AI Assistant** from the main navigation
2. Look at the **header bar** above the chat area
3. On the **right side**, you'll see the **storage/database icon** (📊)
4. Click it to open the Data Source Management screen

## UI Location

```
┌─────────────────────────────────────────┐
│  ☰  AI Assistant     📊  [Model]       │  ← Top Bar
├─────────────────────────────────────────┤
│                                         │
│   💬 Chat messages...                  │
│                                         │
├─────────────────────────────────────────┤
│  [Type message...]  [📎] [🎤] [➤]      │
└─────────────────────────────────────────┘
         ↑
    Data Source Button (📊)
```

## What You Can Do

Once you access the Data Source Management screen:

### 1. **Add Your First Data Source**
   - Click **"Add Data Source"** button
   - Select **Supabase** (or other supported types)
   - Enter your credentials
   - Test the connection
   - Save

### 2. **View Connected Data Sources**
   - See all your connected data sources
   - Check connection status (Connected/Disconnected/Error)
   - View tables and schemas
   - See row counts and metadata

### 3. **Manage Connections**
   - Edit existing connections
   - Disconnect/reconnect
   - Delete unused data sources
   - Test connections

### 4. **Use with AI**
   - Once connected, ask the AI about your data
   - Example questions:
     - "Show me all users from my database"
     - "What's the total revenue last month?"
     - "Create a chart of sales by category"

## Icon Description

The data source button uses the **`Icons.storage`** icon, which looks like:
- A database cylinder icon (📊)
- Colored to match the AI theme
- Includes a tooltip "Data Sources"

## Navigation Flow

```
AI Assistant Screen
    ↓ (Tap Data Source Icon)
Data Source List Screen
    ↓ (Tap "Add Data Source")
Connection Dialog
    ↓ (Fill & Save)
Back to List Screen
    ↓ (Tap a data source)
Detail Screen (view tables)
```

## Quick Access Tips

- **Mobile**: The icon is in the top app bar, next to the model selector
- **Desktop**: The icon is in the header bar, on the right side
- **Tooltip**: Hover over the icon to see "Data Sources" label
- **Back navigation**: Use the back button to return to AI chat

## Troubleshooting

### Can't see the icon?
- Make sure you're on the AI Assistant screen
- Check if you're logged in
- Try refreshing the app

### Icon is disabled?
- Check your internet connection
- Verify you have permission to access AI features

### Navigation doesn't work?
- Try closing and reopening the AI screen
- Check for any error messages in the console
- Ensure all dependencies are properly installed

## Code Location

If you need to modify the UI:

```dart
// File: packages/flipper_ai_feature/lib/src/screens/ai_screen.dart

// Mobile layout - line ~720
AppBar _buildMobileAppBar(...) {
  // Data Source Button added here
  IconButton(
    icon: Icon(Icons.storage),
    onPressed: () => navigate to DataSourceListScreen(),
  )
}

// Desktop layout - line ~830
_buildDesktopLayout(...) {
  // Data Source Button in header
  IconButton(
    icon: Icon(Icons.storage),
    onPressed: () => navigate to DataSourceListScreen(),
  )
}
```

## Next Steps

After connecting your data source:
1. Return to the AI chat
2. Ask questions about your data
3. View visualizations
4. Get insights from your business data

---

**Happy analyzing! 🎉**
