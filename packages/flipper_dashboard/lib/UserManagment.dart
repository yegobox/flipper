import 'package:flipper_dashboard/tenant_add.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final List<User> users = [
    User('John Doe', 'john.doe@example.com', ['Word', 'Excel', 'PowerPoint']),
    User('Jane Smith', 'jane.smith@example.com',
        ['Outlook', 'Teams', 'OneDrive']),
    User('Bob Johnson', 'bob.johnson@example.com',
        ['Access', 'Project', 'Visio']),
    User('Alice Brown', 'alice.brown@example.com',
        ['OneNote', 'SharePoint', 'Skype']),
  ];

  List<User> _filteredUsers = [];
  // ignore: unused_field
  String _searchQuery = '';
  bool _isSearchExpanded = false;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _filteredUsers = users;
  }

  void _searchUsers(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = users
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });
  }

  void _toggleUserSelection(User user) {
    setState(() {
      if (_selectedUser == user) {
        _selectedUser = null;
      } else {
        _selectedUser = user;
      }
    });
  }

  void _addAllowedApp(String app) {
    if (_selectedUser != null) {
      setState(() {
        _selectedUser!.allowedApps.add(app);
      });
    }
  }

  void _addNewUser(User newUser) {
    setState(() {
      users.add(newUser);
      _filteredUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          if (_isSearchExpanded)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  onChanged: _searchUsers,
                  decoration: InputDecoration(
                    hintText: 'Search users',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideLayout(constraints);
          } else {
            return _buildNormalLayout();
          }
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                _showAddUserDialog(context);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalLayout() {
    return ListView.builder(
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        return UserListItem(
          user: _filteredUsers[index],
          onTap: () => _toggleUserSelection(_filteredUsers[index]),
          isSelected: _selectedUser == _filteredUsers[index],
        );
      },
    );
  }

  Widget _buildWideLayout(BoxConstraints constraints) {
    final double listWidth = _selectedUser != null
        ? constraints.maxWidth * 0.6
        : constraints.maxWidth;
    return Row(
      children: [
        SizedBox(
          width: listWidth,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
            ),
            itemCount: _filteredUsers.length,
            itemBuilder: (context, index) {
              return UserListItem(
                user: _filteredUsers[index],
                onTap: () => _toggleUserSelection(_filteredUsers[index]),
                isSelected: _selectedUser == _filteredUsers[index],
              );
            },
          ),
        ),
        if (_selectedUser != null)
          SizedBox(
            width: constraints.maxWidth * 0.4,
            child: AllowedAppsPanel(
              user: _selectedUser!,
              onAddApp: _addAllowedApp,
            ),
          ),
      ],
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TenantAdd();
      },
    );
  }
}

class UserListItem extends StatefulWidget {
  final User user;
  final VoidCallback onTap;
  final bool isSelected;

  const UserListItem({
    Key? key,
    required this.user,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.blue.withOpacity(0.1)
                : (_isHovered ? Colors.white : Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(4),
            boxShadow: _isHovered || widget.isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(widget.user.name[0],
                    style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold)),
              ),
              title: Text(
                widget.user.name,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(widget.user.email),
              trailing: IconButton(
                icon: Icon(Icons.more_horiz, color: Colors.grey),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AllowedAppsPanel extends StatefulWidget {
  final User user;
  final Function(String) onAddApp;

  const AllowedAppsPanel({
    Key? key,
    required this.user,
    required this.onAddApp,
  }) : super(key: key);

  @override
  _AllowedAppsPanelState createState() => _AllowedAppsPanelState();
}

class _AllowedAppsPanelState extends State<AllowedAppsPanel> {
  final TextEditingController _appController = TextEditingController();

  @override
  void dispose() {
    _appController.dispose();
    super.dispose();
  }

  void _addApp() {
    if (_appController.text.isNotEmpty) {
      widget.onAddApp(_appController.text);
      _appController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Allowed Apps for ${widget.user.name}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _appController,
                  decoration: InputDecoration(
                    hintText: 'Enter app name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addApp,
                child: Text('Add App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0078D7),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: TextStyle(fontSize: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.user.allowedApps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.app_shortcut, color: Colors.blue),
                  title: Text(
                    widget.user.allowedApps[index],
                    style: TextStyle(fontSize: 14),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final List<String> allowedApps;

  User(this.name, this.email, this.allowedApps);
}
